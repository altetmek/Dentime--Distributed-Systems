import { Booking } from "../models/booking.mjs";
import UserService from "../service/user.mjs";
import BookingService from "../service/booking.mjs";
import MQTTService from "../service/mqtt.mjs";
import ClinicService from "../service/clinic.mjs";
import ClinicController from "../controllers/clinic.mjs";
import DateUtil from "../util/date_util.mjs";
import mongodb from "mongodb";
import { MqttClient } from "mqtt";
var ObjectId = mongodb.ObjectId;

export default class BookingController {
  static processMessage(topic, parsedMessage) {
    console.log(
      'BookingController processMessage: got the topic: "' +
        topic +
        '", and the message: "' +
        parsedMessage +
        '"'
    );

    // Determine which method should handle the message
    switch (topic) {
      case "create":
        BookingController.create(parsedMessage, true);
        break;
      case "delete":
        BookingController.delete(parsedMessage);
        break;
      case "nextAvailable":
        BookingController.nextAvailable(parsedMessage);
        break;
    }
  }

  static async create(parsedMessage, notifyFailure) {
    const clinicID = parsedMessage.dentistid;
    let bookingTime = parsedMessage.time;
    let clinic = await ClinicService.getById(clinicID);
    clinic = await ClinicService.populateClinic(clinic);
    // Validate booking

    let apointmentTime = new Date();
    if (!parsedMessage.timeParsed) {
      apointmentTime = new Date(parsedMessage.time);
    } else {
      apointmentTime = bookingTime;
    }

    // Check if the clinic is open and has an available time slot.
    // Get bookings for this clinic where start time is less that apointmentTime,
    // and starttime + duration > apointmentTime
    const availableToBook = await ClinicController.isAvailableToBook(
      clinic,
      apointmentTime
    );

    if (!availableToBook) {
      if (notifyFailure) {
        BookingController.publishBookingFailureToMQTT(parsedMessage);
      }
      return null;
    }

    parsedMessage.duration = 30;
    // TODO: get actual user information from messsage, when user node code is updated.
    parsedMessage.dentist = parsedMessage.dentistid;
    parsedMessage.patient = parsedMessage.userid;

    // Save new booking

    const createdBooking = await BookingService.create(parsedMessage);

    // Send newly created booking to MQTT broker
    BookingController.publishNewBookingToMQTT(createdBooking);
    BookingController.publishUserBookingsToMQTT(parsedMessage.userid);
    MQTTService.publish(
      "clinics/announceAvailability",
      JSON.stringify({ clinicID }),
      false
    ); // publish to MQTT

    return createdBooking;
  }

  static async delete(bookingID) {
    let deletedBooking = await BookingService.delete(bookingID);
    console.log(deletedBooking);
  }

  static async nextAvailable(parsedMessage) {
    const standardAppointmentDuration =
      process.env.STANDARD_APPOINTMENT_DURATION;
    const latestPossibleTime = new Date(
      new Date().getTime() + DateUtil.getMillisFromDays(72)
    );
    let clinic = await ClinicService.getById(parsedMessage.dentistid);
    clinic = await ClinicService.populateClinic(clinic);

    // In order to get the next available time, we start by rounding up to the next hour, before checking available time slots.
    // The reason for this is that the user is likely not standing outside the practice, and so we would not like to book an apointment starting immediately.
    // Get current time
    let appointmentTime = new Date();
    // Move minutes, seconds and smaller down to zero
    appointmentTime.setMinutes(0, 0, 0);
    // Move hour up by 1 from current hour
    appointmentTime.setTime(
      appointmentTime.getTime() + DateUtil.getMillisFromMinutes(60)
    );

    // In order to have a while loop, we begin with isBooked as false
    let isBooked = false;
    parsedMessage.timeParsed = true;

    // Loop until we have a succesful booking, or no booking is possible in the allowed time.
    while (!isBooked) {
      // In each iteration, we progress the time to be booked by the duration of one booking, this way we know that we check all possible booking times
      // Move appointmentTime forward by one apointment duration
      appointmentTime.setTime(
        appointmentTime.getTime() +
          DateUtil.getMillisFromMinutes(standardAppointmentDuration)
      );
      // Set the time of the 'booking' to the current attempted appointmentTime
      parsedMessage.time = appointmentTime;

      const availableToBook = await ClinicController.isAvailableToBook(
        clinic,
        appointmentTime
      );

      if (availableToBook) {
        const newBooking = await BookingController.create(parsedMessage);

        console.log("Creating booking");

        // Check if the newBooking was succesdfully created in order to break the loop
        if (newBooking != null) {
          console.log("Booking succesfully created at : " + appointmentTime);
          isBooked = true;
        }
      }

      // If the attempted apointmentTime is after the latestPossibleTime, no booking could be created.
      if (appointmentTime > latestPossibleTime) {
        console.log(
          "No available appointments found before : " + appointmentTime
        );
        BookingController.publishBookingFailureToMQTT(parsedMessage);
        return;
      }
    }
  }

  static async publishNewBookingToMQTT(newBooking) {
    MQTTService.publish(
      "bookings/created/" + newBooking.patient,
      JSON.stringify({ booking: newBooking })
    );
  }

  // Publish all bookings on demand!
  static async publishAllUsersBookingsToMQTT() {
    const users = await UserService.getAll();
    users.forEach((user) => {
      const userId = user._id;
      console.log("Publishing all bookings for user: " + userId);
      BookingController.publishUserBookingsToMQTT(userId);
    });
  }

  static async publishUserBookingsToMQTT(userid) {
    const query = {
      patient: ObjectId(userid),
    };
    const bookings = await BookingService.get(query);

    MQTTService.publish(
      "bookings/" + userid,
      JSON.stringify({ bookings }),
      true
    );
  }

  static async publishBookingFailureToMQTT(parsedMessage) {
    MQTTService.publish(
      "bookings/failed/" + parsedMessage.userid,
      JSON.stringify({ time: parsedMessage.time })
    );
  }

  static async bookingsAtThisTime(clinicID, bookingTime) {
    // Get standard appointment duration in order to determine when the apointment ends
    const standardAppointmentDuration =
      process.env.STANDARD_APPOINTMENT_DURATION;

    // For code readability, we copy bookingTime into bookingStartTime
    const bookingStartTime = bookingTime;
    // Calculate the bookingEndTime as the start time, plus the number of minutes of an apointment
    let bookingEndTime = new Date();
    bookingEndTime.setTime(
      bookingTime.getTime() +
        DateUtil.getMillisFromMinutes(standardAppointmentDuration)
    );

    const query = {
      dentist: ObjectId(clinicID),
      time: {
        $lt: bookingEndTime,
        $gte: bookingStartTime,
      },
    };
    const bookings = await BookingService.get(query);
    return bookings;
  }
}
