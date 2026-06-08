# Simple Pharmacy Management System - Security Vulnerabilities Exercise

A pharmacy management system with a Java REST API backend running on Liberty. This snapshot contains security vulnerabilities that need to be identified and fixed.

## 🎯 Exercise Objective

This project has security issues that are preventing it from running correctly. Your task is to:
1. Analyze the codebase to identify security vulnerabilities
2. Rank the vulnerabilities by severity and impact
3. Create a remediation plan
4. Implement fixes while ensuring the application continues to work

## 🚀 Quick Start

### Prerequisites

- Java 21 or higher
- Maven 3.6 or higher

### Build and Run

```bash
# Build and run
mvn clean liberty:run

# Stop the server (in another terminal)
mvn liberty:stop
```

**Access the application:**
- **REST API**: http://localhost:9081/simple-pharmacy.war/api/

## 📁 Project Structure

```
simple-pharmacy/
├── src/main/java/com/pharmacy/
│   ├── api/                    # REST API endpoints (JAX-RS)
│   │   ├── DashboardResource.java
│   │   ├── MedicineResource.java
│   │   ├── OrderResource.java
│   │   ├── PrescriptionResource.java
│   │   ├── PharmacyApplication.java
│   │   └── CorsFilter.java
│   ├── model/                  # Domain models
│   └── repository/             # Data repositories
├── src/main/liberty/config/
│   └── server.xml              # Liberty server configuration
├── src/main/webapp/
│   └── WEB-INF/web.xml
└── pom.xml                     # Maven build configuration
```

## 🌐 Application Features

### Dashboard
- View pending prescriptions and orders
- See total counts and statistics

### Prescriptions
- Create new prescriptions
- Validate prescriptions
- View prescription history

### Orders
- Create orders from validated prescriptions
- Process payments
- Track order status

### Medicines
- View medicine inventory
- Search medicines by name
- Check stock levels

## 🔌 REST API Endpoints

Base URL: `http://localhost:9081/simple-pharmacy.war/api`

### Dashboard
- `GET /dashboard` - Get dashboard statistics

### Medicines
- `GET /medicines` - Get all medicines
- `GET /medicines/{id}` - Get medicine by ID
- `GET /medicines/search?name={query}` - Search medicines

### Prescriptions
- `GET /prescriptions` - Get all prescriptions
- `GET /prescriptions/{id}` - Get prescription by ID
- `POST /prescriptions` - Create new prescription
- `PUT /prescriptions/{id}/validate` - Validate prescription

### Orders
- `GET /orders` - Get all orders
- `GET /orders/{id}` - Get order by ID
- `POST /orders/from-prescription` - Create order from prescription
- `PUT /orders/{id}/payment` - Process payment
- `PUT /orders/{id}/collect` - Mark order as collected

## 🛠️ Maven Commands

### Build
```bash
# Full build
mvn clean package

# Build without tests
mvn clean package -DskipTests
```

### Run
```bash
# Start Liberty server
mvn liberty:run

# Stop Liberty server (in another terminal)
mvn liberty:stop
```

## 📝 Configuration

### Backend Configuration
- **Server Config**: `src/main/liberty/config/server.xml`
- **HTTP Port**: 9081
- **HTTPS Port**: 9443

## 🔄 Technology Stack

- **Java**: 21
- **Jakarta EE**: 10
- **JAX-RS**: 3.1
- **JSON-B**: 3.0
- **Servlet**: 6.0
- **Open Liberty**: Latest

## 🐛 Troubleshooting

### Port 9081 Already in Use
```bash
mvn liberty:stop
```

### Liberty Server Won't Start
Check logs in: `target/liberty/wlp/usr/servers/defaultServer/logs/`

## 📚 Additional Documentation

- [Quick Reference](QUICK-REFERENCE.md) - Command reference
- [Automation Scripts](README-AUTOMATION.md) - Script documentation