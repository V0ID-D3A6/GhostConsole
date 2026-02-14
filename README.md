# GhostConsole 

## Installation & Usage

### Requirements

GhostConsole PRO is a Bash-based CLI tool. It works on:

* **Linux (including Kali Linux)**
* **Termux (Android, no root required)**
* **Git Bash (Windows)**

Minimal required packages (some features are optional):

* `bash`
* `curl`
* `ping`
* `whois`
* `dig`

On Debian/Kali-based systems:

```bash
sudo apt update && sudo apt install -y curl iputils-ping whois dnsutils
```

On Termux:

```bash
pkg update && pkg install -y bash curl iputils whois dnsutils
```

### Installation

Clone the repository:

```bash
git clone https://github.com/V0ID-D3A6/GhostConsole.git
cd GhostConsole
```

Make the script executable:

```bash
chmod +x ghostconsole.sh
```

---

### Run

Start the tool with:

```bash
./ghostconsole.sh
```

(Optional) Syntax check:

```bash
bash -n ghostconsole.sh
```

---

## Project Description

**GhostConsole PRO** is a single-file Bash CLI utility designed for fast **system**, **network**, and **OSINT-related** tasks. The tool focuses on portability, simplicity, and cross-platform compatibility.

It is built to run consistently across Linux, Termux, and Git Bash without requiring root access.

⚠️ **Disclaimer:**
This project is intended for educational and administrative purposes only. The author is not responsible for misuse. Use the tool **only on systems and networks you own or have explicit permission to test**.

---

## Menu & Tool Usage

### [1] IP Info

**Description:** Fetches information about your public IP address.

**How it works:**

* Queries the `ipinfo.io` API
* Displays IP address, geolocation, ASN, and ISP information

**Use cases:**

* Quick IP verification
* Basic OSINT reconnaissance

---

### [2] System Info

**Description:** Displays basic system information.

**Information shown:**

* Operating system
* Kernel version
* Architecture
* Current user

---

### [3] Password Generator

**Description:** Generates random passwords using system entropy.

**How to use:**

1. Enter desired password length (e.g. `16`)
2. The tool outputs a random password

**Use cases:**

* Account creation
* Security testing

---

### [4] Ping Tool

**Description:** Tests network connectivity to a host.

**Notes:**

* Works on Linux, Termux, and Git Bash
* Uses a safe mode to avoid administrative privilege issues

---

### [5] Local Network Scan (Ping Sweep)

**Description:** Scans a local subnet for active hosts using ICMP.

**How to use:**

* Enter network base (e.g. `192.168.1`)
* Hosts responding to ping will be listed

---

### [6] Port Scanner (1–1024)

**Description:** Simple TCP port scanner.

**Details:**

* Scans ports `1–1024`
* Uses Bash `/dev/tcp`

---

### [7] Whois Lookup

**Description:** Retrieves WHOIS information for a domain or IP address.

---

### [8] DNS Lookup

**Description:** Performs DNS queries using `dig`.

---

### [9] URL Header Scan

**Description:** Fetches HTTP response headers from a given URL.

---

### [10] Random MAC Generator

**Description:** Generates a random locally administered MAC address.

**Note:**

* This tool does NOT change the MAC address on the system

---
# V0ID3A6 GhostConsole (PRO)

V0ID3A6 GhostConsole is a professional, modular terminal toolkit for Termux and Linux.
It focuses on diagnostics and device tooling: advanced Wi-Fi utilities, Bluetooth scanning, encrypted notes, and session logging.

**Display name:** `GhostConsole`

## Features (v1.1.0)
- Advanced Wi-Fi scanning (nmcli / iwlist / termux support)
- Wi-Fi: show current connection, saved networks, export scan
- Bluetooth (BLE) scanning with RSSI (bleak)
- Session logging and interactive log viewer
- Secure encrypted notes (scrypt + Fernet)
- Installer for Termux and Debian/Ubuntu-like distributions

## Quick install
```bash
# If you have curl and git:
git clone https://github.com/V0ID-D3A6/GhostConsole.git
cd GhostConsole
chmod +x ghost.sh install.sh
./install.sh
./ghost.sh
