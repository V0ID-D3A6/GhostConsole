#!/usr/bin/env bash
# V0ID3A6 GhostConsole - Bash launcher (light)
set -e
REPO_DIR="$(cd "$(dirname "$0")" && pwd)"
LOG_DIR="$HOME/.v0id_logs"
mkdir -p "$LOG_DIR"
STEALTH=0

for arg in "$@"; do
  case "$arg" in
    --stealth) STEALTH=1 ;;
    --python) exec python3 "$REPO_DIR/ghost.py" "$@" ;;
  esac
done

cat <<'BANNER'

 _   _  ____  ___ ___   ___  _   _ ____ ___ _   _ ___ _   _ 
| | | |/ ___|/ _ \_ _| / _ \| | | / ___|_ _| \ | |_ _| \ | |
| | | | |  _| | | | | | | | | | | \___ \| ||  \| || ||  \| |
| |_| | |_| | |_| | | | |_| | |_| |___) | || |\  || || |\  |
 \___/ \____|\___/___| \__\_\\___/|____/___|_| \_|___|_| \_|
 
V0ID3A6 GhostConsole

BANNER

PS3="Choose an option: "
options=("Wi-Fi Tools" "Bluetooth Tools" "System Info" "Secure Notes" "View Session Logs" "Exit")
select opt in "${options[@]}"; do
  case $REPLY in
    1)
      python3 "$REPO_DIR/modules/wifi_tools.py"
      ;;
    2)
      python3 "$REPO_DIR/modules/bt_tools.py"
      ;;
    3)
      if command -v neofetch >/dev/null 2>&1; then neofetch; else uname -a; df -h; free -m; fi
      ;;
    4)
      python3 "$REPO_DIR/modules/secure_notes.py"
      ;;
    5)
      python3 "$REPO_DIR/modules/logger.py" --view
      ;;
    6) break ;;
    *) echo "Invalid option" ;;
  esac
  break
done
