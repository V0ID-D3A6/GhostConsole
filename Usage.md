# GhostConsole PRO — Usage Guide

This document explains how to use **GhostConsole PRO** and describes each available tool in detail.

---

## Starting the Tool

From the project directory:

```bash
./ghostconsole.sh
```

You will see an interactive menu. Select an option by typing the number and pressing **ENTER**.

---

## Menu Overview

```
[1]  IP Info
[2]  System Info
[3]  Password Generator
[4]  Ping Tool
[5]  Local Network Scan (Ping Sweep)
[6]  Port Scanner (1–1024)
[7]  Whois Lookup
[8]  DNS Lookup
[9]  URL Header Scan
[10] Random MAC Generator
[11] Clear History / Logs
[0]  Exit
```

---

## Tool Descriptions

### [1] IP Info

**Purpose:** Retrieve information about your public IP address.

**What it does:**

* Queries the `ipinfo.io` service
**Typical use:**

* Checking current public IP
* Basic OSINT reconnaissance

---

### [2] System Info

**Purpose:** Display basic system information.

**Information shown:**

* Operating system
* Kernel version
* CPU architecture
* Current user

---

### [3] Password Generator

**Purpose:** Generate a random password using system entropy.

**How to use:**

1. Enter desired password length (e.g. `16`)
2. The generated password will be printed to the terminal

**Notes:**

* Uses `/dev/urandom`
* Output is not stored anywhere

---

### [4] Ping Tool

**Purpose:** Test network connectivity to a host.

**How it works:**

* Uses a safe ping mode compatible with Linux, Termux, and Git Bash
* Does not require administrative privileges

**Usage:**

* Enter an IP address or domain
* Press `CTRL+C` to stop the ping if it runs continuously

---

### [5] Local Network Scan (Ping Sweep)

**Purpose:** Discover active hosts in a local subnet.

**How to use:**

* Enter a network base (example: `192.168.1`)
* The tool will ping `.1` through `.254`

**Output:**

* Lists hosts that respond to ICMP

**Warning:**

* Generates multiple ICMP requests

---

### [6] Port Scanner (1–1024)

**Purpose:** Scan common TCP ports on a target host.

**How it works:**

* Uses Bash `/dev/tcp`
* Scans ports `1–1024`

**Usage:**

* Enter target IP or domain
* Open ports will be displayed

---

### [7] Whois Lookup

**Purpose:** Retrieve WHOIS registration data.

**Usage:**

* Enter a domain name or IP address

**Typical information returned:**

* Registrar
* Organization
* Contact details (if public)

---

### [8] DNS Lookup

**Purpose:** Query DNS records for a domain.

**How it works:**

* Uses `dig`

**Returned data:**

* A, AAAA, MX, NS, and other available records

---

### [9] URL Header Scan

**Purpose:** Retrieve HTTP response headers from a URL.

**Usage:**

* Enter a full URL including `http://` or `https://`

**Use cases:**

* Server identification
* Security header inspection

---

### [10] Random MAC Generator

**Purpose:** Generate a random MAC address.

**Details:**

* Locally administered
* Unicast address

**Important:**

* This tool does NOT change the MAC address on your system

---

### [11] Clear History / Logs

**Purpose:** Clear local Bash history.

**What it does:**

* Removes `~/.bash_history`
* Clears history for the current shell session

---

## Exit

Select `[0] Exit` to safely close GhostConsole PRO.

---

## Legal Notice

Use this tool **only on systems and networks you own or have explicit permission to test**. The author is not responsible for misuse.

---

**Author:** V0ID-D3A6

GhostConsole PRO © 2026

