import User from "../models/user.mjs";

export default class UserService {
  static async create(content) {
    return await new User(content).save();
  }

  static async getAll() {
    const users = await User.find({}, function (err, foundUser) {
      if (err) {
        console.log(err);
      }
    });
    return users;
  }

  static async getById(id) {
    const users = await User.find({ _id: id }, function (err, foundUser) {
      if (err) {
        console.log(err);
      }
    });
    return users;
  }

  static async update(id, content) {
    const users = await User.find({ _id: id }, function (err, foundUser) {
      if (err) {
        console.log(err);
      }
    });

    if (!users) {
      return await this.create(content);
    } else {
      return await User.findByIdAndUpdate(id, content, { new: true }).exec();
    }
  }

  static async delete(id) {
    User.findOneAndRemove({ _id: id }, function (err, user) {
      if (err) {
        return err;
      }
      if (user == null) {
        return { message: "User does not exist!" };
      }
      return { message: "User has been removed!" };
    });
  }
}
