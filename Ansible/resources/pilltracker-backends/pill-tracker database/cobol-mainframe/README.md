# Pill Tracker - COBOL Mainframe Implementation

This directory contains the IBM Mainframe COBOL implementation of the Pill Tracker REST API, using CICS for web services and DB2 for data storage.

## Architecture

### Technology Stack
- **Language**: Enterprise COBOL for z/OS
- **Transaction Server**: CICS TS (Customer Information Control System)
- **Database**: DB2 for z/OS
- **Web Services**: CICS Web Support
- **Build System**: JCL (Job Control Language)

### Components

```
cobol-mainframe/
├── copybooks/          # COBOL copybooks (data structures)
│   ├── USERSTR.cpy    # User record structure
│   ├── PRESCSTR.cpy   # Prescription record structure
│   └── APICOMM.cpy    # API communication area
├── programs/           # COBOL source programs
│   ├── PTGETURS.cbl   # GET /api/users
│   ├── PTGETPRS.cbl   # GET /api/users/:id/prescriptions-with-history
│   └── PTPOSTDS.cbl   # POST /api/doses
├── jcl/               # Job Control Language scripts
│   └── COMPILE.jcl    # Compilation and binding JCL
├── db2/               # Database definitions
│   ├── SCHEMA.SQL     # DB2 table definitions
│   └── SEEDDATA.SQL   # Sample data
├── cics/              # CICS configuration
│   └── CSDDEF.txt     # CICS resource definitions
└── README.md          # This file
```

## REST API Endpoints

The COBOL implementation provides the same REST API as the Node.js version:

### GET /api/users
- **Program**: PTGETURS
- **Transaction**: PTUR
- **Description**: Returns all users in JSON format
- **Response**: Array of user objects

### GET /api/users/:userId/prescriptions-with-history
- **Program**: PTGETPRS
- **Transaction**: PTPR
- **Description**: Returns prescriptions for a user with last dose information
- **Response**: Array of prescription objects with last_taken timestamp

### POST /api/doses
- **Program**: PTPOSTDS
- **Transaction**: PTDS
- **Description**: Records a dose taken
- **Request Body**: `{"prescription_id": 1, "taken_at": "2026-03-05T10:30:00Z"}`
- **Response**: Created dose record

## Database Schema

### Tables

#### PILLTRK.USERS
- USER_ID (INTEGER) - Primary key
- USER_NAME (VARCHAR(255))
- CREATED_TS (TIMESTAMP)

#### PILLTRK.PRESCRIP
- PRESC_ID (INTEGER) - Primary key
- USER_ID (INTEGER) - Foreign key to USERS
- PRESC_NAME (VARCHAR(255))
- PRESC_DESC (VARCHAR(500))
- FREQ_HOURS (SMALLINT)
- CREATED_TS (TIMESTAMP)

#### PILLTRK.DOSE_HIST
- DOSE_ID (INTEGER) - Primary key
- PRESC_ID (INTEGER) - Foreign key to PRESCRIP
- TAKEN_TS (TIMESTAMP)
- CREATED_TS (TIMESTAMP)

## Installation Instructions

### Prerequisites

1. IBM z/OS operating system
2. CICS Transaction Server for z/OS (v5.3 or higher)
3. DB2 for z/OS (v12 or higher)
4. Enterprise COBOL compiler
5. TSO/ISPF access
6. Appropriate security permissions (RACF/ACF2/Top Secret)

### Step 1: Create DB2 Database

```
// Submit DB2 commands via SPUFI or DSNTEP2
// 1. Create database and tablespace
// 2. Run SCHEMA.SQL to create tables
// 3. Run SEEDDATA.SQL to load sample data

TSO SUBMIT 'PILLTRK.DB2.SCHEMA'
TSO SUBMIT 'PILLTRK.DB2.SEEDDATA'
```

### Step 2: Allocate Datasets

```jcl
// Allocate required datasets
//ALLOC   EXEC PGM=IEFBR14
//SRCLIB  DD DSN=PILLTRK.SRCLIB,
//           DISP=(NEW,CATLG),
//           SPACE=(TRK,(10,5)),
//           DCB=(RECFM=FB,LRECL=80,BLKSIZE=3200)
//COPYLIB DD DSN=PILLTRK.COPYLIB,
//           DISP=(NEW,CATLG),
//           SPACE=(TRK,(5,2)),
//           DCB=(RECFM=FB,LRECL=80,BLKSIZE=3200)
//LOADLIB DD DSN=PILLTRK.LOADLIB,
//           DISP=(NEW,CATLG),
//           SPACE=(TRK,(20,10,5)),
//           DCB=(RECFM=U,BLKSIZE=32760)
```

### Step 3: Upload Source Files

Upload the following files to their respective datasets:
- Copybooks → PILLTRK.COPYLIB
- Programs → PILLTRK.SRCLIB

### Step 4: Compile Programs

```
// Submit COMPILE.jcl
TSO SUBMIT 'PILLTRK.JCL(COMPILE)'

// Verify compilation
// Check for RC=0000 in job output
```

### Step 5: Configure CICS

