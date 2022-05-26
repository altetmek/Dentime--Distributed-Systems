import dotenv from "dotenv";
dotenv.config();

import MQTTService from "./service/mqtt.mjs";
import BookingController from "./controllers/booking.mjs";
import mongoose from "mongoose";
import DateUtil from "./util/date_util.mjs";

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
await MQTTService.publish("presence", "bookinghandler");

// Publish all user bookings to MQTT
await BookingController.publishAllUsersBookingsToMQTT();

const overloadInterval = DateUtil.getMillisFromSeconds(10);
// Monitor for overload situation
setInterval(async function () {
  await MQTTService.checkOverload();
}, overloadInterval);

console.log("Init done");
