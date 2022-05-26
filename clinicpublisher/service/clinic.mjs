import { Clinic } from "../models/clinic.mjs";
import CoordinateService from "./coordinate.mjs";
import OpeningHoursService from "./openinghours.mjs";
export default class ClinicService {
  static async populateClinic(clinic) {
    let clinicOpeningHoursValues = [];

    for (const openingHours of clinic.openinghours) {
      const openingHoursItem = await OpeningHoursService.get(openingHours);
      clinicOpeningHoursValues.push(openingHoursItem);
    }
    clinic.openinghours = clinicOpeningHoursValues;
    const clinicCoordinates = await CoordinateService.get(clinic.coordinate);
    clinic.coordinate = clinicCoordinates;
    return clinic;
  }

  static async getById(id) {
    const clinic = await Clinic.findOne(
      { _id: id },
      function (err, foundClinic) {
        if (err) {
          console.log(err);
        }
      }
    );
    return clinic;
  }

  static async getAll() {
    const clinics = await Clinic.find({}, function (err, foundClinic) {
      if (err) {
        console.log(err);
      }
    });
    for (const key in clinics) {
      clinics[key] = await ClinicService.populateClinic(clinics[key]);
    }
    return clinics;
  }
}
