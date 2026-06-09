# DevSecOps Ansible Lab Guide

This lab guide provides hands-on exercises for DevSecOps engineers to practice Ansible automation. Each task includes requirements and questions to track your learning progress.

## Instructions for Each Task

After writing each playbook, answer the following questions as comments at the top of the file (YAML comments start with `#`):

1. How many times did you have to edit the suggested code?
2. Did you ever have to leave your VSCode to complete this task?
3. How long did it take to complete this task?

**Note:** Use a host group named `poc_hosts` for all tasks below.

---

## Basic Tasks (Completed Examples)

### Task 1: File Creation (ls_1.yml) ✓
Create files with specific content:
- Create a file with content "poc1 text" in a file named `poc1.txt`
- Create a file with content "poc2 text" in a file named `poc2.txt`

### Task 2: File Operations (ls_2.yml) ✓
Copy files to a new directory:
- Copy the file `poc1.txt` into a new folder "PoC3"
- Copy the file `poc2.txt` into a new folder "PoC3"

### Task 3: System Information Gathering (ls_3.yml) ✓
Gather and save system information:
- Gather system information about the target host
- Save it to a file `system_facts.json` in JSON format in the directory "PoC1"
- Save it to a file `system_facts.yaml` in YAML format in the directory "PoC2"

### Task 4: AWS EC2 Provisioning (ls_4.yml) ✓
Provision an AWS EC2 VM and take a snapshot:
- Provision EC2 instance with specified configuration
- Take a snapshot of the provisioned VM

---

## Security & Compliance Tasks

### Task 5: Security Hardening (ls_5.yml)
Implement basic security hardening on Linux systems:
- Disable root login via SSH (set `PermitRootLogin no` in `/etc/ssh/sshd_config`)
- Set password minimum length to 12 characters in `/etc/security/pwquality.conf`
- Enable firewall (firewalld or ufw depending on OS)
- Allow only SSH (port 22) and HTTPS (port 443) through the firewall
- Restart SSH service to apply changes
- Tag the playbook run with: environment -> production, security_level -> hardened

### Task 6: SSL/TLS Certificate Management (ls_6.yml)
Generate and deploy SSL certificates:
- Install OpenSSL package
- Create directory `/etc/ssl/private` with mode 0700
- Generate a private key at `/etc/ssl/private/server.key` (2048 bits)
- Generate a self-signed certificate at `/etc/ssl/certs/server.crt` (valid for 365 days)
  - Common Name: `{{ server_hostname }}`
  - Organization: `{{ organization_name }}`
  - Country: `{{ country_code }}`
- Set proper permissions: private key (0600), certificate (0644)
- Create a backup of both files in `/etc/ssl/backup/` directory

### Task 7: User Access Control (ls_7.yml)
Manage users and access controls:
- Create a group named `devsecops` with GID 3000
- Create three users: `dev_user1`, `dev_user2`, `sec_user1`
- Add `dev_user1` and `dev_user2` to the `devsecops` group
- Set password for each user using variable `{{ user_password }}`
- Create SSH directory for each user (`~/.ssh`) with mode 0700
- Copy SSH public key from variable `{{ ssh_public_key }}` to each user's `authorized_keys`
- Set `authorized_keys` file permissions to 0600
- Configure sudo access: allow `devsecops` group to run all commands without password

---

## Container & Orchestration Tasks

### Task 8: Docker Installation & Configuration (ls_8.yml)
Install and configure Docker:
- Install Docker CE using the appropriate package manager
- Start and enable Docker service
- Add user `{{ docker_user }}` to the docker group
- Create Docker daemon configuration file at `/etc/docker/daemon.json` with:
  - Log driver: json-file
  - Max log size: 10m
  - Max log files: 3
  - Storage driver: overlay2
- Restart Docker service to apply configuration
- Pull the following Docker images: `nginx:latest`, `alpine:latest`, `ubuntu:22.04`
- Save Docker version information to `/var/log/docker_version.txt`

