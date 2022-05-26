import dotenv from "dotenv";
dotenv.config();

import DateUtil from "./util/date_util.mjs";

import MQTTService from "./service/mqtt.mjs";

import mongoose from "mongoose";
import ClinicController from "./controllers/clinic.mjs";

// Runtime config
const mongoURI = process.env.MONGODB_URI;

// Connect to the mongoDB database
mongoose.connect(
  mongoURI,
  { useNewUrlParser: true, useUnifiedTopology: true },
  function (err) {
    if (err) {
      console.error(`Failed to connect to MongoDB with URI: ${mongoURI}`);
      console.error(err.stack);
      process.exit(1);
    }
    console.log(`Connected to MongoDB with URI: ${mongoURI}`);
  }
);

await MQTTService;
await MQTTService.publish("presence", "availabilitypublisher");

// Publih all clinic's availabilities on load
await ClinicController.publishAllClinicsAvailability();

const interval = DateUtil.getMillisFromMinutes(
  process.env.STANDARD_APPOINTMENT_DURATION
);

//Implment DB config etc...
console.log("Init done");

// Publish all clinic's availabilities every standard apointment duration
setInterval(async function () {
  await ClinicController.publishAllClinicsAvailability();
}, interval);

const overloadInterval = DateUtil.getMillisFromSeconds(10);
// Monitor for overload situation
setInterval(async function () {
  await MQTTService.checkOverload();
}, overloadInterval);
