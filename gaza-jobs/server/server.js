import express from 'express';
import mongoose from 'mongoose';
import cors from 'cors';
import dotenv from 'dotenv';

dotenv.config();

const app = express();
const port = process.env.PORT || 5000;

app.use(cors());
app.use(express.json());

mongoose.connect(process.env.MONGO_URI, {
    useNewUrlParser: true,
    useUnifiedTopology: true,
}).then(() => {
    console.log('MongoDB connected');
}).catch(err => {
    console.error(err);
});

import jobsRouter from './routes/jobs.js';
import applicationsRouter from './routes/applications.js';

app.use('/api/jobs', jobsRouter);
app.use('/api/applications', applicationsRouter);

app.listen(port, () => {
    console.log(`Server is running on port: ${port}`);
});
