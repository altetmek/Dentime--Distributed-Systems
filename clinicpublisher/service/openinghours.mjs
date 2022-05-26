import OpeningHours from "../models/openinghours.mjs";

export default class OpeningHoursService {
  static async get(id) {
    const openinghours = await OpeningHours.findOne(
      { _id: id },
      function (err, foundClinic) {
        if (err) {
          console.log(err);
        }
      }
    );
    return openinghours;
  }
}
