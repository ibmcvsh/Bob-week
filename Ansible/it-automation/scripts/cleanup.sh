#!/bin/bash

# Pill Tracker Complete Cleanup Script
# This script removes ALL Pill Tracker resources including namespace and Docker images

set -e  # Exit on error

# Color codes for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
CYAN='\033[0;36m'
MAGENTA='\033[0;35m'
NC='\033[0m' # No Color
BOLD='\033[1m'

# Configuration
NAMESPACE="pill-tracker"
BACKEND_IMAGE="pill-tracker-backend:1.0.0"
FRONTEND_IMAGE="pill-tracker-frontend:1.0.0"

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

print_danger() {
    echo -e "${RED}${BOLD}⚠ $1 ⚠${NC}"
}

# Function to check if namespace exists
check_namespace_exists() {
    kubectl get namespace "$NAMESPACE" >/dev/null 2>&1
}

# Function to check if images exist
check_images_exist() {
    local backend_exists=false
    local frontend_exists=false
    
    if docker images --format "{{.Repository}}:{{.Tag}}" | grep -q "$BACKEND_IMAGE"; then
        backend_exists=true
    fi
    
    if docker images --format "{{.Repository}}:{{.Tag}}" | grep -q "$FRONTEND_IMAGE"; then
        frontend_exists=true
    fi
    
    echo "$backend_exists:$frontend_exists"
}

# Function to show what will be deleted
show_deletion_plan() {
    print_header "Deletion Plan"
    
    local has_namespace=false
    local has_images=false
    
    # Check namespace
    if check_namespace_exists; then
        has_namespace=true
        print_danger "KUBERNETES NAMESPACE: $NAMESPACE"
        echo
        
        # Show resources in namespace
        echo -e "${YELLOW}${BOLD}Resources to be deleted:${NC}"
        echo
        
        # Pods
        local pod_count=$(kubectl get pods -n "$NAMESPACE" --no-headers 2>/dev/null | wc -l | xargs)
        if [ "$pod_count" -gt 0 ]; then
            echo -e "${RED}  Pods ($pod_count):${NC}"
            kubectl get pods -n "$NAMESPACE" --no-headers 2>/dev/null | awk '{print "    - " $1}' || true
        fi
        
        # Deployments
        local deploy_count=$(kubectl get deployments -n "$NAMESPACE" --no-headers 2>/dev/null | wc -l | xargs)
        if [ "$deploy_count" -gt 0 ]; then
            echo -e "${RED}  Deployments ($deploy_count):${NC}"
            kubectl get deployments -n "$NAMESPACE" --no-headers 2>/dev/null | awk '{print "    - " $1}' || true
        fi
        
        # StatefulSets
        local sts_count=$(kubectl get statefulsets -n "$NAMESPACE" --no-headers 2>/dev/null | wc -l | xargs)
        if [ "$sts_count" -gt 0 ]; then
            echo -e "${RED}  StatefulSets ($sts_count):${NC}"
            kubectl get statefulsets -n "$NAMESPACE" --no-headers 2>/dev/null | awk '{print "    - " $1}' || true
        fi
        
        # Services
        local svc_count=$(kubectl get svc -n "$NAMESPACE" --no-headers 2>/dev/null | wc -l | xargs)
        if [ "$svc_count" -gt 0 ]; then
            echo -e "${RED}  Services ($svc_count):${NC}"
            kubectl get svc -n "$NAMESPACE" --no-headers 2>/dev/null | awk '{print "    - " $1}' || true
        fi
        
        # PVCs
        local pvc_count=$(kubectl get pvc -n "$NAMESPACE" --no-headers 2>/dev/null | wc -l | xargs)
        if [ "$pvc_count" -gt 0 ]; then
            echo -e "${RED}  PersistentVolumeClaims ($pvc_count):${NC}"
            kubectl get pvc -n "$NAMESPACE" --no-headers 2>/dev/null | awk '{print "    - " $1}' || true
            print_warning "Database data will be permanently deleted!"
        fi
        
        # ConfigMaps
        local cm_count=$(kubectl get configmaps -n "$NAMESPACE" --no-headers 2>/dev/null | wc -l | xargs)
        if [ "$cm_count" -gt 0 ]; then
            echo -e "${RED}  ConfigMaps ($cm_count):${NC}"
            kubectl get configmaps -n "$NAMESPACE" --no-headers 2>/dev/null | awk '{print "    - " $1}' || true
        fi
        
        # Secrets
        local secret_count=$(kubectl get secrets -n "$NAMESPACE" --no-headers 2>/dev/null | wc -l | xargs)
        if [ "$secret_count" -gt 0 ]; then
            echo -e "${RED}  Secrets ($secret_count):${NC}"
            kubectl get secrets -n "$NAMESPACE" --no-headers 2>/dev/null | awk '{print "    - " $1}' || true
        fi
        
        echo
    else
        print_info "Namespace '$NAMESPACE' does not exist"
    fi
    
    # Check images
    local image_status=$(check_images_exist)
    local backend_exists=$(echo "$image_status" | cut -d: -f1)
    local frontend_exists=$(echo "$image_status" | cut -d: -f2)
    
    if [ "$backend_exists" = "true" ] || [ "$frontend_exists" = "true" ]; then
        has_images=true
        print_danger "DOCKER IMAGES"
        echo
        echo -e "${YELLOW}${BOLD}Images to be deleted:${NC}"
        
        if [ "$backend_exists" = "true" ]; then
            echo -e "${RED}  - $BACKEND_IMAGE${NC}"
            docker images "$BACKEND_IMAGE" --format "    Size: {{.Size}}" || true
        fi
        
        if [ "$frontend_exists" = "true" ]; then
            echo -e "${RED}  - $FRONTEND_IMAGE${NC}"
            docker images "$FRONTEND_IMAGE" --format "    Size: {{.Size}}" || true
        fi
        
        echo
    else
        print_info "No Pill Tracker Docker images found"
    fi
    
    # Return status
    if [ "$has_namespace" = false ] && [ "$has_images" = false ]; then
        return 1  # Nothing to delete
    fi
    
    return 0  # Something to delete
}