### Task 9: Kubernetes Cluster Preparation (ls_9.yml)
Prepare nodes for Kubernetes cluster:
- Disable swap permanently (comment out swap entries in `/etc/fstab` and run `swapoff -a`)
- Load kernel modules: `br_netfilter`, `overlay`
- Set sysctl parameters:
  - `net.bridge.bridge-nf-call-iptables = 1`
  - `net.bridge.bridge-nf-call-ip6tables = 1`
  - `net.ipv4.ip_forward = 1`
- Install container runtime (containerd)
- Configure containerd with default configuration
- Install kubeadm, kubelet, and kubectl version `{{ k8s_version }}`
- Start and enable kubelet service
- Save node preparation status to `/var/log/k8s_prep_status.json`

### Task 10: Container Registry Setup (ls_10.yml)
Deploy a private Docker registry:
- Create directory `/opt/docker-registry` with subdirectories: `data`, `certs`, `auth`
- Generate htpasswd file at `/opt/docker-registry/auth/htpasswd` with user `{{ registry_user }}` and password `{{ registry_password }}`
- Deploy Docker registry container with:
  - Name: `private-registry`
  - Image: `registry:2`
  - Port mapping: 5000:5000
  - Volume mounts for data, certs, and auth
  - Environment variables for authentication
  - Restart policy: always
- Test registry by pushing a test image
- Save registry configuration to `/opt/docker-registry/config.yml`

---

## CI/CD Pipeline Tasks

### Task 11: Jenkins Installation (ls_11.yml)
Install and configure Jenkins:
- Add Jenkins repository and GPG key
- Install Jenkins and Java (OpenJDK 11 or 17)
- Start and enable Jenkins service
- Wait for Jenkins to be ready (check port 8080)
- Retrieve initial admin password from `/var/lib/jenkins/secrets/initialAdminPassword`
- Save the password to `/tmp/jenkins_initial_password.txt`
- Install Jenkins plugins using jenkins-cli:
  - git
  - docker-workflow
  - pipeline-stage-view
  - ansible
- Create Jenkins job directory structure at `/var/lib/jenkins/jobs/{{ project_name }}`
- Set proper ownership (jenkins:jenkins) for all Jenkins directories

### Task 12: GitLab Runner Setup (ls_12.yml)
Install and register GitLab Runner:
- Add GitLab Runner repository
- Install gitlab-runner package
- Register runner with:
  - GitLab URL: `{{ gitlab_url }}`
  - Registration token: `{{ runner_token }}`
  - Runner name: `{{ runner_name }}`
  - Executor: docker
  - Default Docker image: `alpine:latest`
  - Tags: `docker`, `devsecops`, `{{ environment }}`
- Configure concurrent jobs: `{{ concurrent_jobs }}`
- Enable and start gitlab-runner service
- Create runner configuration backup at `/etc/gitlab-runner/config.toml.backup`
- Set up log rotation for runner logs

### Task 13: Artifact Repository (ls_13.yml)
Deploy Nexus Repository Manager:
- Create nexus user and group
- Create directories: `/opt/nexus`, `/opt/sonatype-work`
- Download and extract Nexus OSS version `{{ nexus_version }}`
- Configure Nexus to run as nexus user
- Set JVM options in `nexus.vmoptions`:
  - Xms: `{{ nexus_min_heap }}`
  - Xmx: `{{ nexus_max_heap }}`
- Create systemd service file for Nexus
- Start and enable Nexus service
- Wait for Nexus to be ready (port 8081)
- Retrieve initial admin password
- Save Nexus configuration to `/opt/nexus/config_backup.json`

---

## Monitoring & Logging Tasks

### Task 14: Prometheus Setup (ls_14.yml)
Install and configure Prometheus:
- Create prometheus user and group
- Create directories: `/etc/prometheus`, `/var/lib/prometheus`
- Download Prometheus version `{{ prometheus_version }}`
- Create Prometheus configuration file at `/etc/prometheus/prometheus.yml` with:
  - Global scrape interval: 15s
  - Scrape configs for: prometheus itself, node_exporter on `{{ target_hosts }}`