```
// 1. Start CICS region
// 2. Access CEDA (CICS Explorer Definition and Administration)

CEDA

// 3. Define resources using CSDDEF.txt commands
// 4. Install the PILLTRK group

CEDA INSTALL GROUP(PILLTRK)

// 5. Verify installation
CEMT INQUIRE PROGRAM(PTGETURS)
CEMT INQUIRE PROGRAM(PTGETPRS)
CEMT INQUIRE PROGRAM(PTPOSTDS)
```

### Step 6: Configure CICS Web Support

1. Enable CICS Web Support in CICS region
2. Configure TCPIPSERVICE for HTTP (typically port 8080)
3. Verify URIMAP definitions are active

```
CEMT INQUIRE URIMAP(PTUSERS)
CEMT INQUIRE URIMAP(PTPRESC)
CEMT INQUIRE URIMAP(PTDOSES)
```

### Step 7: Test the API

```bash
# From a workstation with network access to mainframe

# Test GET users
curl http://mainframe-host:8080/api/users

# Test GET prescriptions
curl http://mainframe-host:8080/api/users/1/prescriptions-with-history

# Test POST dose
curl -X POST http://mainframe-host:8080/api/doses \
  -H "Content-Type: application/json" \
  -d '{"prescription_id":1,"taken_at":"2026-03-05T10:30:00Z"}'
```

## COBOL Program Structure

### PTGETURS (Get Users)
1. Opens DB2 cursor for USERS table
2. Fetches all user records
3. Builds JSON array response
4. Sends HTTP response via CICS WEB SEND

### PTGETPRS (Get Prescriptions)
1. Parses user ID from URI
2. Opens DB2 cursor with LEFT JOIN to get last dose
3. Fetches prescription records
4. Builds JSON array with prescription details
5. Sends HTTP response

### PTPOSTDS (Post Dose)
1. Parses JSON request body
2. Gets next sequence value for dose ID
3. Inserts dose record into DOSE_HIST table
4. Commits transaction
5. Returns created record in JSON

## Key Features

### Enterprise-Grade
- **Transaction Management**: CICS ensures ACID properties
- **Connection Pooling**: DB2 connection pooling via CICS
- **Scalability**: CICS can handle thousands of concurrent transactions
- **Security**: Integration with mainframe security (RACF/ACF2)
- **Monitoring**: CICS monitoring and statistics
- **High Availability**: CICS sysplex support

### COBOL Best Practices
- Structured programming with PERFORM statements
- Proper error handling with SQLCODE checking
- Copybooks for reusable data structures
- Embedded SQL with host variables
- CICS command-level API usage

## Troubleshooting

### Common Issues

#### SQLCODE -811 (Multiple rows returned)
- Check cursor definitions
- Ensure FETCH FIRST 1 ROW ONLY in subqueries

#### CICS ABEND ASRA
- Check for data type mismatches
- Verify WORKING-STORAGE initialization
- Review COBOL compiler listing for warnings

#### HTTP 404 Not Found
- Verify URIMAP definitions are installed
- Check PATH specifications match exactly
- Ensure programs are enabled in CICS

#### JSON Formatting Issues
- Verify STRING statements don't overflow buffer
- Check POINTER values in STRING operations
- Validate JSON structure with online validators

### Debug Tools

1. **CEDF** (CICS Execution Diagnostic Facility)
   ```
   CEDF
   // Then execute transaction
   ```

2. **CECI** (CICS Command Interpreter)
   ```
   CECI INQUIRE PROGRAM(PTGETURS)
   ```

3. **DB2 Traces**
   ```
   -START TRACE(PERFM) CLASS(3)
   ```

## Performance Considerations

### Optimization Tips
1. Use PREPARE/EXECUTE for dynamic SQL
2. Implement cursor WITH HOLD for long-running queries
3. Use CICS program caching (RESIDENT)
4. Optimize DB2 access paths with proper indexes
5. Consider CICS connection pooling settings

### Monitoring
- Monitor CICS transaction response times
- Track DB2 CPU consumption
- Review CICS storage usage
- Analyze DB2 explain plans

## Comparison with Node.js Implementation

| Feature | Node.js | COBOL/CICS |
|---------|---------|------------|
| Language | JavaScript | COBOL |
| Runtime | Node.js | CICS TS |
| Database | PostgreSQL | DB2 z/OS |
| Concurrency | Event Loop | Multi-threading |
| Scalability | Horizontal | Vertical + Sysplex |
| Transaction | Manual | Automatic (CICS) |
| Security | Application | Mainframe (RACF) |
| Monitoring | Custom | Built-in (CICS) |

## Maintenance

### Adding New Endpoints
1. Create new COBOL program in programs/
2. Add copybook if needed
3. Update COMPILE.jcl
4. Add CICS definitions to CSDDEF.txt
5. Compile and install

### Modifying Database Schema
1. Update SCHEMA.SQL
2. Create migration scripts
3. Update copybooks to match
4. Recompile affected programs
5. Test thoroughly in development region

## Support

For mainframe-specific issues:
- Consult IBM CICS documentation
- Review IBM DB2 manuals
- Contact mainframe systems programming team
- Check IBM support forums

## License

Same as main project - MIT License