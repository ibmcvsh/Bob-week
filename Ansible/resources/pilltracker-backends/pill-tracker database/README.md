# 💊 Pill Tracker Application

A full-stack Single Page Application (SPA) for tracking medication schedules with PostgreSQL database and REST API backend.

## Features

- 👥 Multiple user support with sample data
- 💊 Prescription management with detailed medication information
- ⏰ Time-based notifications for due and overdue medications
- 📊 Dose history tracking
- 🎨 Modern, responsive UI with smooth animations
- 🔄 Real-time updates via REST API

## Architecture

### Frontend
- **Technology**: Vanilla JavaScript, HTML5, CSS3
- **Features**:
  - User selection interface
  - Real-time medication status tracking
  - Time simulation for demo purposes
  - Visual notifications for due/overdue medications

### Backend Options

#### Option 1: Node.js/PostgreSQL (Modern Stack)
- **Technology**: Node.js, Express.js
- **Database**: PostgreSQL
- **API**: RESTful endpoints for users, prescriptions, and dose tracking
- **Location**: `postgres/` directory

#### Option 2: COBOL/DB2 Mainframe (Enterprise Stack)
- **Technology**: Enterprise COBOL for z/OS, CICS Transaction Server
- **Database**: DB2 for z/OS
- **API**: Same REST endpoints implemented in COBOL
- **Location**: `cobol-mainframe/` directory

#### Option 3: RPG ILE iSeries (Midrange Stack)
- **Technology**: RPG ILE (free-form), Integrated Web Services
- **Database**: DB2 for i
- **API**: Same REST endpoints implemented in RPG
- **Location**: `rpg-iseries/` directory

## Project Structure

```
pill-tracker/
├── index.html              # Main HTML file
├── styles.css              # Application styles
├── app.js                  # Frontend JavaScript (API-integrated)
├── pill-tracker-spec.md    # Original specification
├── README.md               # This file
├── postgres/               # Node.js/PostgreSQL Backend
│   ├── server.js           # Express API server
│   ├── db.js               # Database connection
│   ├── schema.sql          # Database schema
│   ├── seed.sql            # Sample data
│   ├── setup.sh            # Automated setup script
│   ├── package.json        # Node.js dependencies
│   ├── .env                # Environment configuration
│   └── README.md           # Backend documentation
├── cobol-mainframe/        # COBOL/DB2 Mainframe Backend
│   ├── copybooks/          # COBOL data structures
│   │   ├── USERSTR.cpy     # User structure
│   │   ├── PRESCSTR.cpy    # Prescription structure
│   │   └── APICOMM.cpy     # API communication area
│   ├── programs/           # COBOL source programs
│   │   ├── PTGETURS.cbl    # GET /api/users
│   │   ├── PTGETPRS.cbl    # GET prescriptions
│   │   └── PTPOSTDS.cbl    # POST /api/doses
│   ├── jcl/                # Job Control Language
│   │   └── COMPILE.jcl     # Compilation JCL
│   ├── db2/                # DB2 database
│   │   ├── SCHEMA.SQL      # DB2 schema
│   │   └── SEEDDATA.SQL    # Sample data
│   ├── cics/               # CICS configuration
│   │   └── CSDDEF.txt      # Resource definitions
│   └── README.md           # Mainframe documentation
└── rpg-iseries/            # RPG ILE iSeries Backend
    ├── sqlscripts/         # Database SQL scripts
    │   ├── SCHEMA.SQL      # DB2 for i schema
    │   └── SEEDDATA.SQL    # Sample data
    ├── rpgle/              # RPG ILE source programs
    │   ├── PTGETURS.sqlrpgle  # GET /api/users
    │   ├── PTGETPRS.sqlrpgle  # GET prescriptions
    │   └── PTPOSTDS.sqlrpgle  # POST /api/doses
    ├── copybooks/          # RPG data structures
    │   ├── USERSTRU.rpgleinc  # User structures
    │   └── PRESCSTR.rpgleinc  # Prescription structures
    ├── clle/               # CL programs
    │   └── COMPILE.clle    # Compilation script
    ├── iws/                # Integrated Web Services
    │   └── PILLTRK.wsdl    # Web service definitions
    └── README.md           # iSeries documentation
```

## Quick Start

### Option 1: Node.js/PostgreSQL Backend

#### Prerequisites
- Node.js (v14 or higher)
- PostgreSQL (v12 or higher)
- npm or yarn

#### Installation

