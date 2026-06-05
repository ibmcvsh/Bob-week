# IBM Bob Integration Guide (Referencing original [guide](https://github.com/DecisionsDev/ibm-odm-management-mcp-server/blob/main/docs/IBM-Bob-integration-guide.md))

## Prerequisites

### 1. Basic requirements
1. IBM Bob - Click [Sign up](https://www.ibm.com/products/bob#Form) and fill in the form to request access to IBM Bob.
1. [Install Git](https://git-scm.com/install/windows) (you can keep the default options)
1. Install Python 3.13 or later

### 2. Install uv

1. Install uv:
    - on macOS: 
        ```shell
        brew install uv
        ```
    - on Windows: 
        1. in PowerShell, run the command described in [installing uv](https://docs.astral.sh/uv/getting-started/installation/)
        1. once `uv` is installed, open a new PowerShell tab, and run the command below:
            ```powershell
            uv tool install git+https://github.com/DecisionsDev/ibm-odm-management-mcp-server
            ```
        1. run the command below in PowerShell:
            ```powershell
            New-Item -ItemType SymbolicLink -Path "$(Split-Path (Get-Command git).Source -Parent)\git" -Target (Get-Command git).Source
            ```
            > Note:
            > This command creates a symbolic link named `git` to `git.exe` to prevent the errors below (from happening whenever the GitHub repository was updated and uvx calls git to fetch the changes): 
            > ```
            > 2025-12-31T10:29:46.477Z [ibm-odm-management-mcp-server] [info] Message from client: {"method":"initialize","params":{"protocolVersion":"2025-06-18","capabilities":{},"clientInfo":{"name":"claude-ai","version":"0.1.0"}},"jsonrpc":"2.0","id":0} { metadata: undefined }
            >    Updating https://github.com/DecisionsDev/ibm-odm-management-mcp-server (HEAD)
            >   × Failed to download and build `decisioncenter-mcp-server @
            >   │ git+https://github.com/DecisionsDev/ibm-odm-management-mcp-server@bbb8a86091410aa1f8a9fa458c43a6fba38596f3`
            >   ├─▶ Git operation failed
            >   ╰─▶ Git executable not found. Ensure that Git is installed and available.
            > ```

1. Verify your Python and `uv` installation:

    Run the command below (in a terminal or PowerShell):
    ```
    uv python list
    ```
    You should see the version(s) of Python you have installed.

### 3. Install Podman, Docker, or Rancher Desktop

This step is needed if you choose to run ODM as a container on your laptop using the ODM for Developer image. Alternatively you can use an ODM deployment running on a server.

Here are the steps to install Rancher Desktop if you chose this application to run containers:
- on Mac:
    1. Download the installer from [Rancher Desktop website](https://rancherdesktop.io/)
    1. Open the downloaded .dmg file and drag Rancher Desktop to your Applications folder
    1. Launch Rancher Desktop from your Applications folder
        - In the settings, select "dockerd" as the container runtime (not "containerd")
    1. Verify the installation:
        - Open a Terminal
        - Run the following commands:
            ```bash
            docker --version
            docker compose --version
            ```
        - These commands should display the installed versions, confirming that Docker and Docker Compose are properly installed

- on Windows:
    1. Install WSL 2 (Windows Subsystem for Linux)
        - Open PowerShell as Administrator and run:
            ```powershell
            wsl --install
            ```
        - Restart your computer when prompted
        - After restart, a Linux distribution (usually Ubuntu) will be installed automatically
        - Set up your Linux username and password when prompted (ex: admin/admin)
    1. Download the installer from [Rancher Desktop website](https://rancherdesktop.io/)
    1. Run the installer and follow the on-screen instructions
    1. Run Rancher Desktop
        - Disable Kubernetes (Not needed for this demonstration)
        - Wait until the initialization was finished.
        - Ensure WSL integration is enabled
        - Select "dockerd" as the container runtime (not "containerd")
        - After installation, Rancher Desktop will start automatically
    1. Verify the installation:
        - Open a PowerShell window
        - Run the following commands:
            ```bash
            docker --version
            docker compose --version
            ```
        - These commands should display the installed versions, confirming that Docker and Docker Compose are properly installed

### 4. Run ODM for Developer

This step is optional and only needed if you choose to run ODM as a container on your laptop using the ODM for Developer image. Alternatively you can use an ODM deployment running on a server.

- clone this repository,
    ```bash
    git clone https://github.com/DecisionsDev/ibm-odm-management-mcp-server.git
    cd ibm-odm-management-mcp-server
    ```
- run:
    **For macOS/Linux (in Terminal) and Windows (in PowerShell):**
    ```bash
    docker compose up
    ```    
    If the command is successful, you should see:
    ```
    upload_materials  | ✅ ODM Ready for MCP Server
    upload_materials exited with code 0
    ```

**MacOS Apple Silicon Users:** [Troubleshooting tips](#macos-odm-container-troubleshooting) for getting containers to launch correctly.

- Once the containers are running, the ODM web consoles are available at [http://localhost:9060](http://localhost:9060) using the default credentials:

  - **Username:** `odmAdmin`
  - **Password:** `odmAdmin`

Now that your ODM is running, return to the lab guide and continue with the next step.
***[Lab Guide](./ODM-MCP-Server-Lab.md#configure-mcp-within-ibm-bob)**



# Troubleshooting

## MacOS ODM Container Troubleshooting

### Increase Memory for Podman / Docker

```bash
podman machine stop
podman machine set --memory 8192  # 8GB for the VM
podman machine start
```

### Adjust docker compose
In your docker-compose.yaml file
```yaml
services:
  odm:
    image: icr.io/cpopen/odm-k8s/odm:9.5
    platform: linux/amd64 # add this line to force usage of Rosetta
    hostname: odm
    container_name: odm
    environment:
      - LICENSE=accept
      - JAVA_OPTS=-Xms512m -Xmx1536m # add this line to reduce JVM heap
    deploy: # add this section to set memory limits
      resources:
        limits:
          memory: 5g
        reservations:
          memory: 3g
    healthcheck:
      test: curl -k -f http://localhost:9060/decisioncenter/healthCheck || exit 1
      interval: 5s
      timeout: 10s
      retries: 30
      start_period: 10s
    ports:
      - 9060:9060
```
