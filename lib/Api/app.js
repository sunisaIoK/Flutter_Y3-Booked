const express = require('express');
const bodyParser = require('body-parser');
const cors = require('cors');

const userRoutes = require('./routes/userRoutes');
const authRoutes = require('./routes/authRoutes');

const app = express();
const port = process.env.PORT || 3000;  // Using the PORT environment variable with a default

app.use(cors());
app.use(bodyParser.json());

app.use('/api/users', userRoutes);
app.use('/api/auth', authRoutes);

app.listen(port, () => {
  console.log(`API server running on http://localhost:${port}`);
});
