const express = require('express');
const cors = require('cors');
const db = require('./db');
require('dotenv').config();

const app = express();
const PORT = process.env.PORT || 3000;

// Middleware
app.use(cors());
app.use(express.json());

// Health check endpoint
app.get('/api/health', (req, res) => {
    res.json({ status: 'ok', message: 'Pill Tracker API is running' });
});

// Get all users
app.get('/api/users', async (req, res) => {
    try {
        const result = await db.query('SELECT * FROM users ORDER BY id');
        res.json(result.rows);
    } catch (err) {
        console.error('Error fetching users:', err);
        res.status(500).json({ error: 'Failed to fetch users' });
    }
});

// Get a specific user
app.get('/api/users/:id', async (req, res) => {
    try {
        const { id } = req.params;
        const result = await db.query('SELECT * FROM users WHERE id = $1', [id]);
        
        if (result.rows.length === 0) {
            return res.status(404).json({ error: 'User not found' });
        }
        
        res.json(result.rows[0]);
    } catch (err) {
        console.error('Error fetching user:', err);
        res.status(500).json({ error: 'Failed to fetch user' });
    }
});

// Get all prescriptions for a user
app.get('/api/users/:userId/prescriptions', async (req, res) => {
    try {
        const { userId } = req.params;
        
        const result = await db.query(
            'SELECT * FROM prescriptions WHERE user_id = $1 ORDER BY id',
            [userId]
        );
        
        res.json(result.rows);
    } catch (err) {
        console.error('Error fetching prescriptions:', err);
        res.status(500).json({ error: 'Failed to fetch prescriptions' });
    }
});

// Get prescription with last dose information
app.get('/api/prescriptions/:id', async (req, res) => {
    try {
        const { id } = req.params;
        
        const prescriptionResult = await db.query(
            'SELECT * FROM prescriptions WHERE id = $1',
            [id]
        );
        
        if (prescriptionResult.rows.length === 0) {
            return res.status(404).json({ error: 'Prescription not found' });
        }
        
        const prescription = prescriptionResult.rows[0];
        
        // Get the last dose taken
        const lastDoseResult = await db.query(
            'SELECT * FROM dose_history WHERE prescription_id = $1 ORDER BY taken_at DESC LIMIT 1',
            [id]
        );
        
        prescription.last_taken = lastDoseResult.rows.length > 0 
            ? lastDoseResult.rows[0].taken_at 
            : null;
        
        res.json(prescription);
    } catch (err) {
        console.error('Error fetching prescription:', err);
        res.status(500).json({ error: 'Failed to fetch prescription' });
    }
});

// Get all prescriptions with last dose for a user
app.get('/api/users/:userId/prescriptions-with-history', async (req, res) => {
    try {
        const { userId } = req.params;
        
        const query = `
            SELECT 
                p.*,
                dh.taken_at as last_taken
            FROM prescriptions p
            LEFT JOIN LATERAL (
                SELECT taken_at
                FROM dose_history
                WHERE prescription_id = p.id
                ORDER BY taken_at DESC
                LIMIT 1
            ) dh ON true
            WHERE p.user_id = $1
            ORDER BY p.id
        `;
        
        const result = await db.query(query, [userId]);
        res.json(result.rows);
    } catch (err) {
        console.error('Error fetching prescriptions with history:', err);
        res.status(500).json({ error: 'Failed to fetch prescriptions with history' });
    }
});

// Record a dose taken
app.post('/api/doses', async (req, res) => {
    try {
        const { prescription_id, taken_at } = req.body;
        
        if (!prescription_id || !taken_at) {
            return res.status(400).json({ error: 'prescription_id and taken_at are required' });
        }
        
        // Verify prescription exists
        const prescriptionCheck = await db.query(
            'SELECT id FROM prescriptions WHERE id = $1',
            [prescription_id]
        );
        
        if (prescriptionCheck.rows.length === 0) {
            return res.status(404).json({ error: 'Prescription not found' });
        }
        
        const result = await db.query(
            'INSERT INTO dose_history (prescription_id, taken_at) VALUES ($1, $2) RETURNING *',
            [prescription_id, taken_at]
        );
        
        res.status(201).json(result.rows[0]);
    } catch (err) {
        console.error('Error recording dose:', err);
        res.status(500).json({ error: 'Failed to record dose' });
    }
});

// Get dose history for a prescription
app.get('/api/prescriptions/:id/history', async (req, res) => {
    try {
        const { id } = req.params;
        const { limit = 10 } = req.query;
        
        const result = await db.query(
            'SELECT * FROM dose_history WHERE prescription_id = $1 ORDER BY taken_at DESC LIMIT $2',
            [id, limit]
        );
        
        res.json(result.rows);
    } catch (err) {
        console.error('Error fetching dose history:', err);
        res.status(500).json({ error: 'Failed to fetch dose history' });
    }
});

// Get all dose history for a user
app.get('/api/users/:userId/dose-history', async (req, res) => {
    try {
        const { userId } = req.params;
        const { limit = 50 } = req.query;
        
        const query = `
            SELECT 
                dh.*,
                p.name as prescription_name
            FROM dose_history dh
            JOIN prescriptions p ON dh.prescription_id = p.id
            WHERE p.user_id = $1
            ORDER BY dh.taken_at DESC
            LIMIT $2
        `;
        
        const result = await db.query(query, [userId, limit]);
        res.json(result.rows);
    } catch (err) {
        console.error('Error fetching user dose history:', err);
        res.status(500).json({ error: 'Failed to fetch dose history' });
    }
});

// Error handling middleware
app.use((err, req, res, next) => {
    console.error(err.stack);
    res.status(500).json({ error: 'Something went wrong!' });
});

// Start server
app.listen(PORT, () => {
    console.log(`Pill Tracker API server running on port ${PORT}`);
    console.log(`Health check: http://localhost:${PORT}/api/health`);
});

// Made with Bob
