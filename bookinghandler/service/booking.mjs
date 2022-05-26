import Booking from "../models/booking.mjs";

export default class BookingService {
  static async create(content) {
    return await new Booking(content).save();
  }

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

  static async update(id, content) {
    const bookings = await Booking.find(
      { _id: id },
      function (err, foundBooking) {
        if (err) {
          console.log(err);
        }
      }
    );

    if (!bookings) {
      return await this.create(content);
    } else {
      return await Booking.findByIdAndUpdate(id, content, { new: true }).exec();
    }
  }

  static async delete(id) {
    Booking.findOneAndRemove({ _id: id }, function (err, booking) {
      if (err) {
        return err;
      }
      if (booking == null) {
        return { message: "Booking does not exist!" };
      }
      return { message: "Booking has been removed!" };
    });
  }
}
