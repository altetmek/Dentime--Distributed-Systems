import mongoose from "mongoose";
const { model, Types } = mongoose;
const { ObjectId } = Types;
export const Booking = model("Booking", {
  time: { type: Date, required: true },
  patient: { type: ObjectId, ref: "User", required: true },
  dentist: { type: ObjectId, ref: "Clinic", required: true },
  duration: { type: Number, required: true },
});
export default Booking;