1. **Clone or download the project**

2. **Set up the database and API**
   ```bash
   cd postgres
   ./setup.sh
   ```
   
   This script will:
   - Create the PostgreSQL database
   - Initialize the schema
   - Load sample data
   - Install Node.js dependencies

3. **Start the API server**
   ```bash
   cd postgres
   npm start
   ```
   
   The API will run on `http://localhost:3000`

4. **Open the frontend**
   
   Open `index.html` in your web browser, or use a local server:
   ```bash
   # Using Python 3
   python3 -m http.server 8080
   
   # Using Node.js http-server
   npx http-server -p 8080
   ```
   
   Then visit `http://localhost:8080`

### Option 2: COBOL/DB2 Mainframe Backend

#### Prerequisites
- IBM z/OS operating system
- CICS Transaction Server for z/OS
- DB2 for z/OS
- Enterprise COBOL compiler
- TSO/ISPF access

#### Installation

See detailed instructions in `cobol-mainframe/README.md`

1. **Create DB2 database and tables**
2. **Allocate mainframe datasets**
3. **Upload COBOL source and copybooks**
4. **Compile programs using JCL**
5. **Configure CICS resources**
6. **Test REST API endpoints**

The COBOL implementation provides the same REST API endpoints as the Node.js version, allowing the same frontend to work with either backend.

### Option 3: RPG ILE iSeries Backend

#### Prerequisites
- IBM i operating system (V7R2 or higher)
- DB2 for i
- IBM Integrated Web Services for i
- Authority to create libraries
- 5250 terminal or SSH access

#### Installation

See detailed instructions in `rpg-iseries/README.md`

1. **Create library and database objects**
2. **Upload RPG source and copybooks**
3. **Compile programs using CL**
4. **Configure Integrated Web Services**
5. **Deploy web service definitions**
6. **Test REST API endpoints**

The RPG implementation provides the same REST API endpoints, allowing the same frontend to work with any backend option.

## Usage

1. **Select a User**: Choose from Sarah Johnson, Michael Chen, or Emily Rodriguez
2. **View Prescriptions**: See all medications with descriptions and schedules
3. **Check Status**: Medications show as "DUE NOW", "OVERDUE", or "Up to date"
4. **Mark as Taken**: Click the button to record taking a medication
5. **Advance Time**: Use the "Advance Time by 8 Hours" button to simulate time passing

## Sample Users

### Sarah Johnson
- Lisinopril 10mg (every 24 hours) - Blood pressure medication
- Metformin 500mg (every 12 hours) - Diabetes medication

### Michael Chen
- Atorvastatin 20mg (every 24 hours) - Cholesterol medication
- Omeprazole 20mg (every 24 hours) - Acid reflux medication
- Aspirin 81mg (every 24 hours) - Blood thinner

### Emily Rodriguez
- Levothyroxine 75mcg (every 24 hours) - Thyroid medication
- Vitamin D3 2000 IU (every 24 hours) - Vitamin supplement
- Sertraline 50mg (every 24 hours) - Antidepressant

## API Endpoints

See `postgres/README.md` for complete API documentation.

Key endpoints:
- `GET /api/users` - List all users
- `GET /api/users/:userId/prescriptions-with-history` - Get user's prescriptions
- `POST /api/doses` - Record a dose taken

## Development

### Frontend Development
Edit `app.js`, `styles.css`, or `index.html` and refresh the browser.

### Backend Development
```bash
cd postgres
npm run dev  # Uses nodemon for auto-reload
```

### Database Changes
1. Modify `postgres/schema.sql`
2. Run `./setup.sh` to recreate the database

## Troubleshooting

### API Connection Issues
- Ensure PostgreSQL is running: `pg_isready`
- Check the API server is running on port 3000
- Verify `.env` configuration in the `postgres` folder

### CORS Issues
The API includes CORS middleware. If you still have issues, ensure you're accessing the frontend via a proper HTTP server, not `file://` protocol.

### Database Connection
Check your PostgreSQL credentials in `postgres/.env`:
```
DB_HOST=localhost
DB_PORT=5432
DB_NAME=pill_tracker
DB_USER=postgres
DB_PASSWORD=postgres
```

## License

MIT License - Feel free to use this project for learning and demonstration purposes.

## Future Enhancements

- User authentication and authorization
- Push notifications for medication reminders
- Mobile app version
- Medication interaction warnings
- Prescription refill tracking
- Doctor and pharmacy information
- Export medication history reports