- Create systemd service file for Prometheus
- Start and enable Prometheus service
- Install and configure node_exporter on target hosts
- Create alerting rules file at `/etc/prometheus/alerts.yml` for:
  - High CPU usage (>80%)
  - High memory usage (>85%)
  - Disk space low (<10%)
- Save Prometheus targets to `/etc/prometheus/targets.json`

### Task 15: ELK Stack Deployment (ls_15.yml)
Deploy Elasticsearch, Logstash, and Kibana:
- Add Elastic repository and GPG key
- Install Elasticsearch version `{{ elk_version }}`
- Configure Elasticsearch at `/etc/elasticsearch/elasticsearch.yml`:
  - Cluster name: `{{ cluster_name }}`
  - Node name: `{{ node_name }}`
  - Network host: `{{ network_host }}`
  - Discovery seed hosts: `{{ seed_hosts }}`
- Start and enable Elasticsearch service
- Install and configure Logstash with pipeline for syslog input
- Install and configure Kibana
- Configure Kibana to connect to Elasticsearch
- Create index patterns for: `logstash-*`, `filebeat-*`
- Save ELK configuration summary to `/var/log/elk_config.json`

### Task 16: Grafana Dashboard Setup (ls_16.yml)
Install Grafana and configure dashboards:
- Add Grafana repository
- Install Grafana
- Start and enable Grafana service
- Configure Grafana datasources:
  - Prometheus at `{{ prometheus_url }}`
  - Elasticsearch at `{{ elasticsearch_url }}`
- Import pre-built dashboards:
  - Node Exporter Full (dashboard ID: 1860)
  - Docker monitoring (dashboard ID: 893)
- Create custom dashboard for application metrics
- Configure alerting with notification channels:
  - Email: `{{ alert_email }}`
  - Slack webhook: `{{ slack_webhook }}`
- Save Grafana API key to `/etc/grafana/api_key.txt`

---

## Security Scanning Tasks

### Task 17: Vulnerability Scanning (ls_17.yml)
Set up vulnerability scanning tools:
- Install Trivy for container image scanning
- Install OWASP Dependency-Check
- Create scan directory at `/opt/security-scans`
- Scan Docker images and save results:
  - Scan `{{ docker_image }}` with Trivy
  - Save results to `/opt/security-scans/trivy_{{ docker_image }}_{{ ansible_date_time.date }}.json`
- Run dependency check on project at `{{ project_path }}`
- Save dependency check report to `/opt/security-scans/dependency_check_{{ ansible_date_time.date }}.html`
- Create summary report combining all scan results
- Send scan results to `{{ security_team_email }}` if vulnerabilities found

### Task 18: Static Code Analysis (ls_18.yml)
Configure SonarQube for code quality:
- Install PostgreSQL database
- Create SonarQube database and user
- Download and install SonarQube version `{{ sonarqube_version }}`
- Configure SonarQube to use PostgreSQL
- Set JVM options for SonarQube
- Create systemd service for SonarQube
- Start and enable SonarQube service
- Wait for SonarQube to be ready (port 9000)
- Change default admin password to `{{ sonar_admin_password }}`
- Install SonarQube plugins: `{{ sonar_plugins }}`
- Create quality gate with rules:
  - Code coverage > 80%
  - Duplicated lines < 3%
  - Critical issues = 0
- Save SonarQube configuration to `/opt/sonarqube/config_backup.json`

### Task 19: Secrets Management (ls_19.yml)
Deploy HashiCorp Vault:
- Download and install Vault version `{{ vault_version }}`
- Create vault user and group
- Create directories: `/etc/vault`, `/var/lib/vault`
- Create Vault configuration file at `/etc/vault/config.hcl`:
  - Storage backend: file at `/var/lib/vault/data`
  - Listener on `{{ vault_address }}:8200`
  - TLS certificate: `{{ vault_tls_cert }}`
  - TLS key: `{{ vault_tls_key }}`
- Create systemd service for Vault
- Start and enable Vault service
- Initialize Vault and save unseal keys to `{{ vault_keys_path }}`
- Unseal Vault using the keys
- Enable audit logging to `/var/log/vault_audit.log`
- Create secret engines: kv-v2 at `secret/`, database at `database/`
- Create policies for different access levels
- Save Vault root token securely to `{{ vault_token_path }}`

