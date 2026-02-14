#!/usr/bin/env bash
# wifi.sh - simple Wi-Fi utilities with multiple fallbacks
set -e
REPO_DIR="$(cd "$(dirname "$0")/.." && pwd)"
LOG_DIR="$HOME/.ghostconsole"
WLOG="$LOG_DIR/wifi.log"
mkdir -p "$LOG_DIR"

timestamp(){ date -u +"%Y-%m-%dT%H:%M:%SZ"; }
log(){ echo "[$(timestamp)] $*" >> "$WLOG"; }

nmcli_scan(){
  if command -v nmcli >/dev/null 2>&1; then
    nmcli -f SSID,BSSID,CHAN,SIGNAL,SECURITY device wifi list
    log "nmcli scan done"
    return 0
  fi
  return 1
}

iwlist_scan(){
  if command -v iwlist >/dev/null 2>&1; then
    sudo iwlist scan 2>/dev/null || iwlist scan 2>/dev/null
    log "iwlist scan done"
    return 0
  fi
  return 1
}

termux_scan(){
  if command -v termux-wifi-scaninfo >/dev/null 2>&1; then
    termux-wifi-scaninfo | sed -n '1,200p'
    log "termux-wifi-scaninfo done"
    return 0
  fi
  return 1
}

current_conn(){
  if command -v nmcli >/dev/null 2>&1; then
    nmcli -t -f ACTIVE,SSID,BSSID,DEVICE,IP4 connection show --active
  elif command -v iwconfig >/dev/null 2>&1; then
    iwconfig 2>/dev/null | sed -n '1,200p'
  else
    echo "No supported tool for current connection info."
  fi
}

saved_networks(){
  if command -v nmcli >/dev/null 2>&1; then
    nmcli -g NAME,UUID,TYPE connection show
  else
    echo "Saved networks listing not supported on this system (requires NetworkManager)."
  fi
}

export_scan(){
  out="$HOME/ghost_wifi_scan_$(date +%Y%m%d%H%M%S).txt"
  if nmcli_scan >/dev/null 2>&1; then
    nmcli -f SSID,BSSID,CHAN,SIGNAL,SECURITY device wifi list > "$out"
    echo "Saved to $out"
    log "Exported scan to $out"
  elif termux_scan >/dev/null 2>&1; then
    termux-wifi-scaninfo > "$out"
    echo "Saved to $out"
    log "Exported termux scan to $out"
  else
    echo "No supported scanner to export."
  fi
}

menu(){
  while true; do
    echo ""
    echo "GhostConsole — Wi-Fi Tools"
    echo "1) Scan nearby APs"
    echo "2) Show current connection"
    echo "3) Show saved networks"
    echo "4) Export last scan to file"
    echo "5) View Wi-Fi log"
    echo "0) Back"
    read -p "Choice: " c
    case "$c" in
      1)
        if ! nmcli_scan; then
          if ! termux_scan; then
            iwlist_scan || echo "No Wi-Fi scanner available."
          fi
        fi
        ;;
      2) current_conn ;;
      3) saved_networks ;;
      4) export_scan ;;
      5) [ -f "$WLOG" ] && tail -n 200 "$WLOG" || echo "No wifi logs." ;;
      0) break ;;
      *) echo "Invalid" ;;
    esac
  done
}

menu
