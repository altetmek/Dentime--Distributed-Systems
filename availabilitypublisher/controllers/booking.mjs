import { Booking } from "../models/booking.mjs";
import BookingService from "../service/booking.mjs";
import MQTTService from "../service/mqtt.mjs";
import ClinicController from "../controllers/clinic.mjs";
import DateUtil from "../util/date_util.mjs";
import mongodb from "mongodb";
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
        BookingController.create(parsedMessage);
        break;
      case "delete":
        BookingController.delete(parsedMessage);
        break;
      case "nextAvailable":
        BookingController.nextAvailable(parsedMessage);
        break;
    }
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
        // $lte: bookingEndTime,
        $lt: bookingEndTime,
        $gte: bookingStartTime,
      },
    };
    const bookings = await BookingService.get(query);
    return bookings;
  }
}
