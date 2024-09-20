import Institute from "../models/instituteModel.js";
import bcrypt from "bcryptjs";
import generateTokenAndSetCookie from "../utils/generateTokenAndSetCookie.js";
import { v2 as cloudinary } from "cloudinary";
import mongoose from "mongoose";

const registerInstitute = async (req, res) => {
  try {
    const { name, email, password, location, phone } = req.body;

    // Check if all required fields are provided
    if (!name || !email || !password || !location || !phone) {
      return res.status(400).json({ message: "All fields are required" });
    }

    // Check if the institute already exists
    const existingInstitute = await Institute.findOne({ email });
    if (existingInstitute) {
      return res.status(400).json({ message: "Institute already exists with this email" });
    }

    // Hash the password
    const salt = await bcrypt.genSalt(10);
		const hashedPassword = await bcrypt.hash(password, salt);

    // Create a new institute
    const newInstitute = new Institute({
      name,
      email,
      password: hashedPassword,
      location,
      phone,
    });
    await newInstitute.save();
    // Respond with success
    if (newInstitute) {
        generateTokenAndSetCookie(newInstitute._id, res);

        res.status(201).json({
            
              _id: newInstitute._id,
              name: newInstitute.name,
              email: newInstitute.email,
              location: newInstitute.location,
              phone: newInstitute.phone,
          });
    } else {
        res.status(400).json({ error: "Invalid Institute data" });
    }
  }
  catch (err) {
    res.status(500).json({ error: err.message });
    console.log("Error in registerInstitute: ", err.message);
}
};
const loginInstitute = async (req, res) => {
    try {
      const { email, password } = req.body;
  
      // Find the institute by email
      const institute = await Institute.findOne({ email }).select("+password");
    
      // Compare passwords
      const isPasswordCorrect = await bcrypt.compare(password, institute.password);
      if (!institute ||!isPasswordCorrect) {
        return res.status(400).json({ error: "Invalid email or password" });
      }
  
      // Generate JWT token and set it as a cookie
      generateTokenAndSetCookie(institute._id, res);
  
      // Send back the institute data (without password)
      res.status(200).json({
        _id: institute._id,
        name: institute.name,
        email: institute.email,
        location: institute.location,
        phone: institute.phone,
      });
    } catch (error) {
      res.status(500).json({ error: error.message });
      console.log("Error in loginInstitute: ", error.message);
    }
  };

const logoutInstitute = (req, res) => {
  try {
    // Clear the JWT cookie
    res.cookie("jwt", "", { maxAge: 1, httpOnly: true });
    res.status(200).json({ message: "Institute logged out successfully" });
  } catch (error) {
    res.status(500).json({ error: error.message });
    console.log("Error in logoutInstitute: ", error.message);
  }
};

export {
    registerInstitute, loginInstitute, logoutInstitute};