---

## Backup & Disaster Recovery Tasks

### Task 20: Automated Backup Solution (ls_20.yml)
Implement automated backup system:
- Install backup tools: rsync, tar, gzip
- Create backup directories: `/backup/daily`, `/backup/weekly`, `/backup/monthly`
- Create backup script at `/usr/local/bin/backup.sh` that:
  - Backs up directories: `{{ backup_sources }}`
  - Creates timestamped archives
  - Compresses with gzip
  - Retains: 7 daily, 4 weekly, 12 monthly backups
- Set script permissions to 0750
- Create cron jobs for:
  - Daily backup at 2 AM
  - Weekly backup on Sunday at 3 AM
  - Monthly backup on 1st at 4 AM
- Configure backup to remote location `{{ backup_remote_host }}:{{ backup_remote_path }}`
- Set up backup verification script
- Create backup log at `/var/log/backup.log`
- Send backup status email to `{{ backup_admin_email }}`

### Task 21: Database Backup & Restore (ls_21.yml)
Automate database backup procedures:
- Install database client tools for: MySQL, PostgreSQL, MongoDB
- Create backup directory `/backup/databases` with subdirectories for each DB type
- Create MySQL backup script:
  - Dump all databases from `{{ mysql_host }}`
  - Use credentials: `{{ mysql_user }}` / `{{ mysql_password }}`
  - Save to `/backup/databases/mysql/mysql_{{ ansible_date_time.date }}.sql.gz`
- Create PostgreSQL backup script:
  - Dump all databases from `{{ postgres_host }}`
  - Use credentials: `{{ postgres_user }}` / `{{ postgres_password }}`
  - Save to `/backup/databases/postgres/postgres_{{ ansible_date_time.date }}.sql.gz`
- Create MongoDB backup script using mongodump
- Set up cron jobs for each database type
- Implement backup rotation (keep last 30 days)
- Create restore test script that validates backups
- Log all backup operations to `/var/log/db_backup.log`

### Task 22: Disaster Recovery Plan (ls_22.yml)
Implement disaster recovery procedures:
- Create DR documentation directory at `/opt/disaster-recovery`
- Generate system inventory report including:
  - All installed packages
  - Running services
  - Network configuration
  - Disk layout and mounts
  - User accounts and groups
- Save inventory to `/opt/disaster-recovery/system_inventory_{{ ansible_date_time.date }}.json`
- Create configuration backup of:
  - `/etc` directory
  - Application configurations from `{{ app_config_paths }}`
  - Database schemas
- Create recovery scripts for:
  - System restoration
  - Service restoration
  - Data restoration
- Test recovery procedures in `{{ test_environment }}`
- Document recovery time objectives (RTO) and recovery point objectives (RPO)
- Save DR plan to `/opt/disaster-recovery/dr_plan.md`

---

## Network & Infrastructure Tasks

### Task 23: Load Balancer Configuration (ls_23.yml)
Configure HAProxy load balancer:
- Install HAProxy
- Create HAProxy configuration at `/etc/haproxy/haproxy.cfg`:
  - Frontend on port 80 and 443
  - Backend servers: `{{ backend_servers }}`
  - Load balancing algorithm: roundrobin
  - Health checks every 5 seconds
  - SSL termination with certificate `{{ ssl_cert_path }}`
- Configure logging to `/var/log/haproxy.log`
- Set up HAProxy stats page on port 8404
- Create firewall rules for HAProxy
- Start and enable HAProxy service
- Test load balancer with curl commands
- Save load balancer configuration to `/etc/haproxy/config_backup.cfg`

### Task 24: VPN Server Setup (ls_24.yml)
Deploy OpenVPN server:
- Install OpenVPN and Easy-RSA
- Initialize PKI at `/etc/openvpn/easy-rsa`
- Generate CA certificate
- Generate server certificate and key
- Generate Diffie-Hellman parameters (2048 bits)
- Create OpenVPN server configuration at `/etc/openvpn/server.conf`:
  - Port: `{{ vpn_port }}`
  - Protocol: udp
  - VPN subnet: `{{ vpn_subnet }}`
  - DNS servers: `{{ vpn_dns_servers }}`
  - Push routes: `{{ vpn_routes }}`
