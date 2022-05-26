import UserService from "../service/user.mjs";

export default class UserController {
  static processMessage(topic, message) {
    console.log(
      'UserController processMessage: got the topic: "' +
        topic +
        '", and the message: "' +
        message +
        '"'
    );

    switch (topic) {
      case "create":
        UserController.create(message);
        break;
      case "update":
        UserController.update(message);
        break;
      case "delete":
        UserController.delete(message);
        break;
    }
  }

  static async create(newUser) {
    let createdUser = await UserService.create(newUser);
    console.log(createdUser);
  }

  static async delete(userID){
    let deletedUser = await UserService.delete(userID);
    console.log(deletedUser);
  }

  static async publishToMQTT() {
    // const clinics = await ClinicService.getAll();
    // MQTTService.publish("clinics", clinics.toString(), true);
  }
}
