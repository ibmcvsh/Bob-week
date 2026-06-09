# 🤖 AI-Assisted Ansible Lab (10 Minutes)
## Deploy Pill Tracker by Prompting IBM Bob
### Demo [Video](https://ibm.ent.box.com/folder/372762222254 'Step by step guide')
---

## 🎯 What You'll Do

**Prompt an AI assistant to:**
1. Create Ansible playbooks
2. Build Docker containers
3. Deploy to Kubernetes
4. Verify everything works

**No manual coding required!**

---

## ✅ Prerequisites (1 minute)

**Verify you have:**

```bash
kubectl cluster-info  # Rancher Desktop running
ansible --version     # 2.9+
docker --version      # Docker for building images
ansible-galaxy collection install kubernetes.core
pip install kubernetes  # Python Kubernetes library
```

---

## 🚀 The Lab: 4 Simple Prompts

### **Step 1: Test Connection (2 minutes)**

**Prompt (Ask Mode):**
```
I'm working on a healthcare application called Pill Tracker that exists already in my directory and has:
- A PostgreSQL database with schema and seed data
- A Node.js backend API (Express)
- A static frontend (HTML/CSS/JS)

I need to deploy this to my local Kubernetes cluster (Rancher Desktop) using Ansible.

Can you help me understand what files I'll need and create a project structure?
```

**Then (Code Mode):**
```
Great! Let's start. First, verify my Kubernetes connection is working by creating 
a simple test playbook at playbooks/test-connection.yml that:
1. Connects to localhost
2. Gets cluster info
3. Creates a test namespace
4. Deletes the test namespace
5. Reports success
```

**Run it:**
```bash
cd ansible
ansible-playbook playbooks/test-connection.yml
```

---

### **Step 2: Deploy Database (2 minutes)**

**Prompt:**
```
Now create the main deployment playbook at playbooks/deploy-all.yml.

Start with PostgreSQL deployment:
1. Create a namespace called "pill-tracker"
2. Create a Secret with these PostgreSQL credentials:
   - username: pill_tracker_user
   - password: SecureP@ssw0rd123!
   - database: pill_tracker_db
3. Create a 5Gi PersistentVolumeClaim using local-path storage
4. Read the SQL files from postgres/schema.sql and seed.sql
5. Create a ConfigMap with both SQL files
6. Pre-pull postgres:15-alpine using docker to avoid rate limits
7. Deploy PostgreSQL with:
   - The PVC mounted for data persistence
   - The ConfigMap mounted to auto-initialize the database
   - Environment variables from the Secret
   - Health checks
8. Create a ClusterIP Service
9. Wait for the pod to be ready

Use proper Ansible syntax with kubernetes.core.k8s module.
```

**Run it:**
```bash
ansible-playbook playbooks/deploy-all.yml
```

---

### **Step 3: Deploy Backend (2 minutes)**

**Prompt:**
```
Add to the playbook to deploy the Node.js backend:

1. Create a Dockerfile at postgres/Dockerfile that:
   - Uses node:18-alpine
   - Installs dependencies from package.json
   - Copies server.js and db.js
   - Exposes port 3000
   - Runs the server

2. Build the Docker image as pill-tracker-backend:1.0.0 using docker build

3. Deploy the backend with:
   - Environment variables to connect to PostgreSQL
   - Health checks on /api/health endpoint
   - imagePullPolicy: IfNotPresent

4. Create a NodePort Service on port 30300

5. Wait for the backend pod to be ready

Add these tasks to the existing playbook after the PostgreSQL deployment.
```

**Run it:**
```bash
ansible-playbook playbooks/deploy-all.yml
```

**Test it:**
```bash
curl http://localhost:30300/api/health
curl http://localhost:30300/api/users
```

---

### **Step 4: Deploy Frontend (2 minutes)**

