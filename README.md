# Tinta Lab

Personal hands-on infrastructure laboratory focused on systems administration, networking, virtualization, monitoring and automation.

The purpose of this repository is to document practical infrastructure scenarios, configurations, troubleshooting procedures and automation developed in a controlled lab environment.

---

## 🚀 Current Milestone — Linux Operations / Tinta Status v0.6

The current milestone focuses on Linux operations, automation and troubleshooting.

A lightweight status dashboard is generated automatically on `TINTA-LNX01` using Bash and served by Nginx.

Current implementation includes:

- Hostname, uptime and Nginx service state collection
- Memory metrics collected with `free`
- Filesystem metrics collected with `df`
- Text processing with pipes, `grep`, `tail` and `awk`
- Disk usage classification with Bash conditional logic
- Automated execution with `cron`
- Application and cron log handling
- Deployment using a dedicated Linux group and least-privilege permissions
- `setgid` directory behavior for group inheritance
- HTTP health validation with `curl`
- Exit-code based success and failure handling
- Controlled failure scenarios for troubleshooting practice

### Operational Flow

```text
cron
  ↓
gerar-status.sh
  ↓
collect system metrics
  ↓
generate staging HTML
  ↓
deploy to Nginx web root
  ↓
HTTP validation
  ↓
SUCCESS / ERROR log
```

### Failure Scenarios Reproduced
- Shell script without execute permission
- Cron execution failure
- Deployment permission denied
- Difference between file and directory permissions
- Nginx stopped / TCP connection refused
- HTTP health-check failure

---

## 🎯 Objectives

Tinta Lab is used to develop practical experience in:

- Windows Server administration
- Linux administration
- Active Directory
- DNS
- TCP/IP networking
- Firewall and routing
- Remote administration
- Virtualization
- Monitoring
- Infrastructure troubleshooting
- PowerShell and Shell automation

---

## 🏗️ Current Architecture

The environment currently runs on VMware and includes:

| Component | Role |
|---|---|
| Windows Server 2022 | Domain Controller / DNS |
| Ubuntu Server | Linux services and administration |
| FortiGate VM | Firewall / routing |
| VMware | Virtualization platform |

---

## 🌐 Network

Main lab network:

`10.10.10.0/24`

Domain:

`tintalab.lab`

Current addressing:

| Host | IP Address | Role |
|---|---|---|
| FortiGate VM | `10.10.10.1` | Gateway / Firewall / DHCP |
| TINTA-DC01 | `10.10.10.10` | Windows Server 2022 / AD DS / DNS |
| TINTA-LNX01 | `10.10.10.20` | Ubuntu Server 22.04 LTS / Linux Services |

> The addresses documented in this repository belong only to the isolated laboratory environment.

---

## 🪟 Windows Server

Current environment:

- Windows Server 2022
- Active Directory Domain Services
- DNS
- Domain Controller
- User and group administration
- Group Policy
- Remote administration
- Windows services
- Network diagnostics
- Performance analysis
- PowerShell administration

---

## 🐧 Linux

Current and planned exercises include:

- SSH administration
- Linux users, groups and supplementary groups
- File and directory permission models
- `chmod`, `chown`, `setgid` and least privilege
- Service management with systemd
- Cron scheduling and troubleshooting
- stdout, stderr and exit codes
- Log inspection with `journalctl`
- Resource inspection with `free`, `df`, `ps` and `ss`
- Text processing with pipes, `grep`, `awk`, `head` and `tail`
- Bash scripting
- Nginx administration
- HTTP health checks with `curl`
- Controlled incident reproduction and diagnosis

---

## 🔥 Networking & Firewall

Topics practiced in the environment include:

- IPv4 addressing
- Subnetting
- Default gateways
- DNS resolution
- Routing
- NAT
- Firewall policies
- Network segmentation
- Connectivity troubleshooting

---

## 📊 Monitoring

Monitoring topics include:

- Zabbix
- Host availability
- Network monitoring
- Resource utilization
- Service health
- Incident investigation

---

## ⚙️ Automation

Automation exercises include:

- PowerShell
- Shell Script
- Windows administration
- Network diagnostics
- System inventory
- Operational checks

---

## 📚 Repository Structure

The repository will grow as the laboratory evolves.

```
tinta-lab/
├── README.md
├── docs/
│   ├── architecture.md
│   ├── windows-server/
│   ├── linux/
│   ├── networking/
│   └── monitoring/
├── scripts/
│   ├── powershell/
│   └── bash/
└── diagrams/
```
---

## 🧪 Lab Philosophy

The objective of Tinta Lab is not only to execute commands, but to understand the troubleshooting process:

```
Symptom
   ↓
Observation
   ↓
Evidence
   ↓
Hypothesis
   ↓
Validation
   ↓
Resolution
   ↓
Documentation
```

This approach is used to reproduce situations commonly found in infrastructure and technical support environments.

---

## 🔐 Security

This repository contains only laboratory information.

No production credentials, private keys, passwords, API tokens or confidential company configurations are stored in this repository.

Sensitive information from real environments is never published here.

---

## 🚧 Current Status

Tinta Lab is an evolving project.

Current focus:

- Windows Server administration
- Linux administration
- Network troubleshooting
- Monitoring
- Remote administration
- Infrastructure automation

Future additions may include:

- Additional Linux servers
- Database administration
- Backup environments
- High availability concepts
- Infrastructure monitoring improvements
- Additional automation

---

## 👤 Author

**Madson Rocha**

IT Infrastructure & Support

Linux | Windows Server | Networking | Monitoring | Automation
