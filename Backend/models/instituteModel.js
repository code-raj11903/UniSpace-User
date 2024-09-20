import mongoose from "mongoose";
import validator from 'validator';
const InstituteSchema = new mongoose.Schema({
  name: { type: String, 
    required: [true, "Institute name is required"] 
  },
  email: { 
    type: String, 
    required: [true, "Email is required"], 
    unique: true 
  },
  password: {
    type: String,
    required: [true, "Please provide a Password!"],
    minLength: [8, "Password must contain at least 8 characters!"],
    select: false,
    validate: {
      validator: function (value) {
        // Regular expression for password validation
        // At least one uppercase letter, one lowercase letter, one number, and one special character
        return /^(?=.*[a-z])(?=.*[A-Z])(?=.*\d)(?=.*[@$!%*?&#])[A-Za-z\d@$!%*?&#]{8,32}$/.test(value);
      },
      message: "Password must contain at least one uppercase letter, one lowercase letter, one number, and one special character!"
    }
  },
  location: { type: String, required: [true, "Location is required"] },
  phone: { type: String, required: [true, "Phone number is required"] },
  departments: [{ type: mongoose.Schema.Types.ObjectId, ref: "Department" }],
  resources: [{ type: mongoose.Schema.Types.ObjectId, ref: "Resource" }],
  orders: [{ type: mongoose.Schema.Types.ObjectId, ref: "Booking" }],
  createdAt: {
    type: Date,
    default: Date.now
  }
});

const Institute = mongoose.model("Institute", InstituteSchema);
export default Institute;
