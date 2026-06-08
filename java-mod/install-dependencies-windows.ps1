# ============================================================================
# Bobathon Labs - Dependency Installation Script for Windows
# ============================================================================
# This script installs all dependencies required for the Java Modernization labs
# 
# Dependencies installed:
# - Chocolatey (package manager)
# - Java 21 (Eclipse Temurin)
# - Maven
# - Node.js 18+ (optional, for Lab 3 and Figma labs)
# - Angular CLI (optional, for Lab 3)
#
# IMPORTANT: Run this script as Administrator
# Right-click PowerShell and select "Run as Administrator"
# ============================================================================

# Requires Administrator privileges
#Requires -RunAsAdministrator

# Set execution policy for this session
Set-ExecutionPolicy Bypass -Scope Process -Force

# Colors for output
function Write-Header {
    param([string]$Message)
    Write-Host "`n============================================================================" -ForegroundColor Blue
    Write-Host $Message -ForegroundColor Blue
    Write-Host "============================================================================`n" -ForegroundColor Blue
}

function Write-Success {
    param([string]$Message)
    Write-Host "[OK] $Message" -ForegroundColor Green
}

function Write-Warning {
    param([string]$Message)
    Write-Host "[WARNING] $Message" -ForegroundColor Yellow
}

function Write-Error {
    param([string]$Message)
    Write-Host "[ERROR] $Message" -ForegroundColor Red
}

function Write-Info {
    param([string]$Message)
    Write-Host "[INFO] $Message" -ForegroundColor Cyan
}

# Check if command exists
function Test-CommandExists {
    param([string]$Command)
    $null -ne (Get-Command $Command -ErrorAction SilentlyContinue)
}

# ============================================================================
# Main Installation
# ============================================================================

Write-Header "Bobathon Labs - Dependency Installation for Windows"

Write-Host "This script will install the following dependencies:"
Write-Host "  - Chocolatey (package manager)"
Write-Host "  - Java 21 (Eclipse Temurin)"
Write-Host "  - Maven 3.6+"
Write-Host "  - Node.js 18+ (optional)"
Write-Host "  - Angular CLI (optional)"
Write-Host ""
Write-Warning "IMPORTANT: This script must be run as Administrator"
Write-Host ""

$continue = Read-Host "Do you want to continue? (Y/N)"
if ($continue -notmatch '^[Yy]$') {
    Write-Warning "Installation cancelled."
    exit 0
}

# ============================================================================
# 1. Install Chocolatey
# ============================================================================

Write-Header "Step 1: Installing Chocolatey"

if (Test-CommandExists choco) {
    Write-Success "Chocolatey is already installed"
    choco --version
} else {
    Write-Info "Installing Chocolatey..."
    [System.Net.ServicePointManager]::SecurityProtocol = [System.Net.ServicePointManager]::SecurityProtocol -bor 3072
    Invoke-Expression ((New-Object System.Net.WebClient).DownloadString('https://community.chocolatey.org/install.ps1'))
    
    # Refresh environment variables
    $env:Path = [System.Environment]::GetEnvironmentVariable("Path","Machine") + ";" + [System.Environment]::GetEnvironmentVariable("Path","User")
    
    Write-Success "Chocolatey installed successfully"
}

# ============================================================================
# 2. Install Java 8 and Java 21
# ============================================================================

Write-Header "Step 2: Installing Java 8 and Java 21"

# Install Java 8
Write-Info "Installing Java 8 (Zulu)..."
choco install zulu8 -y

# Install Java 21 (explicitly request 64-bit version)
Write-Info "Installing Java 21 (Eclipse Temurin) 64-bit..."
choco install temurin21 -y --x64

# Refresh environment variables
$env:Path = [System.Environment]::GetEnvironmentVariable("Path","Machine") + ";" + [System.Environment]::GetEnvironmentVariable("Path","User")

# Set Java 21 as default by updating JAVA_HOME
# Try multiple possible Java 21 installation locations
$possiblePaths = @(
    "C:\Program Files\Eclipse Adoptium\jdk-21*",
    "C:\Program Files\Eclipse Foundation\jdk-21*",
    "C:\Program Files\Temurin\jdk-21*",
    "C:\Program Files\Java\jdk-21*",
    "C:\Program Files\AdoptOpenJDK\jdk-21*"
)

