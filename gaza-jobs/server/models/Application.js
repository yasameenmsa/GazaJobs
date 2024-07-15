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
