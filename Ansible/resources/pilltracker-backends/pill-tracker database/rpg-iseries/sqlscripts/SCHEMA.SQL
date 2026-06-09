-- ================================================================
-- PILL TRACKER DATABASE SCHEMA FOR DB2 FOR i (IBM iSeries)
-- ================================================================
-- This DDL creates the database objects for the Pill Tracker
-- application on IBM DB2 for i
-- ================================================================

-- Create library (schema) for Pill Tracker
CREATE SCHEMA PILLTRK;

-- Set current schema
SET SCHEMA PILLTRK;

-- Drop tables if they exist (for clean setup)
DROP TABLE PILLTRK.DOSE_HIST;
DROP TABLE PILLTRK.PRESCRIP;
DROP TABLE PILLTRK.USERS;

-- ================================================================
-- USERS TABLE
-- ================================================================
CREATE TABLE PILLTRK.USERS (
    USER_ID         INTEGER         NOT NULL
                                    GENERATED ALWAYS AS IDENTITY
                                    (START WITH 1 INCREMENT BY 1),
    USER_NAME       VARCHAR(255)    NOT NULL,
    CREATED_TS      TIMESTAMP       NOT NULL
                                    DEFAULT CURRENT_TIMESTAMP,
    PRIMARY KEY (USER_ID)
);

LABEL ON TABLE PILLTRK.USERS IS 'Pill Tracker Users';
LABEL ON COLUMN PILLTRK.USERS (
    USER_ID IS 'User ID',
    USER_NAME IS 'User Name',
    CREATED_TS IS 'Created Timestamp'
);

-- Create index on user name for searches
CREATE INDEX PILLTRK.USERS_NM_IX
    ON PILLTRK.USERS (USER_NAME);

-- ================================================================
-- PRESCRIPTIONS TABLE
-- ================================================================
CREATE TABLE PILLTRK.PRESCRIP (
    PRESC_ID        INTEGER         NOT NULL
                                    GENERATED ALWAYS AS IDENTITY
                                    (START WITH 1 INCREMENT BY 1),
    USER_ID         INTEGER         NOT NULL,
    PRESC_NAME      VARCHAR(255)    NOT NULL,
    PRESC_DESC      VARCHAR(500)    NOT NULL,
    FREQ_HOURS      SMALLINT        NOT NULL,
    CREATED_TS      TIMESTAMP       NOT NULL
                                    DEFAULT CURRENT_TIMESTAMP,
    PRIMARY KEY (PRESC_ID),
    FOREIGN KEY (USER_ID)
        REFERENCES PILLTRK.USERS (USER_ID)
        ON DELETE CASCADE
);

LABEL ON TABLE PILLTRK.PRESCRIP IS 'Prescriptions';
LABEL ON COLUMN PILLTRK.PRESCRIP (
    PRESC_ID IS 'Prescription ID',
    USER_ID IS 'User ID',
    PRESC_NAME IS 'Prescription Name',
    PRESC_DESC IS 'Description',
    FREQ_HOURS IS 'Frequency in Hours',
    CREATED_TS IS 'Created Timestamp'
);

-- Create indexes for better query performance
CREATE INDEX PILLTRK.PRESC_USR_IX
    ON PILLTRK.PRESCRIP (USER_ID);

CREATE INDEX PILLTRK.PRESC_NM_IX
    ON PILLTRK.PRESCRIP (PRESC_NAME);

-- ================================================================
-- DOSE HISTORY TABLE
-- ================================================================
CREATE TABLE PILLTRK.DOSE_HIST (
    DOSE_ID         INTEGER         NOT NULL
                                    GENERATED ALWAYS AS IDENTITY
                                    (START WITH 1 INCREMENT BY 1),
    PRESC_ID        INTEGER         NOT NULL,
    TAKEN_TS        TIMESTAMP       NOT NULL,
    CREATED_TS      TIMESTAMP       NOT NULL
                                    DEFAULT CURRENT_TIMESTAMP,
    PRIMARY KEY (DOSE_ID),
    FOREIGN KEY (PRESC_ID)
        REFERENCES PILLTRK.PRESCRIP (PRESC_ID)
        ON DELETE CASCADE
);

LABEL ON TABLE PILLTRK.DOSE_HIST IS 'Dose History';
LABEL ON COLUMN PILLTRK.DOSE_HIST (
    DOSE_ID IS 'Dose ID',
    PRESC_ID IS 'Prescription ID',
    TAKEN_TS IS 'Taken Timestamp',
    CREATED_TS IS 'Created Timestamp'
);

-- Create indexes for dose history queries
CREATE INDEX PILLTRK.DOSE_PRSC_IX
    ON PILLTRK.DOSE_HIST (PRESC_ID);

CREATE INDEX PILLTRK.DOSE_TAKN_IX
    ON PILLTRK.DOSE_HIST (TAKEN_TS DESC);

-- ================================================================
-- GRANT PERMISSIONS
-- ================================================================
GRANT SELECT, INSERT, UPDATE, DELETE ON PILLTRK.USERS TO PUBLIC;
GRANT SELECT, INSERT, UPDATE, DELETE ON PILLTRK.PRESCRIP TO PUBLIC;
GRANT SELECT, INSERT, UPDATE, DELETE ON PILLTRK.DOSE_HIST TO PUBLIC;

-- ================================================================
-- COMMIT CHANGES
-- ================================================================
COMMIT;

-- Made with Bob