$java21Dir = $null
foreach ($path in $possiblePaths) {
    $found = Get-Item $path -ErrorAction SilentlyContinue | Select-Object -First 1
    if ($found) {
        $java21Dir = $found
        Write-Info "Found Java 21 at: $($found.FullName)"
        break
    }
}

if ($java21Dir) {
    [System.Environment]::SetEnvironmentVariable("JAVA_HOME", $java21Dir.FullName, "Machine")
    $env:JAVA_HOME = $java21Dir.FullName
    Write-Success "Set Java 21 as default: $($java21Dir.FullName)"
} else {
    Write-Warning "Could not automatically locate Java 21 installation directory"
    Write-Info "Checking if Java is available in PATH..."
    
    # Try to find Java via PATH
    $javaExe = Get-Command java -ErrorAction SilentlyContinue
    if ($javaExe) {
        $javaPath = Split-Path (Split-Path $javaExe.Source)
        Write-Info "Java executable found at: $javaPath"
        Write-Warning "Please manually set JAVA_HOME environment variable to: $javaPath"
        Write-Host "`nTo set JAVA_HOME manually:" -ForegroundColor Yellow
        Write-Host "1. Open System Properties > Environment Variables"
        Write-Host "2. Create/Edit JAVA_HOME system variable"
        Write-Host "3. Set value to: $javaPath"
    } else {
        Write-Error "Java installation not found. Please install Java 21 manually."
        Write-Host "`nManual Java 21 Installation:" -ForegroundColor Yellow
        Write-Host "1. Download 64-bit Java 21 from: https://adoptium.net/temurin/releases/"
        Write-Host "2. Install to a location without spaces (e.g., C:\Java\jdk-21)"
        Write-Host "3. Set JAVA_HOME environment variable to installation path"
        Write-Host "4. Add %JAVA_HOME%\bin to PATH"
    }
}

Write-Info "Both Java 8 and Java 21 are installed."
Write-Info "Java 21 is set as default. To switch between versions:"
Write-Host "  - Update JAVA_HOME environment variable to the desired Java installation path"
Write-Host "  - Java 8 location: C:\Program Files\Zulu\zulu-8\"
Write-Host "  - Java 21 location: C:\Program Files\Eclipse Adoptium\jdk-21*\"

# Verify Java installation
Write-Info "Verifying Java installation..."
$javaVersionOutput = java -version 2>&1 | Out-String

# Display Java version
Write-Host $javaVersionOutput

# Check if 64-bit Java is installed
if ($javaVersionOutput -match "64-Bit") {
    Write-Success "64-bit Java detected - Labs requirement met"
} else {
    Write-Error "32-bit Java detected or architecture could not be determined"
    Write-Warning "The labs require 64-bit Java 21 or newer"
    Write-Host "`nPlease install 64-bit Java 21:" -ForegroundColor Yellow
    Write-Host "1. Uninstall current Java version"
    Write-Host "2. Download 64-bit Java 21 from: https://adoptium.net/temurin/releases/"
    Write-Host "3. Select 'x64' architecture during download"
    Write-Host "4. Re-run this script or set JAVA_HOME manually"
}

# Verify JAVA_HOME is set correctly
if ($env:JAVA_HOME) {
    if (Test-Path "$env:JAVA_HOME\bin\java.exe") {
        Write-Success "JAVA_HOME is set correctly: $env:JAVA_HOME"
    } else {
        Write-Warning "JAVA_HOME is set but points to invalid location: $env:JAVA_HOME"
        Write-Info "Please verify the path and update if necessary"
    }
} else {
    Write-Warning "JAVA_HOME environment variable is not set"
    Write-Info "Some tools may require JAVA_HOME to be set"
}

Write-Success "Java verification complete"

# ============================================================================
# 3. Install Maven
# ============================================================================

Write-Header "Step 3: Installing Maven"

if (Test-CommandExists mvn) {
    Write-Success "Maven is already installed"
    mvn --version
} else {
    Write-Info "Installing Maven..."
    choco install maven -y
    Write-Success "Maven installed successfully"
}

# Refresh environment variables
$env:Path = [System.Environment]::GetEnvironmentVariable("Path","Machine") + ";" + [System.Environment]::GetEnvironmentVariable("Path","User")

