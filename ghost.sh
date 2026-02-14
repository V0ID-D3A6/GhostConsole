
#!/usr/bin/env bash
# GhostConsole - Bash launcher
set -e
REPO_DIR="$(cd "$(dirname "$0")" && pwd)"
LOG_DIR="$HOME/.ghostconsole"
SESSION_LOG="$LOG_DIR/session.log"
mkdir -p "$LOG_DIR"

# record action helper
log() {
  local tag="$1"; shift
  local txt="$*"
  echo "[$(date -u +"%Y-%m-%dT%H:%M:%SZ")] [$tag] $txt" >> "$SESSION_LOG"
}

# parse args
STEALTH=0
for a in "$@"; do
  case "$a" in
    --stealth) STEALTH=1 ;;
  esac
done

# banner
cat <<'BANNER'
  ____  _               _   ____                      
 / ___|| |__   ___  ___| |_| ___|  ___  ___  ___  ___ 
 \___ \| '_ \ / _ \/ __| __|___ \ / _ \/ __|/ _ \/ __|
  ___) | | | |  __/ (__| |_ ___) |  __/\__ \  __/\__ \
 |____/|_| |_|\___|\___|\__|____/ \___||___/\___||___/
 
GhostConsole
BANNER

while true; do
  echo ""
  echo "GhostConsole — Main Menu"
  echo "1) Wi-Fi Tools"
  echo "2) Bluetooth Tools"
  echo "3) System Info"
  echo "4) Secure Notes"
  echo "5) View Session Logs"
  echo "0) Exit"
  read -p "Choose an option [0-5]: " CH
  case "$CH" in
    1)
      log "UI" "Entered Wi-Fi Tools"
      bash "$REPO_DIR/modules/wifi.sh" $([ $STEALTH -eq 1 ] && echo "--stealth")
      ;;
    2)
      log "UI" "Entered Bluetooth Tools"
      bash "$REPO_DIR/modules/bt.sh" $([ $STEALTH -eq 1 ] && echo "--stealth")
      ;;
    3)
      log "UI" "Show System Info"
      if command -v neofetch >/dev/null 2>&1; then neofetch; else uname -a; df -h; free -m || true; fi
      ;;
    4)
      log "UI" "Secure Notes"
      bash "$REPO_DIR/modules/logger.sh" --notes
      ;;
    5)
      log "UI" "View Session Logs"
      bash "$REPO_DIR/modules/logger.sh" --view
      ;;
    0)
      log "UI" "Exit"
      echo "Bye."
      exit 0
      ;;
    *)
      echo "Invalid selection."
      ;;
  esac
done