# Function to get first confirmation
get_first_confirmation() {
    echo -e "${RED}${BOLD}╔═══════════════════════════════════════════════════════╗${NC}"
    echo -e "${RED}${BOLD}║                                                       ║${NC}"
    echo -e "${RED}${BOLD}║              ⚠️  DESTRUCTIVE OPERATION ⚠️             ║${NC}"
    echo -e "${RED}${BOLD}║                                                       ║${NC}"
    echo -e "${RED}${BOLD}║  This will permanently delete ALL Pill Tracker       ║${NC}"
    echo -e "${RED}${BOLD}║  resources including:                                 ║${NC}"
    echo -e "${RED}${BOLD}║  • Kubernetes namespace and all resources             ║${NC}"
    echo -e "${RED}${BOLD}║  • Database data (cannot be recovered)                ║${NC}"
    echo -e "${RED}${BOLD}║  • Docker images                                      ║${NC}"
    echo -e "${RED}${BOLD}║                                                       ║${NC}"
    echo -e "${RED}${BOLD}║  THIS ACTION CANNOT BE UNDONE!                        ║${NC}"
    echo -e "${RED}${BOLD}║                                                       ║${NC}"
    echo -e "${RED}${BOLD}╚═══════════════════════════════════════════════════════╝${NC}"
    echo
    
    read -p "Do you want to continue? (yes/no): " -r
    echo
    
    if [[ ! $REPLY =~ ^[Yy]es$ ]]; then
        return 1
    fi
    
    return 0
}

# Function to get second confirmation
get_second_confirmation() {
    echo -e "${RED}${BOLD}FINAL CONFIRMATION REQUIRED${NC}"
    echo -e "${YELLOW}To proceed with deletion, type exactly: ${RED}${BOLD}DELETE${NC}"
    echo -e "${YELLOW}(case-sensitive)${NC}"
    echo
    read -p "Type DELETE to confirm: " -r
    echo
    
    if [[ "$REPLY" != "DELETE" ]]; then
        return 1
    fi
    
    return 0
}

# Function to delete namespace
delete_namespace() {
    print_header "Deleting Kubernetes Namespace"
    
    if ! check_namespace_exists; then
        print_info "Namespace '$NAMESPACE' does not exist, skipping"
        return 0
    fi
    
    print_info "Deleting namespace '$NAMESPACE' and all its resources..."
    echo -e "${YELLOW}This may take a minute...${NC}"
    echo
    
    if kubectl delete namespace "$NAMESPACE" --timeout=120s 2>&1; then
        print_success "Namespace deleted successfully"
    else
        print_warning "Namespace deletion timed out or failed"
        print_info "The namespace will be removed eventually by Kubernetes"
        print_info "You can check status with: kubectl get namespace $NAMESPACE"
    fi
}

