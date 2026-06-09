#!/bin/bash

# Pill Tracker Deployment Script
# This script deploys the Pill Tracker application to Kubernetes using Ansible

set -e  # Exit on error

# Color codes for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
CYAN='\033[0;36m'
NC='\033[0m' # No Color
BOLD='\033[1m'

# Configuration
NAMESPACE="pill-tracker"
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_DIR="$(dirname "$SCRIPT_DIR")"
PLAYBOOK="$PROJECT_DIR/playbooks/deploy-all.yml"

# Function to print colored messages
print_success() {
    echo -e "${GREEN}✓${NC} $1"
}

print_error() {
    echo -e "${RED}✗${NC} $1"
}

print_warning() {
    echo -e "${YELLOW}⚠${NC} $1"
}

print_info() {
    echo -e "${BLUE}ℹ${NC} $1"
}

print_header() {
    echo -e "\n${CYAN}${BOLD}========================================${NC}"
    echo -e "${CYAN}${BOLD}$1${NC}"
    echo -e "${CYAN}${BOLD}========================================${NC}\n"
}

# Function to check if a command exists
command_exists() {
    command -v "$1" >/dev/null 2>&1
}

# Function to check prerequisites
check_prerequisites() {
    print_header "Checking Prerequisites"
    
    local all_good=true
    
    # Check kubectl
    if command_exists kubectl; then
        print_success "kubectl is installed ($(kubectl version --client --short 2>/dev/null | head -n1))"
    else
        print_error "kubectl is not installed"
        print_info "Install kubectl: https://kubernetes.io/docs/tasks/tools/"
        all_good=false
    fi
    
    # Check ansible-playbook
    if command_exists ansible-playbook; then
        print_success "ansible-playbook is installed ($(ansible-playbook --version | head -n1))"
    else
        print_error "ansible-playbook is not installed"
        print_info "Install Ansible: https://docs.ansible.com/ansible/latest/installation_guide/intro_installation.html"
        all_good=false
    fi
    
    # Check docker
    if command_exists docker; then
        print_success "docker is installed ($(docker --version))"
    else
        print_error "docker is not installed"
        print_info "Install Docker Desktop or Rancher Desktop"
        all_good=false
    fi
    
    if [ "$all_good" = false ]; then
        print_error "Prerequisites check failed. Please install missing tools."
        exit 1
    fi
    
    print_success "All prerequisites are met!"
}

# Function to verify Kubernetes cluster connection
verify_cluster_connection() {
    print_header "Verifying Kubernetes Cluster Connection"
    
    if ! kubectl cluster-info >/dev/null 2>&1; then
        print_error "Cannot connect to Kubernetes cluster"
        print_info "Make sure Rancher Desktop is running and Kubernetes is enabled"
        print_info "Check your kubeconfig: kubectl config current-context"
        exit 1
    fi
    
    local context=$(kubectl config current-context)
    local cluster=$(kubectl config view -o jsonpath="{.contexts[?(@.name=='$context')].context.cluster}")
    
    print_success "Connected to Kubernetes cluster"
    print_info "Context: ${BOLD}$context${NC}"
    print_info "Cluster: ${BOLD}$cluster${NC}"
    
    # Get cluster version
    local k8s_version=$(kubectl version --short 2>/dev/null | grep "Server Version" | cut -d: -f2 | xargs)
    print_info "Kubernetes version: ${BOLD}$k8s_version${NC}"
}

# Function to check if namespace exists
check_namespace() {
    print_header "Checking Namespace"
    
    if kubectl get namespace "$NAMESPACE" >/dev/null 2>&1; then
        print_warning "Namespace '$NAMESPACE' already exists"
        
        # Count existing resources
        local pod_count=$(kubectl get pods -n "$NAMESPACE" --no-headers 2>/dev/null | wc -l | xargs)
        local svc_count=$(kubectl get svc -n "$NAMESPACE" --no-headers 2>/dev/null | wc -l | xargs)
        local deploy_count=$(kubectl get deployments -n "$NAMESPACE" --no-headers 2>/dev/null | wc -l | xargs)
        
        if [ "$pod_count" -gt 0 ] || [ "$svc_count" -gt 0 ] || [ "$deploy_count" -gt 0 ]; then
            print_info "Existing resources found:"
            print_info "  - Pods: $pod_count"
            print_info "  - Services: $svc_count"
            print_info "  - Deployments: $deploy_count"
            
            echo -e "\n${YELLOW}Do you want to redeploy? This will update existing resources.${NC}"
            read -p "Continue? (yes/no): " -r
            echo
            
            if [[ ! $REPLY =~ ^[Yy]es$ ]]; then
                print_info "Deployment cancelled by user"
                exit 0
            fi
            
            print_info "Proceeding with redeployment..."
        fi
    else
        print_info "Namespace '$NAMESPACE' does not exist yet (will be created)"
    fi
}