# Verify Maven installation
Write-Info "Verifying Maven installation..."
mvn --version
Write-Success "Maven is ready to use"

# ============================================================================
# 4. Install Node.js (Optional)
# ============================================================================

Write-Header "Step 4: Installing Node.js (Optional - for Lab 3 and Figma labs)"

Write-Host "Node.js is required for:"
Write-Host "  - Lab 3: UI Modernization (Struts to Angular)"
Write-Host "  - Figma Integration Labs"
Write-Host ""

$installNode = Read-Host "Do you want to install Node.js? (Y/N)"

if ($installNode -match '^[Yy]$') {
    if (Test-CommandExists node) {
        $nodeVersion = node --version
        $nodeMajor = [int]($nodeVersion -replace 'v(\d+)\..*', '$1')
        if ($nodeMajor -ge 18) {
            Write-Success "Node.js $nodeVersion is already installed"
        } else {
            Write-Warning "Node.js version is too old. Installing Node.js 18..."
            choco install nodejs-lts -y --version=18.20.4
        }
    } else {
        Write-Info "Installing Node.js 18 LTS..."
        choco install nodejs-lts -y
        Write-Success "Node.js installed successfully"
    }
    
    # Refresh environment variables
    $env:Path = [System.Environment]::GetEnvironmentVariable("Path","Machine") + ";" + [System.Environment]::GetEnvironmentVariable("Path","User")
    
    # Verify Node.js installation
    Write-Info "Verifying Node.js installation..."
    node --version
    npm --version
    Write-Success "Node.js is ready to use"
    
    # ========================================================================
    # 5. Install Angular CLI (Optional)
    # ========================================================================
    
    Write-Header "Step 5: Installing Angular CLI (Optional - for Lab 3)"
    
    Write-Host "Angular CLI is required for Lab 3: UI Modernization"
    Write-Host ""
    
    $installAngular = Read-Host "Do you want to install Angular CLI? (Y/N)"
    
    if ($installAngular -match '^[Yy]$') {
        if (Test-CommandExists ng) {
            Write-Success "Angular CLI is already installed"
            ng version
        } else {
            Write-Info "Installing Angular CLI globally..."
            npm install -g @angular/cli
            Write-Success "Angular CLI installed successfully"
        }
        
        # Refresh environment variables
        $env:Path = [System.Environment]::GetEnvironmentVariable("Path","Machine") + ";" + [System.Environment]::GetEnvironmentVariable("Path","User")
        
        # Verify Angular CLI installation
        Write-Info "Verifying Angular CLI installation..."
        ng version
        Write-Success "Angular CLI is ready to use"
    } else {
        Write-Info "Skipping Angular CLI installation"
    }
} else {
    Write-Info "Skipping Node.js installation"
}

# ============================================================================
# Installation Complete
# ============================================================================

Write-Header "Installation Complete!"

Write-Host "All required dependencies have been installed successfully!`n" -ForegroundColor Green

Write-Host "Installed components:"
Write-Host "  [OK] Chocolatey"
Write-Host "  [OK] Java 21 (Eclipse Temurin)"
Write-Host "  [OK] Maven"
if (Test-CommandExists node) {
    $nodeVer = node --version
    Write-Host "  [OK] Node.js $nodeVer"
}
if (Test-CommandExists ng) {
    Write-Host "  [OK] Angular CLI"
}

Write-Host ""
Write-Host "IMPORTANT: Next Steps" -ForegroundColor Yellow
Write-Host "1. Close and reopen PowerShell/Command Prompt for all changes to take effect"
Write-Host "2. Verify installations by running:"
Write-Host "   java -version"
Write-Host "   mvn --version"
if (Test-CommandExists node) {
    Write-Host "   node --version"
}
if (Test-CommandExists ng) {
    Write-Host "   ng version"
}
Write-Host ""
Write-Host '3. You''re now ready to start the Bobathon labs!'
Write-Host "   Navigate to the lab directory and follow the lab guide."
Write-Host ""
Write-Host "For more information, see: Bobathon\GETTING_STARTED.md" -ForegroundColor Blue

Write-Host "`nPress any key to exit..."
$null = $Host.UI.RawUI.ReadKey("NoEcho,IncludeKeyDown")

# Made with Bob