# Pill Tracker - RPG ILE iSeries Implementation

This directory contains the IBM iSeries (AS/400) RPG ILE implementation of the Pill Tracker REST API, using Integrated Web Services and DB2 for i.

## Architecture

### Technology Stack
- **Language**: RPG ILE (Integrated Language Environment)
- **Web Services**: IBM Integrated Web Services for i
- **Database**: DB2 for i
- **Build System**: CL (Control Language)
- **Format**: Free-form RPG

### Components

```
rpg-iseries/
├── sqlscripts/         # Database SQL scripts
│   ├── SCHEMA.SQL     # DB2 for i table definitions
│   └── SEEDDATA.SQL   # Sample data
├── rpgle/             # RPG ILE source programs
│   ├── PTGETURS.sqlrpgle  # GET /api/users
│   ├── PTGETPRS.sqlrpgle  # GET /api/users/:id/prescriptions
│   └── PTPOSTDS.sqlrpgle  # POST /api/doses
├── copybooks/         # RPG copybooks (data structures)
│   ├── USERSTRU.rpgleinc  # User structures
│   └── PRESCSTR.rpgleinc  # Prescription structures
├── clle/              # CL programs
│   └── COMPILE.clle   # Compilation script
├── iws/               # Integrated Web Services config
│   └── PILLTRK.wsdl   # Web service definitions
└── README.md          # This file
```

## REST API Endpoints

The RPG implementation provides the same REST API as the Node.js version:

### GET /api/users
- **Program**: PTGETURS
- **Description**: Returns all users in JSON format
- **Response**: Array of user objects

### GET /api/users/:userId/prescriptions-with-history
- **Program**: PTGETPRS
- **Description**: Returns prescriptions for a user with last dose information
- **Response**: Array of prescription objects with last_taken timestamp

### POST /api/doses
- **Program**: PTPOSTDS
- **Description**: Records a dose taken
- **Request Body**: `{"prescription_id": 1, "taken_at": "2026-03-05T10:30:00Z"}`
- **Response**: Created dose record

## Database Schema

### Tables

#### PILLTRK.USERS
- USER_ID (INTEGER) - Primary key (auto-generated)
- USER_NAME (VARCHAR(255))
- CREATED_TS (TIMESTAMP)

#### PILLTRK.PRESCRIP
- PRESC_ID (INTEGER) - Primary key (auto-generated)
- USER_ID (INTEGER) - Foreign key to USERS
- PRESC_NAME (VARCHAR(255))
- PRESC_DESC (VARCHAR(500))
- FREQ_HOURS (SMALLINT)
- CREATED_TS (TIMESTAMP)

#### PILLTRK.DOSE_HIST
- DOSE_ID (INTEGER) - Primary key (auto-generated)
- PRESC_ID (INTEGER) - Foreign key to PRESCRIP
- TAKEN_TS (TIMESTAMP)
- CREATED_TS (TIMESTAMP)

## Installation Instructions

### Prerequisites

1. IBM i operating system (V7R2 or higher recommended)
2. DB2 for i
3. IBM Integrated Web Services for i
4. Authority to create libraries and objects
5. 5250 terminal emulator or SSH access

### Step 1: Create Library

```
CRTLIB LIB(PILLTRK) TEXT('Pill Tracker Application')
```

### Step 2: Create Database Objects

```
// Run SQL scripts via RUNSQLSTM or ACS Run SQL Scripts

RUNSQLSTM SRCSTMF('/path/to/SCHEMA.SQL') COMMIT(*NONE)
RUNSQLSTM SRCSTMF('/path/to/SEEDDATA.SQL') COMMIT(*NONE)
```

Or using ACS (Access Client Solutions):
1. Open "Run SQL Scripts"
2. Load SCHEMA.SQL
3. Execute
4. Load SEEDDATA.SQL
5. Execute

### Step 3: Upload Source Files

Upload the following files to iSeries:
- RPG programs → PILLTRK/QRPGLESRC
- Copybooks → PILLTRK/QRPGLEREF
- CL programs → PILLTRK/QCLLESRC

Using FTP or IFS:
```bash
# Create IFS directories
mkdir /PILLTRK
mkdir /PILLTRK/rpgle
mkdir /PILLTRK/copybooks
mkdir /PILLTRK/clle

# Upload files
# Then copy to source physical files
```

### Step 4: Compile Programs

Option A - Using CL Program:
```
CALL PILLTRK/COMPILE
```

Option B - Manual Compilation:
```
// Compile PTGETURS
CRTSQLRPGI OBJ(PILLTRK/PTGETURS) +
           SRCFILE(PILLTRK/QRPGLESRC) +
           SRCMBR(PTGETURS) +
           COMMIT(*NONE) +
           DBGVIEW(*SOURCE)

// Compile PTGETPRS
CRTSQLRPGI OBJ(PILLTRK/PTGETPRS) +
           SRCFILE(PILLTRK/QRPGLESRC) +
           SRCMBR(PTGETPRS) +
           COMMIT(*NONE) +
           DBGVIEW(*SOURCE)

// Compile PTPOSTDS
CRTSQLRPGI OBJ(PILLTRK/PTPOSTDS) +
           SRCFILE(PILLTRK/QRPGLESRC) +
           SRCMBR(PTPOSTDS) +
           COMMIT(*NONE) +
           DBGVIEW(*SOURCE)
```

### Step 5: Configure Integrated Web Services

1. **Start IWS Server**
   ```
   STRTCPSVR SERVER(*HTTP) HTTPSVR(PILLTRK)
   ```

