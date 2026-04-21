const express = require('express');
const bcrypt = require('bcryptjs');
const jwt = require('jsonwebtoken');

const config = require('../config');
const User = require('../models/userModel');

const router = express.Router();

function buildToken(user) {
  return jwt.sign(
    { userId: user._id.toString(), username: user.username },
    config.jwtSecret,
    { expiresIn: '7d' }
  );
}

function createError(statusCode, message) {
  const error = new Error(message);
  error.statusCode = statusCode;
  return error;
}

router.post('/register', async (req, res) => {
  try {
    const { username, password } = req.body;

    if (!username || !password) {
      throw createError(400, 'Username and password are required.');
    }

    const existingUser = await User.findOne({ username: username.trim() });
    if (existingUser) {
      throw createError(409, 'Username already exists.');
    }

    const hashedPassword = await bcrypt.hash(password, 10);
    const user = await User.create({
      username: username.trim(),
      password: hashedPassword,
    });
    
    const token = buildToken(user);

    return res.status(201).json({ token, user: { id: user._id, username: user.username, createdAt: user.createdAt } });
  } catch (error) {
    if (!error.statusCode) {
      error.statusCode = 500;
      error.message = 'Unable to register user.';
    }
    return res.status(error.statusCode).json({ message: error.message });
  }
});

router.post('/login', async (req, res) => {
  try {
    const { username, password } = req.body;

    if (!username || !password) {
      throw createError(400, 'Username and password are required.');
    }

    const user = await User.findOne({ username: username.trim() });
    if (!user) {
      throw createError(401, 'Invalid username or password.');
    }

    const isMatch = await bcrypt.compare(password, user.password);
    if (!isMatch) {
      throw createError(401, 'Invalid username or password.');
    }

    const token = buildToken(user);

    return res.json({
      token,
      user: { id: user._id, username: user.username, createdAt: user.createdAt },
    });
  } catch (error) {
    if (!error.statusCode) {
      error.statusCode = 500;
      error.message = 'Unable to log in.';
    }
    return res.status(error.statusCode).json({ message: error.message });
  }
});

module.exports = router;
