const express = require('express');

const authMiddleware = require('../middleware/authMiddleware');
const Expense = require('../models/expenseModel');

const router = express.Router();

router.use(authMiddleware);

function createError(statusCode, message) {
  const error = new Error(message);
  error.statusCode = statusCode;
  return error;
}

router.post('/add', async (req, res) => {
  try {
    const { amount, category } = req.body;
    const parsedAmount = Number(amount);

    if (!parsedAmount || parsedAmount <= 0 || !category) {
      throw createError(400, 'Valid amount and category are required.');
    }

    const expense = await Expense.create({
      amount: parsedAmount,
      category,
      userId: req.user.userId,
    });
    
    // Format output to gracefully handle ID expectation map from the client
    const output = expense.toObject();
    output.id = expense._id;

    return res.status(201).json(output);
  } catch (error) {
    if (!error.statusCode) {
      error.statusCode = 500;
      error.message = 'Unable to add expense.';
    }
    return res.status(error.statusCode).json({ message: error.message });
  }
});

router.get('/expenses', async (req, res) => {
  try {
    const expenses = await Expense.find({ userId: req.user.userId }).sort({ createdAt: -1 });
    
    // Map _id to id out of convenience for client mapping
    const formatted = expenses.map(e => {
        const obj = e.toObject();
        obj.id = obj._id;
        return obj;
    });

    return res.json(formatted);
  } catch (error) {
    if (!error.statusCode) {
      error.statusCode = 500;
      error.message = 'Unable to fetch expenses.';
    }
    return res.status(error.statusCode).json({ message: error.message });
  }
});

router.delete('/expense/:id', async (req, res) => {
  try {
    const result = await Expense.deleteOne({ _id: req.params.id, userId: req.user.userId });
    if (result.deletedCount === 0) {
      throw createError(404, 'Expense not found.');
    }
    return res.json({ message: 'Expense deleted successfully.' });
  } catch (error) {
    if (!error.statusCode) {
      error.statusCode = 500;
      error.message = 'Unable to delete expense.';
    }
    return res.status(error.statusCode).json({ message: error.message });
  }
});

module.exports = router;
