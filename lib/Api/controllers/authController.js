const db = require('../models/db');

exports.login = (req, res) => {
  const { id, password } = req.body;
  db.query('SELECT * FROM register WHERE id = ? AND password = ?', [id, password], (err, results) => {
    if (err) throw err;
    if (results.length > 0) {
      res.json({ message: 'Login successful' });
    } else {
      res.json({ message: 'Login failed' });
    }
  });
};

exports.register = (req, res) => {
  const { id, password, firstname, lastname, org } = req.body;
  db.query('INSERT INTO register (id, password, firstname, lastname, org) VALUES (?,?,?,?,?)', [id, password, firstname, lastname, org], (err, results) => {
    if (err) throw err;
    res.json({ message: 'User registered successfully' });
  });
};

exports.fetchUserData = (req, res) => {
  const { id } = req.params;
  db.query('SELECT * FROM register WHERE id = ?', [id], (err, result) => {
    if (err) throw err;
    if (result.length > 0) {
      res.json({ success: true, data: result[0] });
    } else {
      res.json({ success: false, message: 'User not found' });
    }
  });
};
