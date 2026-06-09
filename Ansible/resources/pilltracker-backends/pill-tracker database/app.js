// API Configuration
const API_BASE_URL = 'http://localhost:3000/api';

// Application state
let users = [];

// Application state
let currentUser = null;
let currentTime = new Date();

// API Helper Functions
async function fetchUsers() {
    try {
        const response = await fetch(`${API_BASE_URL}/users`);
        if (!response.ok) throw new Error('Failed to fetch users');
        return await response.json();
    } catch (error) {
        console.error('Error fetching users:', error);
        alert('Failed to load users. Make sure the API server is running on port 3000.');
        return [];
    }
}

async function fetchUserPrescriptions(userId) {
    try {
        const response = await fetch(`${API_BASE_URL}/users/${userId}/prescriptions-with-history`);
        if (!response.ok) throw new Error('Failed to fetch prescriptions');
        return await response.json();
    } catch (error) {
        console.error('Error fetching prescriptions:', error);
        return [];
    }
}

async function recordDose(prescriptionId, takenAt) {
    try {
        const response = await fetch(`${API_BASE_URL}/doses`, {
            method: 'POST',
            headers: {
                'Content-Type': 'application/json',
            },
            body: JSON.stringify({
                prescription_id: prescriptionId,
                taken_at: takenAt.toISOString()
            })
        });
        
        if (!response.ok) throw new Error('Failed to record dose');
        return await response.json();
    } catch (error) {
        console.error('Error recording dose:', error);
        throw error;
    }
}

// Initialize the application
async function init() {
    users = await fetchUsers();
    populateUserSelect();
    updateTimeDisplay();
    
    // Event listeners
    document.getElementById('userSelect').addEventListener('change', handleUserChange);
    document.getElementById('advanceTimeBtn').addEventListener('click', advanceTime);
}

// Populate user selection dropdown
function populateUserSelect() {
    const select = document.getElementById('userSelect');
    users.forEach(user => {
        const option = document.createElement('option');
        option.value = user.id;
        option.textContent = user.name;
        select.appendChild(option);
    });
}

// Handle user selection change
async function handleUserChange(event) {
    const userId = parseInt(event.target.value);
    if (userId) {
        currentUser = users.find(u => u.id === userId);
        if (currentUser) {
            // Fetch prescriptions from API
            currentUser.prescriptions = await fetchUserPrescriptions(userId);
            showUserInfo();
        }
    } else {
        currentUser = null;
        document.getElementById('userInfo').classList.add('hidden');
    }
}

// Show user information and prescriptions
async function showUserInfo() {
    if (!currentUser) return;
    
    document.getElementById('userInfo').classList.remove('hidden');
    document.getElementById('userName').textContent = currentUser.name;
    
    checkNotifications();
    displayPrescriptions();
}

// Update time display
function updateTimeDisplay() {
    const timeString = currentTime.toLocaleString('en-US', {
        weekday: 'short',
        year: 'numeric',
        month: 'short',
        day: 'numeric',
        hour: '2-digit',
        minute: '2-digit',
        second: '2-digit'
    });
    document.getElementById('currentTime').textContent = timeString;
}

// Advance time by 8 hours
function advanceTime() {
    currentTime = new Date(currentTime.getTime() + (8 * 60 * 60 * 1000));
    updateTimeDisplay();
    
    if (currentUser) {
        checkNotifications();
        displayPrescriptions();
    }
}

// Check for due medications and show notifications
function checkNotifications() {
    if (!currentUser) return;
    
    const notificationsDiv = document.getElementById('notifications');
    notificationsDiv.innerHTML = '';
    
    const dueMeds = [];
    const overdueMeds = [];
    
    currentUser.prescriptions.forEach(prescription => {
        const status = getPrescriptionStatus(prescription);
        if (status === 'due') {
            dueMeds.push(prescription);
        } else if (status === 'overdue') {
            overdueMeds.push(prescription);
        }
    });
    
    // Show overdue notifications
    if (overdueMeds.length > 0) {
        const notification = document.createElement('div');
        notification.className = 'notification overdue';
        notification.innerHTML = `
            <strong>⚠️ OVERDUE MEDICATION${overdueMeds.length > 1 ? 'S' : ''}!</strong><br>
            ${overdueMeds.map(med => med.name).join(', ')} - Please take as soon as possible!
        `;
        notificationsDiv.appendChild(notification);
    }
    
    // Show due notifications
    if (dueMeds.length > 0) {
        const notification = document.createElement('div');
        notification.className = 'notification due';
        notification.innerHTML = `
            <strong>🔔 Time to take your medication${dueMeds.length > 1 ? 's' : ''}!</strong><br>
            ${dueMeds.map(med => med.name).join(', ')}
        `;
        notificationsDiv.appendChild(notification);
    }
    
    // Show all clear message
    if (dueMeds.length === 0 && overdueMeds.length === 0) {
        const notification = document.createElement('div');
        notification.className = 'notification success';
        notification.innerHTML = `
            <strong>✅ All medications up to date!</strong><br>
            No medications are currently due.
        `;
        notificationsDiv.appendChild(notification);
    }
}