**Prompt:**
```
Add to the playbook to deploy the frontend:

1. Update app.js to change API_BASE_URL from
   'http://localhost:3000/api' to '/api'

2. Create nginx.conf that:
   - Serves static files from /usr/share/nginx/html
   - Proxies /api/* requests to http://backend.pill-tracker.svc.cluster.local:3000/api/

3. Create Dockerfile.frontend that:
   - Uses nginx:alpine
   - Copies the nginx.conf
   - Copies index.html, app.js, and styles.css
   - Exposes port 80

4. Build the Docker image as pill-tracker-frontend:1.0.0 using docker build

5. Deploy the frontend with imagePullPolicy: IfNotPresent

6. Create a NodePort Service on port 30080

7. Wait for all 3 pods (postgres, backend, frontend) to be ready

8. Display a success message with access URLs

Add these tasks to complete the playbook.
```

**Run it:**
```bash
ansible-playbook playbooks/deploy-all.yml
```

**Access it:**
```bash
open http://localhost:30080
```

---

### **Step 5: Create Deployment Scripts (2 minutes)**

**Prompt:**
```
Create a start.sh script at scripts/start.sh that:
1. Checks prerequisites (kubectl, ansible-playbook)
2. Verifies Kubernetes cluster connection
3. Checks if namespace already exists and asks for confirmation to redeploy
4. Runs the ansible-playbook playbooks/deploy-all.yml
5. Shows a success message with access URLs on completion
6. Handles errors gracefully with helpful messages
7. Uses colored output (green for success, red for errors, yellow for warnings)
8. Is executable

Make it user-friendly and safe.
```

**Then:**
```
Create a cleanup script at scripts/cleanup.sh that:
1. Asks for confirmation before deleting anything
2. Shows what will be deleted (namespace, resources, images)
3. Requires typing 'DELETE' to confirm (double confirmation)
4. Deletes the pill-tracker namespace
5. Removes the Docker images (pill-tracker-backend and pill-tracker-frontend)
6. Verifies everything is removed
7. Shows a completion message with redeploy instructions
8. Is safe with multiple confirmation prompts
9. Is executable
```

**Use them:**
```bash
./scripts/start.sh    # Deploy the application
./scripts/cleanup.sh  # Clean up when done
```

---

## 🎉 Success Checklist

- [ ] All 3 pods Running
- [ ] Frontend at http://localhost:30080
- [ ] Backend API at http://localhost:30300/api/health
- [ ] Can select users and view prescriptions
- [ ] Can mark medications as taken
- [ ] Verification script passes

---

## 💡 Quick Tips

### **If Something Fails:**
```
The [component] isn't working. Help me debug by showing:
1. How to check pod logs
2. How to verify the configuration
3. Common issues and fixes
```

### **To Customize:**
```
Change [setting] from [old value] to [new value]
```

### **To Learn More:**
```
Explain why we [did something] in the playbook
```

---

## 📊 Time Saved

| Task | Manual | AI-Assisted |
|------|--------|-------------|
| Learn Ansible | 2-4 hours | 0 minutes |
| Write playbooks | 1-2 hours | 5 minutes |
| Create Dockerfiles | 30 minutes | 2 minutes |
| Debug issues | 1-2 hours | 5 minutes |
| **Total** | **5-9 hours** | **10 minutes** |

---

## 🚀 What You Learned

**AI Skills:**
- Effective prompting
- Iterative development
- Code review with AI

**Technical Skills:**
- Ansible automation
- Kubernetes deployment
- Docker containerization
- DevOps workflows

**Healthcare IT:**
- Secure local deployment
- Data persistence
- Application containerization

---

## 🎓 Next Steps

**Apply to Your Projects:**
```
I have a [your app] with [components]. Help me create an Ansible 
playbook to deploy it to Kubernetes like the Pill Tracker example.
```

**Learn More:**
```
Show me how to add [feature] to the deployment
Explain [concept] in the playbook
How would I deploy this to [cloud provider]?
```

---

## 📞 Start Here

**Copy this prompt to begin:**

```
I'm starting the AI-Assisted Ansible Lab for the Pill Tracker application. 
I need to deploy a 3-tier healthcare application (PostgreSQL database, 
Node.js backend, and static frontend) to my local Kubernetes cluster 
using Ansible automation.

The application files are in the "pill-tracker database" directory. 
Can you help me create a deployment playbook that automates everything?

Let's start by verifying my Kubernetes connection is working.
```

---

*Lab Version: 2.1 (Quick)*  
*Duration: 10 minutes*  
*Difficulty: Beginner*  
*Prerequisites: Rancher Desktop, Ansible, AI Assistant*
