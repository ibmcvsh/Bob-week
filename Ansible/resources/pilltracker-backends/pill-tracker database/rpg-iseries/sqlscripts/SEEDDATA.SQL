-- ================================================================
-- PILL TRACKER SEED DATA FOR DB2 FOR i (IBM iSeries)
-- ================================================================
-- Sample data for testing the Pill Tracker application
-- ================================================================

SET SCHEMA PILLTRK;

-- ================================================================
-- INSERT USERS
-- ================================================================
INSERT INTO PILLTRK.USERS (USER_NAME, CREATED_TS)
VALUES ('Sarah Johnson', CURRENT_TIMESTAMP);

INSERT INTO PILLTRK.USERS (USER_NAME, CREATED_TS)
VALUES ('Michael Chen', CURRENT_TIMESTAMP);

INSERT INTO PILLTRK.USERS (USER_NAME, CREATED_TS)
VALUES ('Emily Rodriguez', CURRENT_TIMESTAMP);

-- ================================================================
-- INSERT PRESCRIPTIONS FOR SARAH JOHNSON (USER_ID = 1)
-- ================================================================
INSERT INTO PILLTRK.PRESCRIP 
    (USER_ID, PRESC_NAME, PRESC_DESC, FREQ_HOURS, CREATED_TS)
VALUES 
    (1, 'Lisinopril 10mg',
     'Blood pressure medication that helps relax blood vessels and lower blood pressure, reducing the risk of heart attack and stroke.',
     24, CURRENT_TIMESTAMP);

INSERT INTO PILLTRK.PRESCRIP 
    (USER_ID, PRESC_NAME, PRESC_DESC, FREQ_HOURS, CREATED_TS)
VALUES 
    (1, 'Metformin 500mg',
     'Diabetes medication that helps control blood sugar levels by improving how your body handles insulin.',
     12, CURRENT_TIMESTAMP);

-- ================================================================
-- INSERT PRESCRIPTIONS FOR MICHAEL CHEN (USER_ID = 2)
-- ================================================================
INSERT INTO PILLTRK.PRESCRIP 
    (USER_ID, PRESC_NAME, PRESC_DESC, FREQ_HOURS, CREATED_TS)
VALUES 
    (2, 'Atorvastatin 20mg',
     'Cholesterol-lowering medication (statin) that reduces bad cholesterol and triglycerides while increasing good cholesterol.',
     24, CURRENT_TIMESTAMP);

INSERT INTO PILLTRK.PRESCRIP 
    (USER_ID, PRESC_NAME, PRESC_DESC, FREQ_HOURS, CREATED_TS)
VALUES 
    (2, 'Omeprazole 20mg',
     'Proton pump inhibitor that reduces stomach acid production, treating heartburn and acid reflux.',
     24, CURRENT_TIMESTAMP);

INSERT INTO PILLTRK.PRESCRIP 
    (USER_ID, PRESC_NAME, PRESC_DESC, FREQ_HOURS, CREATED_TS)
VALUES 
    (2, 'Aspirin 81mg',
     'Low-dose blood thinner that helps prevent blood clots, reducing the risk of heart attack and stroke.',
     24, CURRENT_TIMESTAMP);

-- ================================================================
-- INSERT PRESCRIPTIONS FOR EMILY RODRIGUEZ (USER_ID = 3)
-- ================================================================
INSERT INTO PILLTRK.PRESCRIP 
    (USER_ID, PRESC_NAME, PRESC_DESC, FREQ_HOURS, CREATED_TS)
VALUES 
    (3, 'Levothyroxine 75mcg',
     'Thyroid hormone replacement that treats hypothyroidism by supplementing low thyroid hormone levels.',
     24, CURRENT_TIMESTAMP);

INSERT INTO PILLTRK.PRESCRIP 
    (USER_ID, PRESC_NAME, PRESC_DESC, FREQ_HOURS, CREATED_TS)
VALUES 
    (3, 'Vitamin D3 2000 IU',
     'Essential vitamin supplement that supports bone health, immune function, and overall wellness.',
     24, CURRENT_TIMESTAMP);

INSERT INTO PILLTRK.PRESCRIP 
    (USER_ID, PRESC_NAME, PRESC_DESC, FREQ_HOURS, CREATED_TS)
VALUES 
    (3, 'Sertraline 50mg',
     'Antidepressant (SSRI) that helps treat depression and anxiety by balancing serotonin levels in the brain.',
     24, CURRENT_TIMESTAMP);

-- ================================================================
-- NOTE: DOSE_HIST table starts empty
-- Doses will be recorded as users take their medications
-- ================================================================

-- ================================================================
-- COMMIT CHANGES
-- ================================================================
COMMIT;

-- Made with Bob
