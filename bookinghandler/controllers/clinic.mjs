import ClinicService from "../service/clinic.mjs";
import DateUtil from "../util/date_util.mjs";
import BookingController from "./booking.mjs";

export default class ClinicController {
  static async isClinicOpenAtByID(clinicID, time) {
    let clinic = await ClinicService.getById(clinicID);
    clinic = await ClinicService.populateClinic(clinicID);
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
      clinic.id,
      bookingTime
    );

    return (
      bookingsAtThisTime == null || bookingsAtThisTime.length < clinic.dentists
    );
  }
}
