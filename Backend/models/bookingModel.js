import mongoose from 'mongoose';

const BookingSchema = new mongoose.Schema({
  user_id: { 
    type: mongoose.Schema.Types.ObjectId, 
    ref: 'User', 
    required: [true, "User reference is required"]
  },
  resource_ids: [{ 
    type: mongoose.Schema.Types.ObjectId, 
    ref: 'Resource', 
    required: [true, "Resource reference is required"]
  }],
  institute_id: { 
    type: mongoose.Schema.Types.ObjectId, 
    ref: 'Institute', 
    required: [true, "Institute reference is required"]
  },
  status: { 
    type: String, 
    required: [true, "Booking status is required"], 
    enum: ['Pending', 'Confirmed', 'Cancelled'], // You can customize the status options
    default: 'Pending'
  },
  date: { 
    type: Date, 
    required: [true, "Booking date is required"] 
  },
  total_amount: { 
    type: Number, 
    required: [true, "Total amount is required"] 
  },
  payment_id: { 
    type: mongoose.Schema.Types.ObjectId, 
    ref: 'Payment'
  },
  feedback: {
    rating: { type: Number },
    comment: { type: String }
  }
});

const Booking = mongoose.model('Booking', BookingSchema);
export default Booking;
