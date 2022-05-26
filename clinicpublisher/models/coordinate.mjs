import mongoose from "mongoose";
const { model, Types } = mongoose;
const { ObjectId } = Types;
export const Coordinate = model("Coordinate", {
  latitude: { type: Number, required: true },
  longitude: { type: Number, required: true },
});
export default Coordinate;
