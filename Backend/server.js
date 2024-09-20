import express from "express";
import { connectDB } from "./database/connectDB.js";
import dotenv from "dotenv";
import cookieParser from "cookie-parser";
import path from "path";
import cloudinary from "cloudinary";
import instituteRouter from "./routes/instituteRoutes.js";
// import departmentRouter from "./routes/departmentRoutes.js";


dotenv.config();

const app = express();
const PORT = process.env.PORT || 5000;
const __dirname = path.resolve();

// Configure Cloudinary
cloudinary.v2.config({
    cloud_name: process.env.CLOUDINARY_CLIENT_NAME,
    api_key: process.env.CLOUDINARY_CLIENT_API,
    api_secret: process.env.CLOUDINARY_CLIENT_SECRET,
});

// Middleware
app.use(cookieParser());
app.use(express.json());
app.use(express.urlencoded({ extended: true }));



// Connect to MongoDB
connectDB();


// Institute routes
app.use("/api/v1/institute", instituteRouter);

// Department routes
// app.use("/api/v1/department", departmentRouter);

// Start the server
app.listen(PORT, () => {
    console.log(`Server running at port ${PORT}`);
});