2. **Deploy Web Services**
   - Access IBM Web Administration for i
   - Navigate to: http://your-iseries:2001/HTTPAdmin
   - Create new server instance (if needed)
   - Deploy PILLTRK.wsdl
   - Map endpoints to RPG programs:
     - /api/users → PILLTRK/PTGETURS
     - /api/users/*/prescriptions-with-history → PILLTRK/PTGETPRS
     - /api/doses → PILLTRK/PTPOSTDS

3. **Configure CORS (if needed)**
   - Add CORS headers in IWS configuration
   - Allow origin: * (or specific domain)
   - Allow methods: GET, POST
   - Allow headers: Content-Type

### Step 6: Test the API

```bash
# From a workstation with network access to iSeries

# Test GET users
curl http://iseries-host:port/api/users

# Test GET prescriptions
curl http://iseries-host:port/api/users/1/prescriptions-with-history

# Test POST dose
curl -X POST http://iseries-host:port/api/doses \
  -H "Content-Type: application/json" \
  -d '{"prescription_id":1,"taken_at":"2026-03-05T10:30:00Z"}'
```

## RPG Program Structure

### PTGETURS (Get Users)
1. Opens DB2 cursor for USERS table
2. Fetches all user records into array
3. Builds JSON array response using string concatenation
4. Returns JSON with HTTP 200

### PTGETPRS (Get Prescriptions)
1. Receives user ID as parameter
2. Opens DB2 cursor with LEFT JOIN to get last dose
3. Fetches prescription records into array
4. Builds JSON array with prescription details
5. Returns JSON with HTTP 200

### PTPOSTDS (Post Dose)
1. Receives prescription ID and timestamp
2. Inserts dose record into DOSE_HIST table
3. Retrieves generated dose ID
4. Returns created record in JSON with HTTP 201

## Key Features

### Modern RPG ILE
- **Free-form syntax**: Easier to read and maintain
- **Embedded SQL**: Direct DB2 integration
- **Modular design**: Procedures for JSON building
- **Error handling**: SQLCODE checking
- **ILE activation groups**: Proper resource management

### Enterprise-Grade
- **Transaction Management**: DB2 commitment control
- **Performance**: Compiled native code
- **Scalability**: iSeries multi-threading
- **Security**: Integration with iSeries security
- **Monitoring**: iSeries job monitoring
- **High Availability**: iSeries HA solutions

### JSON Generation
- Manual JSON building using string concatenation
- Proper escaping of special characters
- Null handling for optional fields
- Timestamp formatting

## Troubleshooting

### Common Issues

#### SQL0204 - Object not found
- Verify library PILLTRK exists
- Check table names are correct
- Ensure current library is set: `CHGCURLIB PILLTRK`

#### RNX0100 - Decimal data error
- Check data type conversions
- Verify numeric field definitions
- Review %CHAR() usage for integers

#### IWS Deployment Fails
- Verify IWS server is running
- Check program authorities
- Review IWS server logs in /www/pilltrk/logs

#### JSON Formatting Issues
- Validate JSON with online validators
- Check for missing commas or quotes
- Verify string concatenation doesn't overflow

### Debug Tools

1. **STRDBG** (Start Debug)
   ```
   STRDBG PGM(PILLTRK/PTGETURS)
   // Set breakpoints
   // Call program
   ```

2. **DSPPGMREF** (Display Program References)
   ```
   DSPPGMREF PGM(PILLTRK/PTGETURS)
   ```

3. **DSPJOBLOG** (Display Job Log)
   ```
   DSPJOBLOG
   ```

4. **SQL Logging**
   ```
   STRDBMON
   // Run program
   ENDDBMON
   PRTSQLINF
   ```

## Performance Considerations

### Optimization Tips
1. Use SQL cursors efficiently
2. Minimize array sizes based on expected data
3. Consider connection pooling in IWS
4. Use proper indexes on DB2 tables
5. Monitor job CPU and memory usage

### Monitoring
- Use WRKACTJOB to monitor active jobs
- Review IWS server performance metrics
- Analyze DB2 query performance with Visual Explain
- Check system ASP usage

## Comparison with Other Implementations

| Feature | Node.js | COBOL/CICS | RPG/iSeries |
|---------|---------|------------|-------------|
| Language | JavaScript | COBOL | RPG ILE |
| Runtime | Node.js | CICS TS | iSeries |
| Database | PostgreSQL | DB2 z/OS | DB2 for i |
| Web Services | Express | CICS Web | IWS |
| Syntax | Modern | Verbose | Free-form |
| JSON | Native | Manual | Manual |
| Deployment | Container | Mainframe | iSeries |
| Learning Curve | Low | High | Medium |

## Maintenance

### Adding New Endpoints
1. Create new RPG program in rpgle/
2. Add copybook if needed
3. Update COMPILE.clle
4. Deploy via IWS
5. Test thoroughly

### Modifying Database Schema
1. Update SCHEMA.SQL
2. Create migration scripts
3. Update copybooks to match
4. Recompile affected programs
5. Test in development partition

### Updating Programs
1. Modify source in QRPGLESRC
2. Recompile with CRTSQLRPGI
3. No need to restart IWS (dynamic loading)
4. Test changes

## Best Practices

### RPG Coding Standards
- Use meaningful variable names
- Comment complex logic
- Use qualified data structures
- Implement proper error handling
- Follow free-form indentation

### Security
- Use *PUBLIC authority appropriately
- Implement user authentication in IWS
- Validate all input parameters
- Use SQL parameter markers (prevents injection)
- Enable SSL/TLS for production

### Testing
- Unit test each program individually
- Integration test via IWS
- Load test with multiple concurrent users
- Validate JSON responses
- Test error scenarios

## Support

For iSeries-specific issues:
- Consult IBM i documentation
- Review IBM Redbooks for RPG ILE
- Check IBM Support forums
- Contact iSeries systems administrator

## License

Same as main project - MIT License