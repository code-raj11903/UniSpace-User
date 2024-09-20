import jwt from 'jsonwebtoken';

const generateTokenAndSetCookie = (userId, res) => {
  // Ensure JWT_SECRET_KEY is defined
  if (!process.env.JWT_SECRET_KEY) {
    throw new Error("JWT_SECRET_KEY is missing from environment variables");
  }

  // Generate the JWT token
  const token = jwt.sign({ userId }, process.env.JWT_SECRET_KEY, {
    expiresIn: process.env.JWT_EXPIRES || '15d', // Default expiration is 15 days
  });

  // Set the cookie with the token
  res.cookie('jwt', token, {
    httpOnly: true, // Cookie cannot be accessed via client-side JavaScript
    maxAge: 15 * 24 * 60 * 60 * 1000, // 15 days in milliseconds
    sameSite: 'strict', // Protect against CSRF attacks
    secure: process.env.NODE_ENV === 'production', // Ensure cookie is only sent over HTTPS in production
  });

  return token;
};

export default generateTokenAndSetCookie;
