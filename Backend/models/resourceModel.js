import mongoose from "mongoose";

const ResourceSchema = new mongoose.Schema({
  name: {
    type: String,
    required: [true, "Resource name is required"],
  },
  location: {
    type: String,
    required: [true, "Resource location is required"],
  },
  type: {
    type: String,
    required: [true, "Resource type is required"],
  },
  description: {
    type: String,
    required: [true, "Resource description is required"],
  },
  availability: { 
    type: Boolean, 
    default: true 
  },
  department_id: { 
    type: mongoose.Schema.Types.ObjectId, 
    ref: "Department" 
  },
  institute_id: {
    type: mongoose.Schema.Types.ObjectId,
    ref: "Institute",
    required: [true, "Institute reference is required"],
  },
  price_per_day: {
    type: Number,
    required: [true, "Resource price per day is required"],
  },
  image_url: { 
    type: String, 
    required: [true, "Resource image URL is required"], 
  },
  createdAt: {
    type: Date,
    default: Date.now
  }
});

const Resource = mongoose.model("Resource", ResourceSchema);
export default Resource;