- Configure IP forwarding
- Set up NAT rules for VPN traffic
- Start and enable OpenVPN service
- Generate client configuration template
- Create client certificates for `{{ vpn_clients }}`
- Save client configs to `/etc/openvpn/clients/`

### Task 25: DNS Server Configuration (ls_25.yml)
Set up BIND DNS server:
- Install BIND9
- Create DNS zones directory at `/etc/bind/zones`
- Configure named.conf with:
  - Listen on: `{{ dns_listen_addresses }}`
  - Allow queries from: `{{ dns_allowed_networks }}`
  - Forwarders: `{{ dns_forwarders }}`
- Create forward zone file for `{{ domain_name }}`:
  - SOA record
  - NS records
  - A records for: `{{ dns_a_records }}`
  - CNAME records for: `{{ dns_cname_records }}`
- Create reverse zone file for `{{ reverse_zone }}`
- Configure DNSSEC for zone signing
- Set up zone transfers to secondary DNS `{{ secondary_dns }}`
- Start and enable BIND service
- Test DNS resolution with dig commands
- Save DNS configuration to `/etc/bind/config_backup/`

---

## Compliance & Auditing Tasks

### Task 26: CIS Benchmark Compliance (ls_26.yml)
Implement CIS benchmark controls:
- Run CIS benchmark assessment using OpenSCAP
- Implement Level 1 controls:
  - Ensure filesystem integrity checking (AIDE)
  - Configure system accounting (auditd)
  - Disable unnecessary services
  - Set password policies
  - Configure login banners
- Create compliance report at `/var/log/cis_compliance_{{ ansible_date_time.date }}.html`
- Remediate failed controls automatically where possible
- Document manual remediation steps for remaining controls
- Schedule weekly compliance scans via cron
- Send compliance reports to `{{ compliance_team_email }}`
- Save remediation log to `/var/log/cis_remediation.log`

### Task 27: Audit Logging Configuration (ls_27.yml)
Configure comprehensive audit logging:
- Install and configure auditd
- Create audit rules at `/etc/audit/rules.d/custom.rules` for:
  - File system changes in `/etc`, `/bin`, `/sbin`, `/usr/bin`, `/usr/sbin`
  - User and group modifications
  - Network configuration changes
  - Privileged command execution
  - Successful and failed login attempts
  - Sudo command usage
- Configure audit log rotation:
  - Max log file size: 100MB
  - Number of logs: 10
  - Action on disk full: suspend
- Set up remote log forwarding to `{{ syslog_server }}`
- Create audit report generation script
- Schedule daily audit reports
- Save audit configuration to `/etc/audit/config_backup.conf`

### Task 28: Security Policy Enforcement (ls_28.yml)
Implement security policies with SELinux/AppArmor:
- Check if SELinux or AppArmor is available
- For SELinux systems:
  - Set SELinux to enforcing mode
  - Install policycoreutils-python
  - Create custom policy for application at `{{ app_path }}`
  - Set proper SELinux contexts for application files
  - Configure SELinux booleans: `{{ selinux_booleans }}`
- For AppArmor systems:
  - Enable AppArmor
  - Create AppArmor profile for application
  - Set profile to enforce mode
- Configure file capabilities for required binaries
- Implement mandatory access controls
- Test application functionality with policies enforced
- Save policy configuration to `/etc/security/policy_backup/`
- Create policy violation monitoring script

---

## Advanced Automation Tasks

### Task 29: Multi-Environment Deployment (ls_29.yml)
Deploy application across multiple environments:
- Define environment-specific variables for: dev, staging, production
- Deploy application version `{{ app_version }}` to `{{ target_environment }}`
- Environment-specific configurations:
  - Database connection: `{{ db_host }}_{{ target_environment }}`
  - API endpoints: `{{ api_url }}_{{ target_environment }}`
  - Log level: debug (dev), info (staging), warn (production)
  - Resource limits based on environment
