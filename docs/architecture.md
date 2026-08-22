# Tinta Lab Architecture

This document describes the current architecture of the Tinta Lab infrastructure environment.

The lab is designed to reproduce common scenarios found in IT infrastructure, technical support and systems administration environments.

---

## Overview

The environment currently runs on VMware and contains three main virtual machines:

- FortiGate VM
- Windows Server 2022
- Ubuntu Server

The FortiGate acts as the gateway and firewall for the internal laboratory network.

The Windows Server provides Active Directory Domain Services and DNS.

The Ubuntu Server is used for Linux administration, services and troubleshooting exercises.

---

## Current Topology

```
                    VMware Host
                         |
                    FortiGate VM
                 Gateway / Firewall
                    10.10.10.1
                         |
              -----------------------
              |                     |
              |                     |
        TINTA-DC01             Ubuntu Server
        10.10.10.10            10.10.10.20
              |                     |
     Windows Server 2022       Linux Services
       AD DS / DNS
```

---

## Network

Internal network:

```10.10.10.0/24```

Default gateway:

```10.10.10.1```

Domain:

```tintalab.lab```

Addressing

| Device | IP Address  |  Function  |
|---|---|---|
|  FortiGate  |  `10.10.10.1`  |  Gateway / Firewall / DHCP  |
|  TINTA-DC01 |	`10.10.10.10` |	Domain Controller / DNS  |
|  Ubuntu Server  |  `10.10.10.20`  |  Linux services  |

All documented addresses belong to an isolated laboratory environment.

---

## FortiGate

Current role:

- Default gateway
- Firewall
- Traffic control
- Network routing
- NAT
- Internal network segmentation
- Connectivity testing

The FortiGate VM is positioned between the laboratory network and external connectivity.

---

## Windows Server

Host:

```TINTA-DC01```

Operating system:

Windows Server 2022

Current roles:

- Active Directory Domain Services
- Domain Controller
- DNS Server
- User and group administration
- Group Policy
- Remote administration
- Windows Server troubleshooting

Domain:

```tintalab.lab```

---

## Ubuntu Server

IP address:

```10.10.10.20```

Current purposes:

- Linux administration
- SSH access
- Service management
- Networking exercises
- Resource monitoring
- Log analysis
- Web services
- Shell scripting

Additional services may be introduced as the laboratory evolves.

---

## Administrative Access

The environment is administered through different protocols depending on the system.

Windows Server:

- PowerShell
- Remote Desktop
- Windows Remote Management
- SSH

Linux:

- SSH
- Local shell

Firewall:

- FortiGate administrative interface
- SSH

---

## Troubleshooting Approach

Problems inside the lab are investigated using an evidence-based process:

```
Symptom
   ↓
Scope
   ↓
System state
   ↓
Network state
   ↓
Service state
   ↓
Logs
   ↓
Hypothesis
   ↓
Validation
   ↓
Resolution
   ↓
Documentation
```

The objective is to understand why a problem occurs rather than only applying a predefined solution.

---

## Evolution

The architecture is intentionally small and modular.

Future components may be introduced according to the technical scenario being studied, including:

- Additional Linux servers
- Databases
- Monitoring services
- Backup services
- Additional virtualization scenarios
- High availability concepts
- Automation
