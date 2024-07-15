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
