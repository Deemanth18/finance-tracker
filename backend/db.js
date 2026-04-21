const mongoose = require('mongoose');
const config = require('./config');

const connectDB = async () => {
  if (!config.mongoUri) {
    throw new Error('MONGO_URI is not configured.');
  }

  const conn = await mongoose.connect(process.env.MONGO_URI);
  console.log(`MongoDB Connected: ${conn.connection.host}`);
};

module.exports = connectDB;
