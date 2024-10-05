const express = require('express');
const bodyParser = require('body-parser');
const cors = require('cors');
require('dotenv').config();
const homeRouter = require('./src/routes/homeRouter');
const userRoutes = require('./src/routes/userRouter');

const app = express();
app.use(cors());
app.use(bodyParser.json());

const PORT = process.env.PORT || 3005;

app.use('/api/v1', homeRouter);
app.use('/api/v1/users', userRoutes);

app.listen(PORT, ()=>{
    console.log(`Server:http://localhost:${PORT}/api/v1`)
})