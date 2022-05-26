import mongoose from "mongoose";
const { model, Types } = mongoose;
const { ObjectId } = Types;
export const Clinic = model("Clinic", {
  external_id: { type: Number, required: true },
  name: { type: String, required: true },
  owner: { type: String, required: true },
  dentists: { type: Number, required: true },
  address: { type: String, required: true },
  city: { type: String, required: true },

  coordinate: { type: ObjectId, ref: "Coordinate" },
  openinghours: [{ type: ObjectId, ref: "OpeningHours" }],
});
export default Clinic;
