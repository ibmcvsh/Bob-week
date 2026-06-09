# 💊 Pill Tracker - Kubernetes Deployment with Ansible

A complete healthcare medication tracking application deployed to Kubernetes using Ansible automation. This project demonstrates modern DevOps practices with a 3-tier architecture: PostgreSQL database, Node.js backend API, and static frontend.

[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://opensource.org/licenses/MIT)
[![Kubernetes](https://img.shields.io/badge/Kubernetes-326CE5?logo=kubernetes&logoColor=white)](https://kubernetes.io/)
[![Ansible](https://img.shields.io/badge/Ansible-EE0000?logo=ansible&logoColor=white)](https://www.ansible.com/)
[![Docker](https://img.shields.io/badge/Docker-2496ED?logo=docker&logoColor=white)](https://www.docker.com/)

## 🎯 Quick Start

```bash
# Clone the repository
git clone <your-repo-url>
cd pill-tracker-kubernetes

# Make scripts executable
chmod +x scripts/*.sh

# Deploy everything
./scripts/start.sh
```

**Access the application:**
- 🌐 Web App: http://localhost:30080/
- 🔌 Backend API: http://localhost:30300/api/
- 📊 Health Check: http://localhost:30300/api/health

## 📋 Table of Contents

- [Features](#features)
- [Architecture](#architecture)
- [Prerequisites](#prerequisites)
- [Installation](#installation)
- [Usage](#usage)
- [Project Structure](#project-structure)
- [Configuration](#configuration)
- [Troubleshooting](#troubleshooting)
- [Cleanup](#cleanup)
- [Contributing](#contributing)
- [License](#license)

## ✨ Features

### Application Features
- 👥 **Multi-user support** - 3 sample users with different prescriptions
- 💊 **Medication tracking** - Track multiple prescriptions per user
- ⏰ **Smart notifications** - Due and overdue medication alerts
- 📊 **Dose history** - Complete medication history tracking
- 🎨 **Modern UI** - Responsive design with smooth animations
- 🔄 **Time simulation** - Demo mode to test medication schedules

### DevOps Features
- 🤖 **Automated deployment** - One-command deployment with Ansible
- 🐳 **Containerized** - Docker images for all components
- ☸️ **Kubernetes-native** - Deployments, Services, StatefulSets
- 💾 **Persistent storage** - Database data survives pod restarts
- 🔒 **Secrets management** - Kubernetes Secrets for credentials
- 🏥 **Health checks** - Liveness and readiness probes
- 📈 **Scalable** - Multiple replicas for high availability
- 🛡️ **Safe deployment** - Multiple confirmation prompts

## 🏗️ Architecture

```
┌─────────────────────────────────────────────────────────┐
│                    Kubernetes Cluster                    │
│  ┌───────────────────────────────────────────────────┐  │
│  │           Namespace: pill-tracker                  │  │
│  │                                                     │  │
│  │  ┌──────────────┐  ┌──────────────┐  ┌──────────┐ │  │
│  │  │   Frontend   │  │   Backend    │  │ Postgres │ │  │
│  │  │   (Nginx)    │  │  (Node.js)   │  │  (DB)    │ │  │
│  │  │              │  │              │  │          │ │  │
│  │  │  2 replicas  │  │  2 replicas  │  │ 1 replica│ │  │
│  │  │  Port: 80    │  │  Port: 3000  │  │ Port:5432│ │  │
│  │  └──────┬───────┘  └──────┬───────┘  └────┬─────┘ │  │
│  │         │                 │                │       │  │
│  │  ┌──────▼───────┐  ┌──────▼───────┐  ┌────▼─────┐ │  │
│  │  │   NodePort   │  │   NodePort   │  │ClusterIP │ │  │
│  │  │   :30080     │  │   :30300     │  │  :5432   │ │  │
│  │  └──────────────┘  └──────────────┘  └──────────┘ │  │
│  └───────────────────────────────────────────────────┘  │
└─────────────────────────────────────────────────────────┘
         │                      │
         │                      │
    ┌────▼──────┐         ┌────▼──────┐
    │  Browser  │         │ API Client│
    │  :30080   │         │  :30300   │
    └───────────┘         └───────────┘
```

### Components

| Component | Type | Replicas | Image | Port | Storage |
|-----------|------|----------|-------|------|---------|
| PostgreSQL | StatefulSet | 1 | postgres:15-alpine | 5432 | 5Gi PVC |
| Backend API | Deployment | 2 | pill-tracker-backend:1.0.0 | 3000 | - |
| Frontend | Deployment | 2 | pill-tracker-frontend:1.0.0 | 80 | - |

## 📦 Prerequisites

### Required Software

1. **Kubernetes Cluster**
   - [Rancher Desktop](https://rancherdesktop.io/) (recommended)
   - Or any local Kubernetes cluster (Docker Desktop, Minikube, Kind)
   - Kubernetes 1.19+

2. **Docker**
   - Docker Desktop or Rancher Desktop
   - Used for building container images

3. **Ansible**
   ```bash
   # Install Ansible
   pip install ansible
   
   # Install required collections
   ansible-galaxy collection install kubernetes.core
   ```

4. **kubectl**
   ```bash
   # Verify kubectl is installed
   kubectl version --client
   ```

5. **Python Kubernetes Library**
   ```bash
   pip install kubernetes
   ```

### Verify Prerequisites

```bash
# Check Kubernetes cluster
kubectl cluster-info

# Check Ansible
ansible --version

# Check Docker
docker --version

# Check Python Kubernetes library
python -c "import kubernetes; print('OK')"
```

## 🚀 Installation

### 1. Clone the Repository

```bash
git clone <your-repo-url>
cd pill-tracker-kubernetes
```

### 2. Make Scripts Executable

```bash
chmod +x scripts/*.sh
```

### 3. Deploy the Application

```bash
./scripts/start.sh
```

The script will:
1. ✅ Check all prerequisites
2. ✅ Verify Kubernetes cluster connection
3. ✅ Build Docker images
4. ✅ Deploy PostgreSQL with persistent storage
5. ✅ Deploy backend API (2 replicas)
6. ✅ Deploy frontend (2 replicas)
7. ✅ Initialize database with schema and seed data
8. ✅ Verify all components are running
9. ✅ Display access URLs

**Deployment time:** ~3-5 minutes

## 📖 Usage

### Access the Application

Once deployed, open your browser to:

**http://localhost:30080/**

### Using the Application

1. **Select a User** - Choose from the dropdown:
   - Sarah Johnson (2 prescriptions)
   - Michael Chen (3 prescriptions)
   - Emily Rodriguez (3 prescriptions)

2. **View Prescriptions** - See all medications with:
   - Medication name and dosage
   - Description of what it treats
   - Frequency (every X hours)
   - Last taken time
   - Next dose time
   - Status (Up to date, DUE NOW, OVERDUE)

3. **Mark as Taken** - Click the button to record taking a medication

4. **Advance Time** - Use the "Advance Time by 8 Hours" button to simulate time passing and see how notifications work

### API Endpoints

Direct API access at http://localhost:30300/api/:

```bash
# Health check
curl http://localhost:30300/api/health

# Get all users
curl http://localhost:30300/api/users

# Get user's prescriptions with history
curl http://localhost:30300/api/users/1/prescriptions-with-history

# Record a dose
curl -X POST http://localhost:30300/api/doses \
  -H "Content-Type: application/json" \
  -d '{
    "prescription_id": 1,
    "taken_at": "2024-01-01T12:00:00Z"
  }'
```

### Management Commands

```bash
# View all resources
kubectl get all -n pill-tracker

# View logs
kubectl logs -n pill-tracker -l app=backend -f
kubectl logs -n pill-tracker -l app=frontend -f
kubectl logs -n pill-tracker -l app=postgres -f

# Scale deployments
kubectl scale deployment backend -n pill-tracker --replicas=3
kubectl scale deployment frontend -n pill-tracker --replicas=3

# Port forward (alternative access)
kubectl port-forward -n pill-tracker svc/frontend 8080:80
kubectl port-forward -n pill-tracker svc/backend 3000:3000
```

## 📁 Project Structure

```
pill-tracker-kubernetes/
├── README.md                      # This file
├── DEPLOYMENT.md                  # Detailed deployment guide
├── AI-ASSISTED-LAB-QUICK.md      # AI-assisted lab guide
├── ansible.cfg                    # Ansible configuration
├── inventory/
│   └── hosts.yml                  # Ansible inventory
├── playbooks/
│   ├── test-connection.yml        # Connection test playbook
│   └── deploy-all.yml             # Main deployment playbook
├── scripts/
│   ├── start.sh                   # Deployment script
│   ├── stop.sh                    # Quick stop script
│   └── cleanup.sh                 # Complete cleanup script
├── postgres/
│   ├── Dockerfile                 # Backend container image
│   ├── server.js                  # Express API server
│   ├── db.js                      # Database connection
│   ├── schema.sql                 # Database schema
│   ├── seed.sql                   # Sample data
│   └── package.json               # Node.js dependencies
├── Dockerfile.frontend            # Frontend container image
├── nginx.conf                     # Nginx configuration
├── index.html                     # Frontend HTML
├── app.js                         # Frontend JavaScript
└── styles.css                     # Frontend styles
```

## ⚙️ Configuration

### Environment Variables

Database credentials are stored in Kubernetes Secrets. To change them, edit `playbooks/deploy-all.yml`:

```yaml
vars:
  postgres_user: pill_tracker_user
  postgres_password: SecureP@ssw0rd123!
  postgres_db: pill_tracker_db
```

### Resource Limits

Adjust resource requests/limits in `playbooks/deploy-all.yml`:

```yaml
resources:
  requests:
    memory: "128Mi"
    cpu: "100m"
  limits:
    memory: "256Mi"
    cpu: "200m"
```

### Storage Size

Change PersistentVolumeClaim size:

```yaml
pvc_size: 5Gi  # Change to desired size
```

### NodePort Ports

Change external access ports (must be in range 30000-32767):

```yaml
# Frontend
nodePort: 30080

# Backend
nodePort: 30300
```

## 🔧 Troubleshooting

### Common Issues

#### 1. Pods Not Starting

```bash
# Check pod status
kubectl get pods -n pill-tracker

# Describe pod for details
kubectl describe pod <pod-name> -n pill-tracker

# Check events
kubectl get events -n pill-tracker --sort-by='.lastTimestamp'
```

#### 2. Image Build Errors

```bash
# Verify Docker is running
docker ps

# Check Docker images
docker images | grep pill-tracker

# Rebuild images manually
cd postgres && docker build -t pill-tracker-backend:1.0.0 .
cd .. && docker build -t pill-tracker-frontend:1.0.0 -f Dockerfile.frontend .
```

#### 3. Database Connection Issues

```bash
# Check PostgreSQL logs
kubectl logs -n pill-tracker postgres-0

# Test database connection
kubectl exec -it -n pill-tracker postgres-0 -- psql -U pill_tracker_user -d pill_tracker_db

# Verify backend environment variables
kubectl exec -it -n pill-tracker deployment/backend -- env | grep DB_
```

#### 4. Service Not Accessible

```bash
# Check services
kubectl get svc -n pill-tracker

# Test from within cluster
kubectl run -it --rm debug --image=alpine --restart=Never -n pill-tracker -- sh
# Then: wget -O- http://backend:3000/api/health
```

#### 5. Port Already in Use

```bash
# Check what's using the port
lsof -i :30080
lsof -i :30300

# Kill the process or change NodePort in playbook
```

### Reset Everything

If you need to start fresh:

```bash
# Complete cleanup
./scripts/cleanup.sh

# Redeploy
./scripts/start.sh
```

### Get Help

```bash
# Check Ansible playbook syntax
ansible-playbook playbooks/deploy-all.yml --syntax-check

# Dry run (check mode)
ansible-playbook playbooks/deploy-all.yml --check

# Verbose output
ansible-playbook playbooks/deploy-all.yml -v
```

## 🧹 Cleanup

### Quick Stop (Keep Images)

```bash
./scripts/stop.sh
```

This deletes the namespace but keeps Docker images for faster redeployment.

### Complete Cleanup (Remove Everything)

```bash
./scripts/cleanup.sh
```

This script:
1. Shows what will be deleted
2. Requires "yes" confirmation
3. Requires typing "DELETE" for final confirmation
4. Deletes namespace and all resources
5. Removes Docker images
6. Verifies cleanup completed

**Warning:** This permanently deletes all data including the database!

## 🤝 Contributing

Contributions are welcome! Please feel free to submit a Pull Request.

### Development Setup

```bash
# Fork and clone the repository
git clone <your-fork-url>
cd pill-tracker-kubernetes

# Create a feature branch
git checkout -b feature/your-feature-name

# Make your changes and test
./scripts/start.sh

# Commit and push
git add .
git commit -m "Add your feature"
git push origin feature/your-feature-name
```

## 📄 License

This project is licensed under the MIT License - see the LICENSE file for details.

## 🙏 Acknowledgments

- Built with [Ansible](https://www.ansible.com/)
- Deployed on [Kubernetes](https://kubernetes.io/)
- Containerized with [Docker](https://www.docker.com/)
- Database: [PostgreSQL](https://www.postgresql.org/)
- Backend: [Node.js](https://nodejs.org/) + [Express](https://expressjs.com/)
- Frontend: Vanilla JavaScript + CSS

## 📞 Support

For issues or questions:
1. Check the [Troubleshooting](#troubleshooting) section
2. Review [DEPLOYMENT.md](DEPLOYMENT.md) for detailed information
3. Check existing [GitHub Issues](../../issues)
4. Create a new issue if needed

## 🎓 Learning Resources

- [AI-Assisted Lab Guide](AI-ASSISTED-LAB-QUICK.md) - Learn by prompting AI
- [Deployment Guide](DEPLOYMENT.md) - Comprehensive deployment documentation
- [Ansible Documentation](https://docs.ansible.com/)
- [Kubernetes Documentation](https://kubernetes.io/docs/)

---

**Made with ❤️ and 🤖 AI Assistance**

*Version: 1.0.0*  
*Last Updated: 2024*