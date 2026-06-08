#!/bin/bash

# ============================================================================
# Bobathon Labs - Dependency Installation Script for macOS
# ============================================================================
# This script installs all dependencies required for the Java Modernization labs
# 
# Dependencies installed:
# - Homebrew (if not present)
# - Updated Bash (for SDKMAN compatibility)
# - SDKMAN (Java and Maven manager)
# - Java 21 (Eclipse Temurin)
# - Maven
# - Node.js 18+ (optional, for Lab 3 and Figma labs)
# - Angular CLI (optional, for Lab 3)
# ============================================================================

set -e  # Exit on error

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Print functions
print_header() {
    echo -e "\n${BLUE}============================================================================${NC}"
    echo -e "${BLUE}$1${NC}"
    echo -e "${BLUE}============================================================================${NC}\n"
}

print_success() {
    echo -e "${GREEN}✓ $1${NC}"
}

print_warning() {
    echo -e "${YELLOW}⚠ $1${NC}"
}

print_error() {
    echo -e "${RED}✗ $1${NC}"
}

print_info() {
    echo -e "${BLUE}ℹ $1${NC}"
}

# Check if command exists
command_exists() {
    command -v "$1" >/dev/null 2>&1
}

# ============================================================================
# Main Installation
# ============================================================================

print_header "Bobathon Labs - Dependency Installation for macOS"

echo "This script will install the following dependencies:"
echo "  • Homebrew (package manager)"
echo "  • Updated Bash (for SDKMAN)"
echo "  • SDKMAN (Java/Maven manager)"
echo "  • Java 21 (Eclipse Temurin)"
echo "  • Maven 3.6+"
echo "  • Node.js 18+ (optional)"
echo "  • Angular CLI (optional)"
echo ""
read -p "Do you want to continue? (y/n) " -n 1 -r
echo
if [[ ! $REPLY =~ ^[Yy]$ ]]; then
    print_warning "Installation cancelled."
    exit 0
fi

# ============================================================================
# 1. Install Homebrew
# ============================================================================

print_header "Step 1: Installing Homebrew"

if command_exists brew; then
    print_success "Homebrew is already installed"
    brew --version
else
    print_info "Installing Homebrew..."
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
    
    # Add Homebrew to PATH for Apple Silicon Macs
    if [[ $(uname -m) == 'arm64' ]]; then
        echo 'eval "$(/opt/homebrew/bin/brew shellenv)"' >> ~/.zprofile
        eval "$(/opt/homebrew/bin/brew shellenv)"
    fi
    
    print_success "Homebrew installed successfully"
fi

# ============================================================================
# 2. Install Updated Bash (for SDKMAN compatibility)
# ============================================================================

print_header "Step 2: Installing Updated Bash"

BASH_VERSION=$(bash --version | head -n1 | grep -oE '[0-9]+\.[0-9]+' | head -n1)
BASH_MAJOR=$(echo $BASH_VERSION | cut -d. -f1)

if [ "$BASH_MAJOR" -lt 4 ]; then
    print_warning "Your bash version ($BASH_VERSION) is outdated. Installing newer version..."
    brew install bash
    
    # Get the new bash path
    NEW_BASH_PATH=$(brew --prefix)/bin/bash
    
    print_info "New bash installed at: $NEW_BASH_PATH"
    print_warning "Note: You may need to add this to /etc/shells and change your default shell"
    print_info "Run these commands manually if needed:"
    echo "  sudo bash -c 'echo $NEW_BASH_PATH >> /etc/shells'"
    echo "  chsh -s $NEW_BASH_PATH"
else
    print_success "Bash version $BASH_VERSION is sufficient"
fi

# ============================================================================
# 3. Install SDKMAN
# ============================================================================

print_header "Step 3: Installing SDKMAN"

# Ensure we're using bash 4+ for SDKMAN
if command_exists $(brew --prefix)/bin/bash 2>/dev/null; then
    BASH_TO_USE="$(brew --prefix)/bin/bash"
else
    BASH_TO_USE="bash"
fi

if [ -d "$HOME/.sdkman" ]; then
    print_success "SDKMAN is already installed"
    # Use updated bash to source SDKMAN to avoid substitution errors
    $BASH_TO_USE -c "source '$HOME/.sdkman/bin/sdkman-init.sh' && sdk version"
else
    print_info "Installing SDKMAN..."
    
    # Use the updated bash for installation if available
    if command_exists $(brew --prefix)/bin/bash; then
        curl -s "https://get.sdkman.io" | $(brew --prefix)/bin/bash
    else
        curl -s "https://get.sdkman.io" | bash
    fi
    
    # Source SDKMAN
    export SDKMAN_DIR="$HOME/.sdkman"
    source "$HOME/.sdkman/bin/sdkman-init.sh"
    
    print_success "SDKMAN installed successfully"
fi

# ============================================================================
# 4. Install Java 8 and Java 21
# ============================================================================

print_header "Step 4: Installing Java 8 and Java 21"

