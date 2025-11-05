# V0ID3A6 GhostConsole (PRO)

V0ID3A6 GhostConsole is a professional, modular terminal toolkit for Termux and Linux.
It focuses on diagnostics and device tooling: advanced Wi-Fi utilities, Bluetooth scanning, encrypted notes, and session logging.

**Display name:** `V0ID3A6 GhostConsole`

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
git clone https://github.com/YOURUSER/V0ID3A6-GhostConsole.git
cd V0ID3A6-GhostConsole
./install.sh
