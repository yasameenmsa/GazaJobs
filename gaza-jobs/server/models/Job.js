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