- Create environment-specific configuration files
- Deploy to load balancer pool for the environment
- Run smoke tests after deployment
- Implement blue-green deployment strategy
- Create rollback procedure
- Send deployment notification to `{{ deployment_channel }}`
- Save deployment manifest to `/opt/deployments/{{ target_environment }}_{{ ansible_date_time.date }}.json`

### Task 30: Infrastructure as Code Validation (ls_30.yml)
Validate and test infrastructure code:
- Install validation tools: ansible-lint, yamllint, shellcheck
- Run ansible-lint on all playbooks in `{{ playbook_directory }}`
- Run yamllint on all YAML files
- Check shell scripts with shellcheck
- Validate Terraform configurations if present
- Run syntax check on all Ansible playbooks
- Test playbooks in check mode (dry-run)
- Generate validation report at `/var/log/iac_validation_{{ ansible_date_time.date }}.html`
- Check for:
  - Hardcoded secrets
  - Deprecated modules
  - Best practice violations
  - Security issues
- Create pre-commit hooks for validation
- Save validation results to `/opt/validation/results.json`

---

## Performance & Optimization Tasks

### Task 31: System Performance Tuning (ls_31.yml)
Optimize system performance:
- Install performance monitoring tools: sysstat, iotop, htop
- Configure kernel parameters in `/etc/sysctl.conf`:
  - `vm.swappiness = {{ swappiness_value }}`
  - `net.core.somaxconn = {{ somaxconn_value }}`
  - `net.ipv4.tcp_max_syn_backlog = {{ syn_backlog_value }}`
  - File descriptor limits
- Set resource limits in `/etc/security/limits.conf`:
  - nofile: `{{ max_open_files }}`
  - nproc: `{{ max_processes }}`
- Configure I/O scheduler for disk type
- Disable unnecessary kernel modules
- Configure CPU governor for performance
- Set up performance monitoring with sar
- Create performance baseline report
- Schedule performance data collection
- Save tuning parameters to `/etc/performance/tuning_config.json`

### Task 32: Database Performance Optimization (ls_32.yml)
Optimize database performance:
- For MySQL/MariaDB:
  - Configure my.cnf with optimized settings
  - Set innodb_buffer_pool_size: `{{ innodb_buffer_pool }}`
  - Configure query cache
  - Set max_connections: `{{ max_connections }}`
  - Enable slow query log
- For PostgreSQL:
  - Configure postgresql.conf
  - Set shared_buffers: `{{ shared_buffers }}`
  - Configure work_mem and maintenance_work_mem
  - Enable query logging
  - Configure autovacuum
- Create database performance monitoring script
- Set up index optimization jobs
- Configure connection pooling with PgBouncer/ProxySQL
- Run ANALYZE/VACUUM on tables
- Generate performance report
- Save optimization settings to `/etc/database/optimization_config.json`

---

## Testing & Quality Assurance Tasks

### Task 33: Automated Testing Framework (ls_33.yml)
Set up automated testing infrastructure:
- Install testing frameworks: pytest, selenium, testinfra
- Create test directory structure at `/opt/tests`
- Configure pytest with:
  - Test discovery patterns
  - Coverage reporting
  - JUnit XML output
- Set up Selenium Grid for browser testing:
  - Hub on port 4444
  - Chrome and Firefox nodes
- Create infrastructure tests with testinfra:
  - Verify services are running
  - Check file permissions
  - Validate configurations
  - Test network connectivity
- Create test execution script
- Configure test result reporting
- Set up CI/CD integration for tests
- Schedule nightly test runs
- Save test results to `/opt/tests/results/{{ ansible_date_time.date }}/`

### Task 34: Chaos Engineering Setup (ls_34.yml)
Implement chaos engineering practices:
- Install chaos engineering tools: chaos-mesh or litmus
- Create chaos experiment directory at `/opt/chaos-experiments`
- Define chaos experiments:
  - Pod failure simulation
  - Network latency injection
  - CPU stress testing
  - Memory pressure testing
  - Disk I/O stress