# Source SDKMAN with updated bash
if command_exists $(brew --prefix)/bin/bash 2>/dev/null; then
    export BASH_TO_USE="$(brew --prefix)/bin/bash"
else
    export BASH_TO_USE="bash"
fi

# Create a wrapper function to use SDKMAN with the correct bash
sdk() {
    $BASH_TO_USE -c "source '$HOME/.sdkman/bin/sdkman-init.sh' && sdk $*"
}
export -f sdk

# Install Java 8
if sdk list java | grep -q "8.0.492-zulu.*installed"; then
    print_success "Java 8 is already installed"
else
    print_info "Installing Java 8 (Zulu)..."
    sdk install java 8.0.492-zulu
    print_success "Java 8 installed successfully"
fi

# Install Java 21
if sdk list java | grep -q "21.*tem.*installed"; then
    print_success "Java 21 is already installed"
else
    print_info "Installing Java 21 (Eclipse Temurin)..."
    sdk install java 21-tem
    print_success "Java 21 installed successfully"
fi

# Set Java 21 as default
print_info "Setting Java 21 as default..."
sdk default java 21-tem

print_info "Both Java 8 and Java 21 are installed. You can switch between them using:"
echo "  sdk use java 8.0.492-zulu   # Switch to Java 8"
echo "  sdk use java 21-tem         # Switch to Java 21"

# Verify Java installation
print_info "Verifying Java installation..."
java -version
print_success "Java is ready to use"

# ============================================================================
# 5. Install Maven
# ============================================================================

print_header "Step 5: Installing Maven"

if command_exists mvn; then
    print_success "Maven is already installed"
    mvn --version
else
    print_info "Installing Maven via SDKMAN..."
    sdk install maven
    print_success "Maven installed successfully"
fi

# Verify Maven installation
print_info "Verifying Maven installation..."
mvn --version
print_success "Maven is ready to use"

# ============================================================================
# 6. Install Node.js (Optional)
# ============================================================================

print_header "Step 6: Installing Node.js (Optional - for Lab 3 and Figma labs)"

echo "Node.js is required for:"
echo "  • Lab 3: UI Modernization (Struts to Angular)"
echo "  • Figma Integration Labs"
echo ""
read -p "Do you want to install Node.js? (y/n) " -n 1 -r
echo

if [[ $REPLY =~ ^[Yy]$ ]]; then
    if command_exists node; then
        NODE_VERSION=$(node --version | grep -oE '[0-9]+' | head -n1)
        if [ "$NODE_VERSION" -ge 18 ]; then
            print_success "Node.js $(node --version) is already installed"
        else
            print_warning "Node.js version is too old. Installing Node.js 18..."
            brew install node@18
            brew link node@18
        fi
    else
        print_info "Installing Node.js 18..."
        brew install node@18
        brew link node@18
        print_success "Node.js installed successfully"
    fi
    
    # Verify Node.js installation
    print_info "Verifying Node.js installation..."
    node --version
    npm --version
    print_success "Node.js is ready to use"
    
    # ========================================================================
    # 7. Install Angular CLI (Optional)
    # ========================================================================
    
    print_header "Step 7: Installing Angular CLI (Optional - for Lab 3)"
    
    echo "Angular CLI is required for Lab 3: UI Modernization"
    echo ""
    read -p "Do you want to install Angular CLI? (y/n) " -n 1 -r
    echo
    
    if [[ $REPLY =~ ^[Yy]$ ]]; then
        if command_exists ng; then
            print_success "Angular CLI is already installed"
            ng version
        else
            print_info "Installing Angular CLI globally..."
            npm install -g @angular/cli
            print_success "Angular CLI installed successfully"
        fi
        
        # Verify Angular CLI installation
        print_info "Verifying Angular CLI installation..."
        ng version
        print_success "Angular CLI is ready to use"
    else
        print_info "Skipping Angular CLI installation"
    fi
else
    print_info "Skipping Node.js installation"
fi

# ============================================================================
# Installation Complete
# ============================================================================

print_header "Installation Complete!"

echo -e "${GREEN}All required dependencies have been installed successfully!${NC}\n"

echo "Installed components:"
echo "  ✓ Homebrew"
echo "  ✓ Updated Bash (if needed)"
echo "  ✓ SDKMAN"
echo "  ✓ Java 21 (Eclipse Temurin)"
echo "  ✓ Maven"
if command_exists node; then
    echo "  ✓ Node.js $(node --version)"
fi
if command_exists ng; then
    echo "  ✓ Angular CLI"
fi

echo ""
echo -e "${YELLOW}IMPORTANT: Next Steps${NC}"
echo "1. Close and reopen your terminal for all changes to take effect"
echo "2. Verify installations by running:"
echo "   java -version"
echo "   mvn --version"
if command_exists node; then
    echo "   node --version"
fi
if command_exists ng; then
    echo "   ng version"
fi
echo ""
echo "3. You're now ready to start the Bobathon labs!"
echo "   Navigate to the lab directory and follow the lab guide."
echo ""
echo -e "${BLUE}For more information, see: Bobathon/GETTING_STARTED.md${NC}"

# Made with Bob
