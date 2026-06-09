-- Seed data for Pill Tracker

-- Insert users
INSERT INTO users (name) VALUES
    ('Sarah Johnson'),
    ('Michael Chen'),
    ('Emily Rodriguez');

-- Insert prescriptions for Sarah Johnson (user_id = 1)
INSERT INTO prescriptions (user_id, name, description, frequency_hours) VALUES
    (1, 'Lisinopril 10mg', 'Blood pressure medication that helps relax blood vessels and lower blood pressure, reducing the risk of heart attack and stroke.', 24),
    (1, 'Metformin 500mg', 'Diabetes medication that helps control blood sugar levels by improving how your body handles insulin.', 12);

-- Insert prescriptions for Michael Chen (user_id = 2)
INSERT INTO prescriptions (user_id, name, description, frequency_hours) VALUES
    (2, 'Atorvastatin 20mg', 'Cholesterol-lowering medication (statin) that reduces bad cholesterol and triglycerides while increasing good cholesterol.', 24),
    (2, 'Omeprazole 20mg', 'Proton pump inhibitor that reduces stomach acid production, treating heartburn and acid reflux.', 24),
    (2, 'Aspirin 81mg', 'Low-dose blood thinner that helps prevent blood clots, reducing the risk of heart attack and stroke.', 24);

-- Insert prescriptions for Emily Rodriguez (user_id = 3)
INSERT INTO prescriptions (user_id, name, description, frequency_hours) VALUES
    (3, 'Levothyroxine 75mcg', 'Thyroid hormone replacement that treats hypothyroidism by supplementing low thyroid hormone levels.', 24),
    (3, 'Vitamin D3 2000 IU', 'Essential vitamin supplement that supports bone health, immune function, and overall wellness.', 24),
    (3, 'Sertraline 50mg', 'Antidepressant (SSRI) that helps treat depression and anxiety by balancing serotonin levels in the brain.', 24);

-- Note: dose_history table starts empty - doses will be recorded as users take their medications

-- Made with Bob