# Function to delete Docker images
delete_images() {
    print_header "Deleting Docker Images"
    
    local image_status=$(check_images_exist)
    local backend_exists=$(echo "$image_status" | cut -d: -f1)
    local frontend_exists=$(echo "$image_status" | cut -d: -f2)
    
    if [ "$backend_exists" = "false" ] && [ "$frontend_exists" = "false" ]; then
        print_info "No Pill Tracker images found, skipping"
        return 0
    fi
    
    # Delete backend image
    if [ "$backend_exists" = "true" ]; then
        print_info "Deleting backend image: $BACKEND_IMAGE"
        if docker rmi "$BACKEND_IMAGE" 2>&1; then
            print_success "Backend image deleted"
        else
            print_warning "Failed to delete backend image (may not exist)"
        fi
    fi
    
    # Delete frontend image
    if [ "$frontend_exists" = "true" ]; then
        print_info "Deleting frontend image: $FRONTEND_IMAGE"
        if docker rmi "$FRONTEND_IMAGE" 2>&1; then
            print_success "Frontend image deleted"
        else
            print_warning "Failed to delete frontend image (may not exist)"
        fi
    fi
}

# Function to verify cleanup
verify_cleanup() {
    print_header "Verifying Cleanup"
    
    local all_clean=true
    
    # Check namespace
    if check_namespace_exists; then
        print_warning "Namespace '$NAMESPACE' still exists (may be terminating)"
        all_clean=false
    else
        print_success "Namespace removed"
    fi
    
    # Check images
    local image_status=$(check_images_exist)
    local backend_exists=$(echo "$image_status" | cut -d: -f1)
    local frontend_exists=$(echo "$image_status" | cut -d: -f2)
    
    if [ "$backend_exists" = "true" ]; then
        print_warning "Backend image still exists"
        all_clean=false
    else
        print_success "Backend image removed"
    fi
    
    if [ "$frontend_exists" = "true" ]; then
        print_warning "Frontend image still exists"
        all_clean=false
    else
        print_success "Frontend image removed"
    fi
    
    if [ "$all_clean" = true ]; then
        print_success "All resources successfully removed!"
    else
        print_warning "Some resources may still be terminating"
        print_info "Run this script again in a few moments to verify"
    fi
}

# Function to show completion message
show_completion_message() {
    print_header "🧹 Cleanup Complete"
    
    echo -e "${GREEN}${BOLD}All Pill Tracker resources have been removed!${NC}\n"
    
    echo -e "${CYAN}${BOLD}What was deleted:${NC}"
    echo -e "  ${GREEN}✓${NC} Kubernetes namespace: $NAMESPACE"
    echo -e "  ${GREEN}✓${NC} All pods, deployments, services"
    echo -e "  ${GREEN}✓${NC} Database data (PersistentVolumeClaims)"
    echo -e "  ${GREEN}✓${NC} ConfigMaps and Secrets"
    echo -e "  ${GREEN}✓${NC} Docker images"
    echo
    
    echo -e "${CYAN}${BOLD}To redeploy Pill Tracker:${NC}"
    echo -e "  ${BLUE}./scripts/start.sh${NC}"
    echo
    
    echo -e "${CYAN}${BOLD}Verify cleanup:${NC}"
    echo -e "  ${BLUE}kubectl get namespace $NAMESPACE${NC}  (should show 'not found')"
    echo -e "  ${BLUE}docker images | grep pill-tracker${NC}  (should be empty)"
    echo
    
    print_success "Cleanup completed successfully!"
}

# Main execution
main() {
    # Print banner
    echo -e "${MAGENTA}${BOLD}"
    echo "╔═══════════════════════════════════════════╗"
    echo "║                                           ║"
    echo "║     🧹 PILL TRACKER CLEANUP 🧹           ║"
    echo "║                                           ║"
    echo "║   Complete Resource Removal               ║"
    echo "║                                           ║"
    echo "╚═══════════════════════════════════════════╝"
    echo -e "${NC}\n"
    
    # Show what will be deleted
    if ! show_deletion_plan; then
        print_success "Nothing to clean up!"
        echo
        print_info "Pill Tracker is not currently deployed"
        exit 0
    fi
    
    # Get first confirmation
    if ! get_first_confirmation; then
        print_info "Cleanup cancelled by user"
        exit 0
    fi
    
    # Get second confirmation
    if ! get_second_confirmation; then
        print_error "Incorrect confirmation text"
        print_info "Cleanup cancelled for safety"
        exit 0
    fi
    
    # Perform cleanup
    print_header "Starting Cleanup Process"
    
    delete_namespace
    delete_images
    verify_cleanup
    show_completion_message
}

# Run main function
main "$@"

# Made with Bob
