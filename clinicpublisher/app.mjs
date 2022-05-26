import dotenv from "dotenv";
dotenv.config();

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
await MQTTService.publish("presence", "ClinicPublisherUp");

await ClinicController.getClinicsFromAPI();
await ClinicController.publishToMQTT();
console.log("Clinics published to broker");

// The clinics list will get updated every 5 minutes
const fiveMinutes = 1000 * 60 * 5;
const interval = fiveMinutes;

setInterval(async function () {
  await ClinicController.getClinicsFromAPI();
  await ClinicController.publishToMQTT();
  console.log("Clinics published to broker");
}, interval);
