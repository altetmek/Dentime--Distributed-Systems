import { Clinic } from "../models/clinic.mjs";
import Coordinate from "../models/coordinate.mjs";
import OpeningHours from "../models/openinghours.mjs";
import ClinicService from "../service/clinic.mjs";
import MQTTService from "../service/mqtt.mjs";
import WebService from "../service/web.mjs";

export default class ClinicController {
  static processMessage(topic, message) {
    console.log("processMessage not implemented due to not being required.");
  }

  static async getClinicsFromAPI() {
    try {
      const clinicsJSON = await WebService.get(
        "https://raw.githubusercontent.com/feldob/dit355_2020/master/dentists.json"
      );
      let addClinic = false;
      let existingClinic;
      for (const key in clinicsJSON.dentists) {
        const clinic = clinicsJSON.dentists[key];
        clinic.external_id = clinic.id;
        await Clinic.findOne(
          { external_id: clinic.external_id },
          function (err, foundClinic) {
            if (err) {
              console.log(err);
            }
            // No exsisting clinic or clinics with this external id have been found in the database!
            if (!foundClinic) {
              addClinic = true;
            }
            // If one clinic with this external id has been found then we set it to a new variable in order to update it later
            if (foundClinic) {
              existingClinic = foundClinic;
            }
          }
        ).then(async function () {
          let coordinate = Coordinate(clinic.coordinate);
          // In order to reverse the coordinates that have been provided by API
          if (process.env.REVERSE_COORDINATES) {
            const t = coordinate.latitude;
            coordinate.latitude = coordinate.longitude;
            coordinate.longitude = t;
          }
          coordinate = await coordinate.save();
          clinic.coordinate = coordinate._id;
          const openinghours = [];

          for (const openingHoursKey in clinic.openinghours) {
            const openingHoursId = await OpeningHours({
              day: openingHoursKey,
              hours: clinic.openinghours[openingHoursKey],
            }).save();
            openinghours.push(openingHoursId._id);
          }
          clinic.openinghours = openinghours;

          const clinicToSave = Clinic(clinic);
          if (addClinic) {
            await clinicToSave.save();
          }

          // In case the clinics have been updated by the API then we update the existing ones in the database with the new information so other nodes can access the new data.
          if (existingClinic) {
            // Delete old coordinates in order to prevent duplications!
            Coordinate.findByIdAndRemove(
              existingClinic.coordinate,
              function (err, docs) {
                if (err) {
                  console.log(err);
                }
              }
            );

            existingClinic.openinghours.forEach((element) => {
              // Delete old openinghours in order to prevent duplications!
              OpeningHours.findByIdAndRemove(element, function (err, docs) {
                if (err) {
                  console.log(err);
                }
              });
            });

            existingClinic.name = clinicToSave.name;
            existingClinic.owner = clinicToSave.owner;
            existingClinic.dentists = clinicToSave.dentists;
            existingClinic.address = clinicToSave.address;
            existingClinic.city = clinicToSave.city;
            existingClinic.coordinate = clinicToSave.coordinate;
            existingClinic.openinghours = clinicToSave.openinghours;
            await existingClinic.save();
          }
        });
      }
      console.log("clinics fetched");
    } catch (error) {
      console.log("failed to fetch clinics");
    }
  }

  static async publishToMQTT() {
    const clinics = await ClinicService.getAll();
    MQTTService.publish("clinics", JSON.stringify({ clinics }), true);
  }
}