// Get prescription status (ok, due, overdue)
function getPrescriptionStatus(prescription) {
    if (!prescription.last_taken) {
        return 'due'; // Never taken, so it's due
    }
    
    const lastTaken = new Date(prescription.last_taken);
    const timeSinceLastDose = (currentTime - lastTaken) / (1000 * 60 * 60); // in hours
    const nextDoseTime = prescription.frequency_hours;
    
    if (timeSinceLastDose >= nextDoseTime + 2) {
        return 'overdue'; // More than 2 hours past due time
    } else if (timeSinceLastDose >= nextDoseTime) {
        return 'due'; // It's time to take it
    } else {
        return 'ok'; // Not yet time
    }
}

// Display all prescriptions
function displayPrescriptions() {
    if (!currentUser) return;
    
    const listDiv = document.getElementById('prescriptionList');
    listDiv.innerHTML = '';
    
    currentUser.prescriptions.forEach(prescription => {
        const card = createPrescriptionCard(prescription);
        listDiv.appendChild(card);
    });
}

// Create a prescription card element
function createPrescriptionCard(prescription) {
    const status = getPrescriptionStatus(prescription);
    const card = document.createElement('div');
    card.className = `prescription-card ${status === 'due' || status === 'overdue' ? status : ''}`;
    
    const lastTaken = prescription.last_taken ? new Date(prescription.last_taken) : null;
    const nextDoseTime = lastTaken
        ? new Date(lastTaken.getTime() + (prescription.frequency_hours * 60 * 60 * 1000))
        : new Date(currentTime);
    
    const statusBadge = status === 'overdue'
        ? '<span class="status-badge overdue">OVERDUE</span>'
        : status === 'due'
        ? '<span class="status-badge due">DUE NOW</span>'
        : '<span class="status-badge ok">Up to date</span>';
    
    const lastTakenText = lastTaken
        ? `<div class="last-taken">Last taken: ${lastTaken.toLocaleString('en-US', {
            month: 'short',
            day: 'numeric',
            hour: '2-digit',
            minute: '2-digit'
        })}</div>`
        : '<div class="last-taken" style="color: #dc3545;">Never taken</div>';
    
    card.innerHTML = `
        <div class="prescription-header">
            <div class="prescription-name">${prescription.name}</div>
            ${statusBadge}
        </div>
        <div class="prescription-schedule">
            Take every ${prescription.frequency_hours} hours
        </div>
        <div class="prescription-description">
            ${prescription.description}
        </div>
        <div class="prescription-status">
            <div>
                ${lastTakenText}
                <div class="next-dose">Next dose: ${nextDoseTime.toLocaleString('en-US', {
                    month: 'short',
                    day: 'numeric',
                    hour: '2-digit',
                    minute: '2-digit'
                })}</div>
            </div>
            <button class="btn btn-success" onclick="markAsTaken(${prescription.id})"
                    ${status === 'ok' ? 'disabled' : ''}>
                ✓ Mark as Taken
            </button>
        </div>
    `;
    
    return card;
}

// Mark a prescription as taken
async function markAsTaken(prescriptionId) {
    if (!currentUser) return;
    
    try {
        // Record the dose in the database
        await recordDose(prescriptionId, currentTime);
        
        // Refresh prescriptions from API
        currentUser.prescriptions = await fetchUserPrescriptions(currentUser.id);
        
        // Refresh the display
        checkNotifications();
        displayPrescriptions();
    } catch (error) {
        alert('Failed to record dose. Please try again.');
    }
}

// Initialize when DOM is ready
if (document.readyState === 'loading') {
    document.addEventListener('DOMContentLoaded', init);
} else {
    init();
}

// Made with Bob
