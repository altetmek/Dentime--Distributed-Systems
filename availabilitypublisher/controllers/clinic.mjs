import { Clinic } from "../models/clinic.mjs";
import OpeningHours from "../models/openinghours.mjs";
import ClinicService from "../service/clinic.mjs";
import MQTTService from "../service/mqtt.mjs";
import DateUtil from "../util/date_util.mjs";
import BookingController from "./booking.mjs";

export default class ClinicController {
  static processMessage(topic, parsedMessage) {
    console.log(
      'availabilityPublisher Controller processMessage: got the topic: "' +
        topic +
        '", and the message: "' +
        parsedMessage +
        '"'
    );

    // Determine which method should handle the message
    switch (topic) {
      case "announceAvailability":
        ClinicController.publishNextNAvailableBookings(
          parsedMessage.clinicID,
          process.env.NUMBER_APPOINTMENTS_TO_PUBLISH
        );
        break;
    }
  }

  static async isClinicOpenAtByID(clinicID, time) {
    const clinic = await ClinicService.getById(clinicID);
    if (clinic == null) {
      return false;
    }
    return await ClinicController.isClinicOpenAt(clinic, time);
  }

  static async isClinicOpenAt(clinic, time) {
    // Get day of the week, so that we know which opening hours to consider
    const dayOfWeek = DateUtil.getDayOfWeek(time);

    // Get the opening hours of the specific clinic

    const clinicOpeningHours = await this.getClinicOpeningHours(clinic);

    // Find the relevant day's opening hours for the clinic
    for (const key in clinicOpeningHours) {
      const openingHoursForDay = clinicOpeningHours[key];
      if (openingHoursForDay.day == dayOfWeek) {
        const openingTime = DateUtil.parseTime(openingHoursForDay.opening);
        let closingTime = DateUtil.parseTime(openingHoursForDay.closing);

        // Substract the durantion of a standard appointment from the closing time, in order to prevent bookings from going beyond the clinic's opening time.
        closingTime.setTime(
          closingTime -
            DateUtil.getMillisFromMinutes(
              process.env.STANDARD_APPOINTMENT_DURATION
            )
        );

        // Get online the time from the booking time, so that the date does not complicate this calculation.
        // Through this, we are able to compare the times directly, as they are all in milliseconds, referenced from the start of a given day (the same given day)
        const bookingTime = DateUtil.parseTime(
          time.getHours() + ":" + time.getMinutes()
        );

        // Compare bookingTime to the opening, and modified closing time of the clinic, to ensure that it falls withing their opening hours
        return openingTime <= bookingTime && bookingTime <= closingTime;
      }
    }
  }

  static async getClinicOpeningHours(clinic) {
    const openingHoursByDayOfWeek = [];
    for (const key in clinic.openinghours) {
      const openingHours = clinic.openinghours[key];
      const temp = openingHours.hours.split("-");
      openingHoursByDayOfWeek.push({
        day: openingHours.day,
        opening: temp[0],
        closing: temp[1],
      });
    }
    return openingHoursByDayOfWeek;
  }

  /* Function to determine that the clinic is
   * - Open for the duration of the attempted booking
   * - Has an available time for the duration of the attempted booking
   */
  static async isAvailableToBook(clinic, bookingTime) {
    // Not possible to book if the clinic does not exist
    if (clinic == null) return false;

    // Not possible to book if the clinic is closed
    const isClinicOpenAt = await ClinicController.isClinicOpenAt(
      clinic,
      bookingTime
    );
    if (!isClinicOpenAt) return false;

    // Find all bookings that co-incide with this bookingTime
    // This way, we can compare the number of bookings at the same time, with the number of dentists who work at the clinic
    // So, if there are more dentists than existing bookings, we can make a new booking.
    // TODO: If booking times are not all synchronised (start and end times) we could have a false positive for unavailability.
    const bookingsAtThisTime = await BookingController.bookingsAtThisTime(
      clinic._id,
      bookingTime
    );

    return (
      bookingsAtThisTime == null || bookingsAtThisTime.length < clinic.dentists
    );
  }

  static async publishNextNAvailableBookings(clinicID, N) {
    let clinic = await ClinicService.getById(clinicID);
    if (!clinic) {
      return;
    }
    clinic = await ClinicService.populateClinic(clinic);

    let timeArray = []; // Array to hold all the next N available times
    let appointmentTime = new Date();
    appointmentTime.setMinutes(0, 0, 0);

    while (timeArray.length < N) {
      // go to the next standard time for the loop
      appointmentTime.setTime(
        appointmentTime.getTime() +
          DateUtil.getMillisFromMinutes(
            process.env.STANDARD_APPOINTMENT_DURATION
          )
      );
      const nextTime = appointmentTime; // assign the calculated next time to our loop

      // the loop keeps running until we have all the next N available booking times
      const availableToBook = await ClinicController.isAvailableToBook(
        //check if the time is available at the clinic
        clinic,
        nextTime
      );
      if (availableToBook) {
        //add it to the array if it is available
        const availableTime = new Date(nextTime.getTime());
        timeArray.push(availableTime);
      }
    }
    MQTTService.publish(
      "clinics/availability/" + clinicID,
      JSON.stringify({ availableTimes: timeArray }),
      true
    ); // publish to MQTT
    console.log("Publised all availabilities for clinic: " + clinic._id);

    return timeArray; //return array of TIMES which are available for a booking
  }

  // Sequentially publish the availabilities for all clinics
  static async publishAllClinicsAvailability() {
    const clinics = await ClinicService.getAll();
    clinics.forEach(async (clinic) => {
      console.log("Publishing all availabilities for clinic: " + clinic._id);
      ClinicController.publishNextNAvailableBookings(
        clinic._id,
        process.env.NUMBER_APPOINTMENTS_TO_PUBLISH
      );
    });
  }
}
