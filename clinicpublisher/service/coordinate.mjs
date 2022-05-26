import Coordinate from "../models/coordinate.mjs";

export default class CoordinateService {
  static async get(id) {
    const coordinate = await Coordinate.findOne(
      { _id: id },
      function (err, foundClinic) {
        if (err) {
          console.log(err);
        }
      }
    );
    return coordinate;
  }
}
