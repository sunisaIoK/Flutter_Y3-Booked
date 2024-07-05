const db = require('../models/db');

exports.getAllUsers = (req, res) => {
  db.query('SELECT * FROM register', (err, results) => {
    if (err) throw err;
    res.json(results);
  });
};

exports.updateUser = (req, res) => {
  const { firstname, lastname, org } = req.body;
  const { id } = req.params;
  db.query('UPDATE register SET firstname=?, lastname=?, org=? WHERE id=?', [firstname, lastname, org, id], (err, results) => {
    if (err) throw err;
    res.json({ message: 'User updated successfully' });
  });
};

exports.deleteUser = (req, res) => {
  const { id } = req.params;
  db.query('DELETE FROM register WHERE id=?', [id], (err, results) => {
    if (err) throw err;
    res.json({ message: 'User deleted successfully' });
  });
};
