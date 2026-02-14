#!/usr/bin/env bash
# bt.sh - bluetooth tools (BASH) with fallbacks
set -e
LOG_DIR="$HOME/.ghostconsole"
BTLOG="$LOG_DIR/bt.log"
mkdir -p "$LOG_DIR"

timestamp(){ date -u +"%Y-%m-%dT%H:%M:%SZ"; }
log(){ echo "[$(timestamp)] $*" >> "$BTLOG"; }

bluetoothctl_scan(){
  if command -v bluetoothctl >/dev/null 2>&1; then
    echo "Starting bluetoothctl scan (10s)..."
    bluetoothctl --timeout 10 scan on >/dev/null 2>&1 &
    sleep 10
    bluetoothctl devices
    log "bluetoothctl scan done"
    return 0
  fi
  return 1
}

hcitool_scan(){
  if command -v hcitool >/dev/null 2>&1; then
    echo "hcitool scan (classic devices)..."
    sudo hcitool scan || hcitool scan
    log "hcitool scan done"
    return 0
  fi
  return 1
}

bleak_scan_hint(){
  # python bleak fallback
  if command -v python3 >/dev/null 2>&1; then
    python3 - <<'PY'
try:
    from bleak import BleakScanner
except Exception:
    print("Bleak not installed (pip install bleak)")
    raise SystemExit
import asyncio
async def run():
    devs = await BleakScanner.discover(timeout=5)
    for d in devs:
        print(d.address, d.name, "RSSI=", d.rssi)
asyncio.run(run())
PY
    return 0
  fi
  return 1
}

paired(){
  if command -v bluetoothctl >/dev/null 2>&1; then
    bluetoothctl paired-devices
  else
    echo "Cannot list paired devices (bluetoothctl missing)."
  fi
}

menu(){
  while true; do
    echo ""
    echo "GhostConsole — Bluetooth Tools"
    echo "1) Scan BLE (python bleak fallback)"
    echo "2) Scan Classic (hcitool / bluetoothctl)"
    echo "3) Show paired devices"
    echo "4) View BT log"
    echo "0) Back"
    read -p "Choice: " c
    case "$c" in
      1)
        if ! bleak_scan_hint; then
          echo "Bleak not available or Python missing."
        fi
        ;;
      2)
        if ! bluetoothctl_scan; then
          if ! hcitool_scan; then
            echo "No bluetooth scan tool available."
          fi
        fi
        ;;
      3) paired ;;
      4) [ -f "$BTLOG" ] && tail -n 200 "$BTLOG" || echo "No BT logs." ;;
      0) break ;;
      *) echo "Invalid" ;;
    esac
  done
}

menu