# Function to run the Ansible playbook
run_deployment() {
    print_header "Starting Deployment"
    
    print_info "Running Ansible playbook: $PLAYBOOK"
    print_info "This may take several minutes..."
    echo
    
    # Run the playbook
    if ansible-playbook "$PLAYBOOK"; then
        return 0
    else
        return 1
    fi
}

# Function to display success message
show_success_message() {
    print_header "🎉 DEPLOYMENT SUCCESSFUL! 🎉"
    
    echo -e "${GREEN}${BOLD}Your Pill Tracker application is now running!${NC}\n"
    
    echo -e "${CYAN}${BOLD}Access URLs:${NC}"
    echo -e "  ${GREEN}🌐 Web Application:${NC}    http://localhost:30080/"
    echo -e "  ${GREEN}🔌 Backend API:${NC}        http://localhost:30300/api/"
    echo -e "  ${GREEN}📊 API Health Check:${NC}   http://localhost:30300/api/health"
    echo
    
    echo -e "${CYAN}${BOLD}Quick Commands:${NC}"
    echo -e "  ${BLUE}View all resources:${NC}    kubectl get all -n $NAMESPACE"
    echo -e "  ${BLUE}View pods:${NC}             kubectl get pods -n $NAMESPACE"
    echo -e "  ${BLUE}View logs (backend):${NC}   kubectl logs -n $NAMESPACE -l app=backend -f"
    echo -e "  ${BLUE}View logs (frontend):${NC}  kubectl logs -n $NAMESPACE -l app=frontend -f"
    echo -e "  ${BLUE}View logs (postgres):${NC}  kubectl logs -n $NAMESPACE -l app=postgres -f"
    echo
    
    echo -e "${CYAN}${BOLD}Test the Application:${NC}"
    echo -e "  1. Open ${GREEN}http://localhost:30080/${NC} in your browser"
    echo -e "  2. Select a user from the dropdown"
    echo -e "  3. View their prescriptions and medication schedule"
    echo -e "  4. Use 'Advance Time' to simulate time passing"
    echo -e "  5. Mark medications as taken"
    echo
    
    echo -e "${CYAN}${BOLD}Sample Users:${NC}"
    echo -e "  • Sarah Johnson   - 2 prescriptions (blood pressure, diabetes)"
    echo -e "  • Michael Chen    - 3 prescriptions (cholesterol, acid reflux, aspirin)"
    echo -e "  • Emily Rodriguez - 3 prescriptions (thyroid, vitamin D, antidepressant)"
    echo
    
    print_success "Deployment complete! Enjoy your Pill Tracker application!"
}

# Function to handle errors
handle_error() {
    print_header "❌ DEPLOYMENT FAILED"
    
    print_error "An error occurred during deployment"
    echo
    
    echo -e "${YELLOW}${BOLD}Troubleshooting Tips:${NC}"
    echo -e "  1. Check if Rancher Desktop is running"
    echo -e "  2. Verify Kubernetes is enabled in Rancher Desktop"
    echo -e "  3. Check cluster connection: ${BLUE}kubectl cluster-info${NC}"
    echo -e "  4. View recent logs: ${BLUE}kubectl get events -n $NAMESPACE --sort-by='.lastTimestamp'${NC}"
    echo -e "  5. Check pod status: ${BLUE}kubectl get pods -n $NAMESPACE${NC}"
    echo
    
    echo -e "${YELLOW}${BOLD}Common Issues:${NC}"
    echo -e "  • Image pull errors: Make sure nerdctl can access images"
    echo -e "  • Resource limits: Check if your cluster has enough resources"
    echo -e "  • Port conflicts: Ensure ports 30080 and 30300 are available"
    echo
    
    echo -e "${CYAN}${BOLD}Cleanup (if needed):${NC}"
    echo -e "  ${BLUE}kubectl delete namespace $NAMESPACE${NC}"
    echo
    
    print_info "Check the Ansible output above for specific error details"
    exit 1
}

# Main execution
main() {
    # Print banner
    echo -e "${CYAN}${BOLD}"
    echo "╔═══════════════════════════════════════════╗"
    echo "║                                           ║"
    echo "║     💊 PILL TRACKER DEPLOYMENT 💊        ║"
    echo "║                                           ║"
    echo "║   Kubernetes Deployment via Ansible       ║"
    echo "║                                           ║"
    echo "╚═══════════════════════════════════════════╝"
    echo -e "${NC}\n"
    
    # Run checks and deployment
    check_prerequisites
    verify_cluster_connection
    check_namespace
    
    # Run deployment with error handling
    if run_deployment; then
        show_success_message
    else
        handle_error
    fi
}

# Trap errors
trap 'handle_error' ERR

# Run main function
main "$@"

# Made with Bob
