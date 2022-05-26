import dotenv from "dotenv";
dotenv.config();

import mqtt from "mqtt";
class MQTTService {
  constructor() {
    if (!MQTTService.instance) {
      this._client = mqtt.connect({
        host: process.env.MQTT_HOST,
        port: process.env.MQTT_PORT,
        username: process.env.MQTT_USERNAME,
        password: process.env.MQTT_PASSWORD,
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
}

const instance = new MQTTService();
Object.freeze(instance);

export default instance;