- Create experiment schedules
- Set up monitoring during experiments
- Configure automatic rollback on critical failures
- Create experiment report templates
- Set up alerting for experiment execution
- Document experiment procedures
- Save experiment results to `/opt/chaos-experiments/results/`

---

## Documentation & Reporting Tasks

### Task 35: Automated Documentation Generation (ls_35.yml)
Generate comprehensive system documentation:
- Install documentation tools: ansible-doc, sphinx, mkdocs
- Create documentation directory at `/opt/documentation`
- Generate documentation for:
  - All Ansible playbooks and roles
  - System architecture diagrams
  - Network topology
  - Service dependencies
  - Configuration management
- Create API documentation from code
- Generate runbooks for common operations
- Create troubleshooting guides
- Build searchable documentation site
- Set up automatic documentation updates
- Save documentation to `/opt/documentation/html/`
- Publish documentation to `{{ documentation_server }}`

---

## Bonus Challenge Tasks

### Task 36: Zero-Trust Network Implementation (ls_36.yml)
Implement zero-trust security model:
- Install and configure service mesh (Istio/Linkerd)
- Implement mutual TLS between all services
- Configure identity-based access control
- Set up network policies for pod-to-pod communication
- Implement API gateway with authentication
- Configure certificate rotation
- Set up audit logging for all service communication
- Implement least-privilege access policies
- Create security monitoring dashboard
- Document zero-trust architecture

### Task 37: Multi-Cloud Deployment (ls_37.yml)
Deploy infrastructure across multiple cloud providers:
- Provision resources in AWS, Azure, and GCP
- Configure cross-cloud networking (VPN/VPC peering)
- Implement multi-cloud load balancing
- Set up cross-cloud backup and replication
- Configure unified monitoring across clouds
- Implement cost optimization strategies
- Create disaster recovery across clouds
- Document multi-cloud architecture

### Task 38: GitOps Implementation (ls_38.yml)
Implement GitOps workflow:
- Install ArgoCD or Flux
- Configure Git repository as source of truth
- Set up automatic synchronization
- Implement progressive delivery (canary/blue-green)
- Configure rollback mechanisms
- Set up drift detection and remediation
- Implement policy enforcement with OPA
- Create GitOps workflow documentation

---

## Lab Completion Checklist

After completing all tasks, ensure you have:

- [ ] All playbooks are properly documented with comments
- [ ] Each playbook includes the three required questions answered
- [ ] All playbooks use the `poc_hosts` host group
- [ ] Variables are properly defined and used
- [ ] Error handling is implemented where appropriate
- [ ] Playbooks are idempotent (can be run multiple times safely)
- [ ] All sensitive data uses Ansible Vault or variables
- [ ] Playbooks follow Ansible best practices
- [ ] Each playbook has been tested in a safe environment
- [ ] Documentation is complete and accurate

---

## Additional Resources

- Ansible Documentation: https://docs.ansible.com
- Ansible Galaxy: https://galaxy.ansible.com
- DevSecOps Best Practices: https://www.devsecops.org
- CIS Benchmarks: https://www.cisecurity.org/cis-benchmarks
- OWASP Top 10: https://owasp.org/www-project-top-ten

---

## Tips for Success

1. **Start Simple**: Begin with basic tasks and gradually move to complex ones
2. **Test in Isolation**: Test each playbook in a safe environment before production
3. **Use Version Control**: Keep all playbooks in Git for tracking changes
4. **Document Everything**: Good documentation saves time in troubleshooting
5. **Follow Best Practices**: Use roles, handlers, and proper variable management
6. **Security First**: Never hardcode secrets, always use Ansible Vault
7. **Make it Idempotent**: Ensure playbooks can run multiple times safely
8. **Error Handling**: Implement proper error handling and rollback procedures
9. **Monitor and Log**: Always implement logging and monitoring
10. **Continuous Learning**: Stay updated with latest Ansible features and DevSecOps practices

---

**Good luck with your DevSecOps Ansible journey!**