#!/bin/bash

# Pill Tracker Cleanup Script
# This script removes the Pill Tracker application from Kubernetes

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

# Main execution
main() {
    # Print banner
    echo -e "${CYAN}${BOLD}"
    echo "╔═══════════════════════════════════════════╗"
    echo "║                                           ║"
    echo "║     💊 PILL TRACKER CLEANUP 💊           ║"
    echo "║                                           ║"
    echo "║   Remove Kubernetes Deployment            ║"
    echo "║                                           ║"
    echo "╚═══════════════════════════════════════════╝"
    echo -e "${NC}\n"
    
    print_header "Checking Namespace"
    
    # Check if namespace exists
    if ! kubectl get namespace "$NAMESPACE" >/dev/null 2>&1; then
        print_info "Namespace '$NAMESPACE' does not exist"
        print_success "Nothing to clean up!"
        exit 0
    fi
    
    # Show what will be deleted
    print_warning "The following resources will be deleted:"
    echo
    kubectl get all -n "$NAMESPACE" 2>/dev/null || true
    echo
    
    # Confirm deletion
    echo -e "${YELLOW}${BOLD}Are you sure you want to delete the '$NAMESPACE' namespace and all its resources?${NC}"
    echo -e "${RED}This action cannot be undone!${NC}"
    read -p "Type 'yes' to confirm: " -r
    echo
    
    if [[ ! $REPLY =~ ^yes$ ]]; then
        print_info "Cleanup cancelled by user"
        exit 0
    fi
    
    print_header "Deleting Resources"
    
    # Delete namespace (this will delete all resources in it)
    print_info "Deleting namespace '$NAMESPACE'..."
    if kubectl delete namespace "$NAMESPACE" --timeout=60s; then
        print_success "Namespace deleted successfully"
    else
        print_warning "Namespace deletion timed out, but it will be removed eventually"
    fi
    
    print_header "Cleanup Complete"
    
    print_success "All Pill Tracker resources have been removed"
    echo
    print_info "To redeploy, run: ${BLUE}./scripts/start.sh${NC}"
}

# Run main function
main "$@"

# Made with Bob
