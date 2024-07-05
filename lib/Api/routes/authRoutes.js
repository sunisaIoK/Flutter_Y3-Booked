const express = require('express');
const router = express.Router();
const { login, register, fetchUserData } = require('../controllers/authController');

router.post('/login', login);
router.post('/register', register);
router.get('/user/:id', fetchUserData);

module.exports = router;
