import mongoose from "mongoose";
const { model, Types } = mongoose;
const { ObjectId } = Types;
export const User = model("User", {
  fullname: { type: String, required: true },
  username: { type: String, required: true },
  email: { type: String, required: true },
  address: { type: String, required: true },
  city: { type: String, required: true },
  imageUrl: {
    type: String,
    default: "https://thispersondoesnotexist.com/image",
  },
  role: { type: String, default: "patient" },
});
export default User;
