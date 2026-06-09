-- ================================================================
-- PILL TRACKER DATABASE SCHEMA FOR DB2 z/OS
-- ================================================================
-- This DDL creates the database objects for the Pill Tracker
-- application on IBM DB2 for z/OS
-- ================================================================

-- Drop tables if they exist (for clean setup)
DROP TABLE PILLTRK.DOSE_HIST;
DROP TABLE PILLTRK.PRESCRIP;
DROP TABLE PILLTRK.USERS;

-- Create tablespace for Pill Tracker
CREATE TABLESPACE PILLTRTS
    IN PILLTRDB
    USING STOGROUP SYSDEFLT
    PRIQTY 1000
    SECQTY 500
    ERASE NO
    BUFFERPOOL BP0
    LOCKSIZE PAGE
    CLOSE NO;

-- ================================================================
-- USERS TABLE
-- ================================================================
CREATE TABLE PILLTRK.USERS
(
    USER_ID         INTEGER         NOT NULL,
    USER_NAME       VARCHAR(255)    NOT NULL,
    CREATED_TS      TIMESTAMP       NOT NULL
                                    DEFAULT CURRENT TIMESTAMP,
    PRIMARY KEY (USER_ID)
)
IN PILLTRDB.PILLTRTS;

-- Create index on user name for searches
CREATE INDEX PILLTRK.USERS_NM_IX
    ON PILLTRK.USERS (USER_NAME);

-- ================================================================
-- PRESCRIPTIONS TABLE
-- ================================================================
CREATE TABLE PILLTRK.PRESCRIP
(
    PRESC_ID        INTEGER         NOT NULL,
    USER_ID         INTEGER         NOT NULL,
    PRESC_NAME      VARCHAR(255)    NOT NULL,
    PRESC_DESC      VARCHAR(500)    NOT NULL,
    FREQ_HOURS      SMALLINT        NOT NULL,
    CREATED_TS      TIMESTAMP       NOT NULL
                                    DEFAULT CURRENT TIMESTAMP,
    PRIMARY KEY (PRESC_ID),
    FOREIGN KEY (USER_ID)
        REFERENCES PILLTRK.USERS (USER_ID)
        ON DELETE CASCADE
)
IN PILLTRDB.PILLTRTS;

-- Create indexes for better query performance
CREATE INDEX PILLTRK.PRESC_USR_IX
    ON PILLTRK.PRESCRIP (USER_ID);

CREATE INDEX PILLTRK.PRESC_NM_IX
    ON PILLTRK.PRESCRIP (PRESC_NAME);

-- ================================================================
-- DOSE HISTORY TABLE
-- ================================================================
CREATE TABLE PILLTRK.DOSE_HIST
(
    DOSE_ID         INTEGER         NOT NULL,
    PRESC_ID        INTEGER         NOT NULL,
    TAKEN_TS        TIMESTAMP       NOT NULL,
    CREATED_TS      TIMESTAMP       NOT NULL
                                    DEFAULT CURRENT TIMESTAMP,
    PRIMARY KEY (DOSE_ID),
    FOREIGN KEY (PRESC_ID)
        REFERENCES PILLTRK.PRESCRIP (PRESC_ID)
        ON DELETE CASCADE
)
IN PILLTRDB.PILLTRTS;

-- Create indexes for dose history queries
CREATE INDEX PILLTRK.DOSE_PRSC_IX
    ON PILLTRK.DOSE_HIST (PRESC_ID);

CREATE INDEX PILLTRK.DOSE_TAKN_IX
    ON PILLTRK.DOSE_HIST (TAKEN_TS DESC);

-- ================================================================
-- CREATE SEQUENCES FOR AUTO-INCREMENT IDs
-- ================================================================
CREATE SEQUENCE PILLTRK.USER_SEQ
    START WITH 1
    INCREMENT BY 1
    NO MAXVALUE
    NO CYCLE
    CACHE 20;

CREATE SEQUENCE PILLTRK.PRESC_SEQ
    START WITH 1
    INCREMENT BY 1
    NO MAXVALUE
    NO CYCLE
    CACHE 20;

CREATE SEQUENCE PILLTRK.DOSE_SEQ
    START WITH 1
    INCREMENT BY 1
    NO MAXVALUE
    NO CYCLE
    CACHE 20;

-- ================================================================
-- GRANT PERMISSIONS
-- ================================================================
GRANT SELECT, INSERT, UPDATE, DELETE ON PILLTRK.USERS TO PUBLIC;
GRANT SELECT, INSERT, UPDATE, DELETE ON PILLTRK.PRESCRIP TO PUBLIC;
GRANT SELECT, INSERT, UPDATE, DELETE ON PILLTRK.DOSE_HIST TO PUBLIC;
GRANT USAGE ON SEQUENCE PILLTRK.USER_SEQ TO PUBLIC;
GRANT USAGE ON SEQUENCE PILLTRK.PRESC_SEQ TO PUBLIC;
GRANT USAGE ON SEQUENCE PILLTRK.DOSE_SEQ TO PUBLIC;

-- ================================================================
-- COMMIT CHANGES
-- ================================================================
COMMIT;

-- Made with Bob
