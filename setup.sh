#!/bin/bash

# Set up the client and server directories
mkdir gaza-jobs
cd gaza-jobs

# Initialize the client (React app)
npx create-react-app client
cd client
npm install i18next react-i18next axios
cd ..

# Initialize the server (Node.js with Express)
mkdir server
cd server
npm init -y
npm install express mongoose cors body-parser dotenv

# Create server structure
mkdir models routes
touch models/Job.js models/Application.js routes/jobs.js routes/applications.js .env server.js

# Write .env file
echo "MONGO_URI=YOUR_MONGO_URI_HERE" > .env

# Write server.js
cat <<EOL > server.js
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
    console.log(\`Server is running on port: \${port}\`);
});
EOL

# Write Job model
cat <<EOL > models/Job.js
import mongoose from 'mongoose';

const jobSchema = new mongoose.Schema({
    companyName: String,
    jobTitle: String,
    jobDescription: String,
    requirements: [String],
    language: String, // 'en' for English, 'ar' for Arabic
});

const Job = mongoose.model('Job', jobSchema);

export default Job;
EOL

# Write Application model
cat <<EOL > models/Application.js
import mongoose from 'mongoose';

const applicationSchema = new mongoose.Schema({
    name: String,
    email: String,
    phone: String,
    resume: String, // URL to the resume
    jobID: mongoose.Schema.Types.ObjectId,
    answers: [String],
    language: String, // 'en' for English, 'ar' for Arabic
});

const Application = mongoose.model('Application', applicationSchema);

export default Application;
EOL

# Write jobs routes
cat <<EOL > routes/jobs.js
import { Router } from 'express';
import Job from '../models/Job.js';

const router = Router();

// Create a job
router.post('/', async (req, res) => {
    const newJob = new Job(req.body);
    try {
        const savedJob = await newJob.save();
        res.status(201).json(savedJob);
    } catch (err) {
        res.status(400).json({ message: err.message });
    }
});

// Get all jobs
router.get('/', async (req, res) => {
    try {
        const jobs = await Job.find();
        res.json(jobs);
    } catch (err) {
        res.status(500).json({ message: err.message });
    }
});

export default router;
EOL

# Write applications routes
cat <<EOL > routes/applications.js
import { Router } from 'express';
import Application from '../models/Application.js';

const router = Router();

// Create an application
router.post('/', async (req, res) => {
    const newApplication = new Application(req.body);
    try {
        const savedApplication = await newApplication.save();
        res.status(201).json(savedApplication);
    } catch (err) {
        res.status(400).json({ message: err.message });
    }
});

// Get all applications
router.get('/', async (req, res) => {
    try {
        const applications = await Application.find();
        res.json(applications);
    } catch (err) {
        res.status(500).json({ message: err.message });
    }
});

export default router;
EOL

# Write client files
cd ../client/src

# i18n configuration
cat <<EOL > i18n.js
import i18n from 'i18next';
import { initReactI18next } from 'react-i18next';

i18n.use(initReactI18next).init({
    resources: {
        en: {
            translation: {
                "jobForm": "Job Form",
                "companyName": "Company Name",
                // add more translations
            }
        },
        ar: {
            translation: {
                "jobForm": "نموذج العمل",
                "companyName": "اسم الشركة",
                // add more translations
            }
        }
    },
    lng: "en",
    fallbackLng: "en",
    interpolation: {
        escapeValue: false
    }
});

export default i18n;
EOL

# JobForm component
mkdir components
cat <<EOL > components/JobForm.js
import React, { useState } from 'react';
import axios from 'axios';
import { useTranslation } from 'react-i18next';

const JobForm = () => {
    const { t } = useTranslation();
    const [form, setForm] = useState({
        companyName: '',
        jobTitle: '',
        jobDescription: '',
        requirements: [],
        language: 'en'
    });

    const handleChange = (e) => {
        setForm({
            ...form,
            [e.target.name]: e.target.value
        });
    };

    const handleSubmit = async (e) => {
        e.preventDefault();
        try {
            const res = await axios.post('/api/jobs', form);
            console.log(res.data);
        } catch (err) {
            console.error(err);
        }
    };

    return (
        <form onSubmit={handleSubmit}>
            <label>{t('companyName')}</label>
            <input type="text" name="companyName" onChange={handleChange} />
            {/* add other form fields */}
            <button type="submit">{t('submit')}</button>
        </form>
    );
};

export default JobForm;
EOL

# ApplicationForm component
cat <<EOL > components/ApplicationForm.js
import React, { useState } from 'react';
import axios from 'axios';
import { useTranslation } from 'react-i18next';

const ApplicationForm = () => {
    const { t } = useTranslation();
    const [form, setForm] = useState({
        name: '',
        email: '',
        phone: '',
        resume: '',
        jobID: '',
        answers: [],
        language: 'en'
    });

    const handleChange = (e) => {
        setForm({
            ...form,
            [e.target.name]: e.target.value
        });
    };

    const handleSubmit = async (e) => {
        e.preventDefault();
        try {
            const res = await axios.post('/api/applications', form);
            console.log(res.data);
        } catch (err) {
            console.error(err);
        }
    };

    return (
        <form onSubmit={handleSubmit}>
            <label>{t('name')}</label>
            <input type="text" name="name" onChange={handleChange} />
            {/* add other form fields */}
            <button type="submit">{t('submit')}</button>
        </form>
    );
};

export default ApplicationForm;
EOL

# LanguageSwitcher component
cat <<EOL > components/LanguageSwitcher.js
import React from 'react';
import { useTranslation } from 'react-i18next';

const LanguageSwitcher = () => {
    const { i18n } = useTranslation();

    const changeLanguage = (lng) => {
        i18n.changeLanguage(lng);
    };

    return (
        <div>
            <button onClick={() => changeLanguage('en')}>English</button>
            <button onClick={() => changeLanguage('ar')}>العربية</button>
        </div>
    );
};

export default LanguageSwitcher;
EOL

# App component
cat <<EOL > App.js
import React from 'react';
import './i18n';
import JobForm from './components/JobForm';
import ApplicationForm from './components/ApplicationForm';
import LanguageSwitcher from './components/LanguageSwitcher';

const App = () => {
    return (
        <div>
            <LanguageSwitcher />
            <JobForm />
            <ApplicationForm />
        </div>
    );
};

export default App;
EOL

echo "Setup complete! Navigate to gaza-jobs/client and run 'npm start' to start the React app. Navigate to gaza-jobs/server and run 'node server.js' to start the Express server."
