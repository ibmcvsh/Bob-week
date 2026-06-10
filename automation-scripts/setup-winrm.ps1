# WinRM Setup Script for Ansible
# Run this as Administrator on each Windows machine

Write-Host "========================================" -ForegroundColor Cyan
Write-Host "WinRM Setup for Ansible" -ForegroundColor Cyan
Write-Host "========================================" -ForegroundColor Cyan
Write-Host ""

# Check if running as Administrator
$isAdmin = ([Security.Principal.WindowsPrincipal] [Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)
if (-not $isAdmin) {
    Write-Host "✗ ERROR: This script must be run as Administrator!" -ForegroundColor Red
    Write-Host "Right-click PowerShell and select 'Run as Administrator'" -ForegroundColor Yellow
    exit 1
}

Write-Host "✓ Running as Administrator" -ForegroundColor Green
Write-Host ""

# Step 1: Enable and configure WinRM
Write-Host "[1/6] Enabling WinRM..." -ForegroundColor Yellow
try {
    winrm quickconfig -q -force
    Write-Host "  ✓ WinRM enabled" -ForegroundColor Green
} catch {
    Write-Host "  ✗ Failed to enable WinRM: $_" -ForegroundColor Red
    exit 1
}

# Step 2: Enable Basic authentication
Write-Host "[2/6] Enabling Basic authentication..." -ForegroundColor Yellow
try {
    winrm set winrm/config/service/auth '@{Basic="true"}' | Out-Null
    Write-Host "  ✓ Basic authentication enabled" -ForegroundColor Green
} catch {
    Write-Host "  ✗ Failed to enable Basic auth: $_" -ForegroundColor Red
}

# Step 3: Allow unencrypted traffic
Write-Host "[3/6] Allowing unencrypted traffic..." -ForegroundColor Yellow
try {
    winrm set winrm/config/service '@{AllowUnencrypted="true"}' | Out-Null
    Write-Host "  ✓ Unencrypted traffic allowed" -ForegroundColor Green
} catch {
    Write-Host "  ✗ Failed to allow unencrypted traffic: $_" -ForegroundColor Red
}

# Step 4: Set TrustedHosts
Write-Host "[4/6] Configuring TrustedHosts..." -ForegroundColor Yellow
try {
    Set-Item WSMan:\localhost\Client\TrustedHosts -Value "*" -Force
    Write-Host "  ✓ TrustedHosts configured" -ForegroundColor Green
} catch {
    Write-Host "  ✗ Failed to set TrustedHosts: $_" -ForegroundColor Red
}

# Step 5: Configure firewall
Write-Host "[5/6] Configuring Windows Firewall..." -ForegroundColor Yellow
try {
    # Allow WinRM HTTP
    netsh advfirewall firewall add rule name="WinRM-HTTP" dir=in action=allow protocol=TCP localport=5985 | Out-Null
    Write-Host "  ✓ Firewall rule added for WinRM (port 5985)" -ForegroundColor Green
} catch {
    Write-Host "  ⚠ Firewall rule may already exist or failed to add" -ForegroundColor Yellow
}

# Step 6: Restart WinRM service
Write-Host "[6/6] Restarting WinRM service..." -ForegroundColor Yellow
try {
    Restart-Service WinRM -Force
    Write-Host "  ✓ WinRM service restarted" -ForegroundColor Green
} catch {
    Write-Host "  ✗ Failed to restart WinRM: $_" -ForegroundColor Red
}

Write-Host ""
Write-Host "========================================" -ForegroundColor Cyan
Write-Host "Configuration Summary" -ForegroundColor Cyan
Write-Host "========================================" -ForegroundColor Cyan

# Display current configuration
Write-Host ""
Write-Host "WinRM Service Status:" -ForegroundColor Yellow
$service = Get-Service WinRM
Write-Host "  Status: $($service.Status)" -ForegroundColor $(if ($service.Status -eq "Running") { "Green" } else { "Red" })
Write-Host "  Startup Type: $($service.StartType)" -ForegroundColor Gray

Write-Host ""
Write-Host "WinRM Configuration:" -ForegroundColor Yellow
try {
    $basicAuth = (Get-Item WSMan:\localhost\Service\Auth\Basic).Value
    $allowUnencrypted = (Get-Item WSMan:\localhost\Service\AllowUnencrypted).Value
    $trustedHosts = (Get-Item WSMan:\localhost\Client\TrustedHosts).Value
    
    Write-Host "  Basic Auth: $basicAuth" -ForegroundColor $(if ($basicAuth -eq "true") { "Green" } else { "Red" })
    Write-Host "  Allow Unencrypted: $allowUnencrypted" -ForegroundColor $(if ($allowUnencrypted -eq "true") { "Green" } else { "Red" })
    Write-Host "  TrustedHosts: $trustedHosts" -ForegroundColor $(if ($trustedHosts) { "Green" } else { "Yellow" })
} catch {
    Write-Host "  ✗ Error reading configuration" -ForegroundColor Red
}

Write-Host ""
Write-Host "Network Information:" -ForegroundColor Yellow
$ipAddresses = Get-NetIPAddress -AddressFamily IPv4 | Where-Object {$_.IPAddress -notlike "127.*"} | Select-Object IPAddress, InterfaceAlias
$ipAddresses | ForEach-Object {
    Write-Host "  $($_.IPAddress) ($($_.InterfaceAlias))" -ForegroundColor Gray
}

Write-Host ""
Write-Host "========================================" -ForegroundColor Cyan
Write-Host "Testing WinRM Connection" -ForegroundColor Cyan
Write-Host "========================================" -ForegroundColor Cyan
Write-Host ""

try {
    $result = Test-WSMan -ComputerName localhost -ErrorAction Stop
    Write-Host "✓ WinRM is working correctly!" -ForegroundColor Green
    Write-Host "  Product Version: $($result.ProductVersion)" -ForegroundColor Gray
    Write-Host "  Protocol Version: $($result.ProtocolVersion)" -ForegroundColor Gray
} catch {
    Write-Host "✗ WinRM test failed: $_" -ForegroundColor Red
    Write-Host "Please review the errors above and try again." -ForegroundColor Yellow
    exit 1
}

Write-Host ""
Write-Host "========================================" -ForegroundColor Cyan
Write-Host "Setup Complete!" -ForegroundColor Green
Write-Host "========================================" -ForegroundColor Cyan
Write-Host ""
Write-Host "This machine is now ready for Ansible management." -ForegroundColor Green
Write-Host ""
Write-Host "Add this to your Ansible inventory:" -ForegroundColor Yellow
Write-Host ""
$primaryIP = (Get-NetIPAddress -AddressFamily IPv4 | Where-Object {$_.IPAddress -notlike "127.*"} | Select-Object -First 1).IPAddress
Write-Host "lab-pc-XX ansible_host=$primaryIP" -ForegroundColor White
Write-Host ""
Write-Host "Test from Ansible control node:" -ForegroundColor Yellow
Write-Host "ansible lab-pc-XX -i inventory.ini -m win_ping" -ForegroundColor White
Write-Host ""

# Made with Bob
