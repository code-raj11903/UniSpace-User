import express from 'express';
import Resource from '../models/resourceModel.js';

const router = express.Router();

// Fetch all resources with pagination
router.get('/', async (req, res) => {
  const { offset = 0, limit = 10 } = req.query; // Get offset and limit from query
  try {
    const resources = await Resource.find()
      .skip(Number(offset)) // Skip the offset
      .limit(Number(limit)); // Limit the number of results
    res.status(200).json(resources);
  } catch (error) {
    res.status(500).json({ message: error.message });
  }
});

export default router;
