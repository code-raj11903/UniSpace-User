import mongoose from 'mongoose';

const DepartmentSchema = new mongoose.Schema({
  name: { type: String, required: [true, "Department name is required"] },
  email: { type: String, required: [true, "Email is required"] },
  location: { type: String, required: [true, "Location is required"] },
  phone: {
    type: String, 
    required: [true, "Please enter your Phone Number!"]
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
  institute_id: { type: mongoose.Schema.Types.ObjectId, ref: 'Institute', required: [true, "Institute reference is required"] },
  resources: [{ type: mongoose.Schema.Types.ObjectId, ref: 'Resource' }],
  orders: [{ type: mongoose.Schema.Types.ObjectId, ref: 'Booking' }]
  createdAt: {
    type: Date,
    default: Date.now
  }
});

const Department = mongoose.model('Department', DepartmentSchema);
export default Department;
