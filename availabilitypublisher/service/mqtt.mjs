import dotenv from "dotenv";
dotenv.config();

import mqtt from "mqtt";
import BookingController from "../controllers/booking.mjs";
import ClinicController from "../controllers/clinic.mjs";
import DateUtil from "../util/date_util.mjs";
class MQTTService {
  // initialise overload as true to ensure that not overloaded will be broadcast on load
  overload = [true];
  constructor() {
    if (!MQTTService.instance) {
      this.messageBacklog = [];
      const topics = [
        // "presence",
        "clinics/announceAvailability",
      ];
      this.connectedTopics = [];
      this._client = mqtt.connect({
        host: process.env.MQTT_HOST,
        port: process.env.MQTT_PORT,
        username: process.env.MQTT_USERNAME,
        password: process.env.MQTT_PASSWORD,
      });

      const _me = this;
      this._client.on("connect", function () {
        topics.forEach((topic) => {
          topic = process.env.MQTT_BASE_TOPIC + topic;
          _me._client.subscribe(topic, function (err) {
            if (!err) {
              console.log("connected to " + topic);
              _me.connectedTopics.push(topic);
            } else {
              console.log(err);
            }
          });
        });
      });

      let me = this;
      this._client.on("message", function (topic, message) {
        // message is Buffer
        if (topic.indexOf(process.env.MQTT_BASE_TOPIC) !== 0) {
          console.log("Got topic for another backend node");
          return;
        }

        message = message.toString();

        me.messageBacklog.push({ time: Date.now(), topic, message });
        me.checkOverload();

        if (message.toLowerCase() === "ping") {
          console.log("pong");
          me._client.publish(topic, "pong");
          return;
        }
        if (message.toLowerCase() === "pong") {
          return;
        }
        topic = topic.replace(process.env.MQTT_BASE_TOPIC, "");
        const baseTopic = topic.substring(0, topic.indexOf("/"));
        console.log("message from '" + topic + "': " + message);
        topic = topic.replace(baseTopic + "/", "");

        const parsedMessage = JSON.parse(message);

        switch (baseTopic) {
          case "clinics":
            ClinicController.processMessage(topic, parsedMessage);
            break;
          case "bookings":
            BookingController.processMessage(topic, parsedMessage);
            break;
        }
      });

      MQTTService.instance = this;
    }

    return MQTTService.instance;
  }

  publish = (topic, message, retain) => {
    topic = process.env.MQTT_BASE_TOPIC + topic;
    this._client.publish(topic, message, { retain, qos: 2 });
    return;
  };
  //Determine how many messages were received in the last 15 seconds, and, if over the threshold, instruct front end to stop
  async checkOverload() {
    const earliestTime = new Date(
      new Date().getTime() - DateUtil.getMillisFromSeconds(15)
    );

    const messagesInFifteenSeconds = this.messageBacklog.filter(function (
      message
    ) {
      return message.time > earliestTime;
    });
    console.log(
      "checkOverload: " +
        messagesInFifteenSeconds.length +
        " message(s) were received in the last 15 seconds"
    );
    if (messagesInFifteenSeconds.length > 200) {
      this.publish("OVERLOAD", "true", true);
      this.overload[0] = true;
    } else if (this.overload[0]) {
      this.publish("system/overload", "false", true);
      this.overload[0] = false;
    }
  }
}

const instance = new MQTTService();
Object.freeze(instance);

export default instance;
