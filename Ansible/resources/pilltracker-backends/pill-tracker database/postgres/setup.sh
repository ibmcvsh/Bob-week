#!/bin/bash

# Pill Tracker Database Setup Script

echo "🏥 Pill Tracker Database Setup"
echo "================================"
echo ""

# Check if PostgreSQL is installed
if ! command -v psql &> /dev/null; then
    echo "❌ PostgreSQL is not installed. Please install PostgreSQL first."
    exit 1
fi

echo "✓ PostgreSQL is installed"

# Database configuration
DB_NAME="pill_tracker"
DB_USER="${DB_USER:-postgres}"

echo ""
echo "Creating database: $DB_NAME"
echo ""

# Create database
psql -U "$DB_USER" -c "DROP DATABASE IF EXISTS $DB_NAME;" 2>/dev/null
psql -U "$DB_USER" -c "CREATE DATABASE $DB_NAME;"

if [ $? -eq 0 ]; then
    echo "✓ Database created successfully"
else
    echo "❌ Failed to create database"
    exit 1
fi

echo ""
echo "Initializing schema..."
psql -U "$DB_USER" -d "$DB_NAME" -f schema.sql

if [ $? -eq 0 ]; then
    echo "✓ Schema created successfully"
else
    echo "❌ Failed to create schema"
    exit 1
fi

echo ""
echo "Loading seed data..."
psql -U "$DB_USER" -d "$DB_NAME" -f seed.sql

if [ $? -eq 0 ]; then
    echo "✓ Seed data loaded successfully"
else
    echo "❌ Failed to load seed data"
    exit 1
fi

echo ""
echo "Installing Node.js dependencies..."
npm install

if [ $? -eq 0 ]; then
    echo "✓ Dependencies installed successfully"
else
    echo "❌ Failed to install dependencies"
    exit 1
fi

echo ""
echo "================================"
echo "✅ Setup completed successfully!"
echo ""
echo "To start the API server, run:"
echo "  npm start"
echo ""
echo "Or for development mode with auto-reload:"
echo "  npm run dev"
echo ""

# Made with Bob
