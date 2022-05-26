import Booking from "../models/booking.mjs";

export default class BookingService {
  static async getAll() {
    const bookings = await Booking.find({}, function (err, foundBooking) {
      if (err) {
        console.log(err);
      }
    });
    return bookings;
  }

  static async get(query) {
    const bookings = await Booking.find(
      query,
      function (err, foundBooking) {
        if (err) {
          console.log(err);
        }
      }
    );
    return bookings;
  }

  static async getById(id) {
    const bookings = await Booking.findOne(
      { _id: id },
      function (err, foundBooking) {
        if (err) {
          console.log(err);
        }
      }
    );
    return bookings;
  }
}
