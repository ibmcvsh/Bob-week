# Pill Tracker API - PostgreSQL Backend

REST API backend for the Pill Tracker application using Node.js, Express, and PostgreSQL.

## Prerequisites

- Node.js (v14 or higher)
- PostgreSQL (v12 or higher)
- npm or yarn

## Setup Instructions

### 1. Install PostgreSQL

Make sure PostgreSQL is installed and running on your system.

### 2. Create Database

```bash
# Connect to PostgreSQL
psql -U postgres

# Create the database
CREATE DATABASE pill_tracker;

# Exit psql
\q
```

### 3. Initialize Database Schema

```bash
# Run schema creation
psql -U postgres -d pill_tracker -f schema.sql

# Run seed data
psql -U postgres -d pill_tracker -f seed.sql
```

### 4. Install Dependencies

```bash
cd postgres
npm install
```

### 5. Configure Environment

Edit the `.env` file if needed to match your PostgreSQL configuration:

```
DB_HOST=localhost
DB_PORT=5432
DB_NAME=pill_tracker
DB_USER=postgres
DB_PASSWORD=postgres
PORT=3000
```

### 6. Start the Server

```bash
# Development mode (with auto-reload)
npm run dev

# Production mode
npm start
```

The API will be available at `http://localhost:3000`

## API Endpoints

### Users

- `GET /api/users` - Get all users
- `GET /api/users/:id` - Get a specific user
- `GET /api/users/:userId/prescriptions` - Get all prescriptions for a user
- `GET /api/users/:userId/prescriptions-with-history` - Get prescriptions with last dose info
- `GET /api/users/:userId/dose-history` - Get dose history for a user

### Prescriptions

- `GET /api/prescriptions/:id` - Get a specific prescription with last dose
- `GET /api/prescriptions/:id/history` - Get dose history for a prescription

### Doses

- `POST /api/doses` - Record a dose taken
  - Body: `{ "prescription_id": 1, "taken_at": "2024-03-05T10:30:00Z" }`

### Health Check

- `GET /api/health` - Check if API is running

## Database Schema

### Users Table
- `id` - Primary key
- `name` - User's full name
- `created_at` - Timestamp

### Prescriptions Table
- `id` - Primary key
- `user_id` - Foreign key to users
- `name` - Medication name
- `description` - What the medication does
- `frequency_hours` - Hours between doses
- `created_at` - Timestamp

### Dose History Table
- `id` - Primary key
- `prescription_id` - Foreign key to prescriptions
- `taken_at` - When the dose was taken
- `created_at` - Timestamp

## Testing the API

You can test the API using curl:

```bash
# Get all users
curl http://localhost:3000/api/users

# Get prescriptions for user 1
curl http://localhost:3000/api/users/1/prescriptions-with-history

# Record a dose
curl -X POST http://localhost:3000/api/doses \
  -H "Content-Type: application/json" \
  -d '{"prescription_id": 1, "taken_at": "2024-03-05T10:30:00Z"}'
```

## Troubleshooting

### Connection Issues

If you get connection errors:
1. Verify PostgreSQL is running: `pg_isready`
2. Check your credentials in `.env`
3. Ensure the database exists: `psql -U postgres -l`

### Permission Issues

If you get permission errors:
```bash
# Grant permissions to your user
psql -U postgres -d pill_tracker
GRANT ALL PRIVILEGES ON ALL TABLES IN SCHEMA public TO your_username;
GRANT ALL PRIVILEGES ON ALL SEQUENCES IN SCHEMA public TO your_username;