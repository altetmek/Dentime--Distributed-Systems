import mongoose from "mongoose";
const { model, Types } = mongoose;
const { ObjectId } = Types;
export const OpeningHours = model("OpeningHours", {
  day: { type: String, required: true },
  hours: { type: String, required: true },
});
export default OpeningHours;
