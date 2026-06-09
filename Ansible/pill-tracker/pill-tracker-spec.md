# Pill Tracker Application Specification

## Overview
A single-page application (SPA) for tracking medication schedules and pill intake across multiple users.

## User Management

### Sample Users (Dropdown Selection)
The app includes 3 pre-configured users:
1. **John Smith** - Senior with multiple daily medications
2. **Sarah Johnson** - Adult with morning and evening pills
3. **Mike Davis** - Young adult with single daily medication

Each user has their own set of prescriptions and medication history.

## Core Features

### Medication Display
For the selected user, show:
- **List of medications** with name and dosage
- **Schedule information** - when each pill is due (e.g., "8:00 AM", "2:00 PM", "8:00 PM")
- **Next dose time** - countdown or time until next pill
- **Medication descriptions** - brief info about each drug (purpose, common side effects)

### Time Management
- **Current time display** - show simulated current time prominently
- **Advance time button** - jump forward 8 hours to test different scenarios
- **Due status indicators** - highlight pills that are currently due
- **Late status indicators** - highlight pills that are past due

### Pill Taking
- **Mark as taken button** - record when a pill is consumed
- **Dose history** - show recent doses taken with timestamps
- **Visual feedback** - clear indication when pill is marked as taken

### Refill Reminders
- **Low supply warning** - alert when 1 week (7 days) of pills remain
- **Refill actions** - options to:
  - Reorder medication
  - Set up automatic refill
- **Supply countdown** - show days of medication remaining

### Safety Features
- **Drug interaction warnings** - display alerts for known medication conflicts
- **Interaction details** - brief explanation of potential issues
- **Visual alerts** - use color coding (yellow for warnings, red for serious interactions)

## Technical Requirements

### Data Structure
Each prescription should include:
- Medication name
- Dosage amount
- Frequency (times per day)
- Time schedule
- Pills remaining 
- Description
- Interaction warnings (if any)

### User Interface
- Clean, simple layout
- Mobile-friendly design
- Clear visual hierarchy
- Accessible color scheme
- Intuitive navigation

## Sample Data

### John Smith's Prescriptions
- Lisinopril 10mg - once daily (morning) - Blood pressure medication
- Metformin 500mg - twice daily (morning, evening) - Diabetes management
- Atorvastatin 20mg - once daily (evening) - Cholesterol control

### Sarah Johnson's Prescriptions
- Levothyroxine 50mcg - once daily (morning) - Thyroid hormone
- Vitamin D 2000IU - once daily (morning) - Supplement

### Mike Davis's Prescriptions
- Sertraline 50mg - once daily (morning) - Antidepressant

## Notes
- Keep the interface simple and demo-friendly
- Focus on core functionality over edge cases
- Use realistic but simplified medication data
- Prioritize clarity and ease of use
