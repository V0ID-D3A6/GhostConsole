#!/usr/bin/env bash

# ===== COLORS =====
RED='\033[1;31m'
GREEN='\033[1;32m'
CYAN='\033[1;36m'
YELLOW='\033[1;33m'
RESET='\033[0m'

# ===== LOGO =====
logo(){
  echo -e "${CYAN}"
  cat <<'EOF'
   ██████   ██████  ██    ██ ███████ ████████
  ██       ██    ██ ██    ██ ██         ██
  ██   ███ ██    ██ ██    ██ ███████    ██
  ██    ██ ██    ██  ██  ██       ██    ██
   ██████   ██████    ████  ███████    ██

         G H O S T C O N S O L E   P R O
EOF
  echo -e "${RESET}"
}

pause(){ read -p $'\nPress ENTER to continue...' -r; }

# ===== SHOW HELP =====
show_help(){
cat <<EOF
GhostConsole PRO — Usage Help

Usage: ./ghostconsole.sh [option]

Options:
  1    IP Info               — Fetch public IP and basic info
  2    System Info           — Display OS, kernel, architecture, and user
  3    Password Generator    — Generate a random password
  4    Ping Tool             — Test connectivity to a host
  5    Local Network Scan    — Ping sweep on local subnet
  6    Port Scanner          — Scan common TCP ports (1-1024)
  7    Whois Lookup          — Retrieve WHOIS data for a domain/IP
  8    DNS Lookup            — Query DNS records using dig
  9    URL Header Scan       — Fetch HTTP headers for a URL
  10   Random MAC Generator  — Generate a random MAC address
  11   Clear History / Logs  — Clear local Bash history
  0    Exit                  — Quit GhostConsole PRO

Examples:
  ./ghostconsole.sh          — Start interactive menu
  ./ghostconsole.sh --help   — Show this help
EOF
exit 0
}

# ===== CHECK FOR --HELP ARGUMENT =====
if [ "$1" == "--help" ] || [ "$1" == "-h" ]; then
    show_help
fi

# ===== CHECK COMMANDS =====
_require_cmd(){
  command -v "$1" >/dev/null 2>&1 || \
    echo -e "${YELLOW}[!] Warning:${RESET} missing command '$1'"
}
_require_cmd curl
_require_cmd ping
_require_cmd whois
_require_cmd dig

# ===== IP INFO =====
ip_info(){
  curl -s https://ipinfo.io | sed 's/^/    /'
  pause
}

# ===== SYSTEM INFO =====
system_info(){
  uname -a
  pause
}

# ===== PASSWORD GEN =====
password_gen(){
  read -p "Password length: " len
  len=${len:-16}
  tr -dc 'A-Za-z0-9!@#$%^&*()_+-=' </dev/urandom | head -c "$len"
  echo
  pause
}

# ===== PING =====
ping_tool(){
  read -p "Host: " host
  host=${host:-8.8.8.8}

  echo "[*] Press CTRL+C to stop ping"
  echo

  if command -v timeout >/dev/null 2>&1; then
    # Linux / Termux (bez -c)
    timeout 5 ping "$host"
  else
    # Git Bash / Windows (bez -c, bez timeout)
    ping "$host"
  fi

  pause
}



# ===== LOCAL SCAN =====
local_scan(){
  read -p "Base (e.g. 192.168.1): " base
  for i in $(seq 1 254); do
    (ping -c 1 -W 1 "$base.$i" >/dev/null && echo "[+] $base.$i") &
  done
  wait
  pause
}

# ===== PORT SCAN =====
port_scan(){
  read -p "Target: " target
  for port in $(seq 1 1024); do
    (echo >/dev/tcp/$target/$port) >/dev/null 2>&1 && echo "[+] Open $port" &
  done
  wait
  pause
}

# ===== WHOIS =====
whois_lookup(){
  read -p "Domain/IP: " dom
  whois "$dom"
  pause
}

#!/usr/bin/env bash

# ===== COLORS =====
RED='\033[1;31m'
GREEN='\033[1;32m'
CYAN='\033[1;36m'
YELLOW='\033[1;33m'
RESET='\033[0m'

# ===== LOGO =====
logo(){
  echo -e "${CYAN}"
  cat <<'EOF'
   ██████   ██████  ██    ██ ███████ ████████
  ██       ██    ██ ██    ██ ██         ██
  ██   ███ ██    ██ ██    ██ ███████    ██
  ██    ██ ██    ██  ██  ██       ██    ██
   ██████   ██████    ████  ███████    ██

         G H O S T C O N S O L E   P R O
EOF
  echo -e "${RESET}"
}

pause(){ read -p $'\nPress ENTER to continue...' -r; }

# ===== CHECK COMMANDS =====
_require_cmd(){
  command -v "$1" >/dev/null 2>&1 || \
    echo -e "${YELLOW}[!] Warning:${RESET} missing command '$1'"
}
_require_cmd curl
_require_cmd ping
_require_cmd whois
_require_cmd dig

# ===== IP INFO =====
ip_info(){
  curl -s https://ipinfo.io | sed 's/^/    /'
  pause
}

# ===== SYSTEM INFO =====
system_info(){
  uname -a
  pause
}

# ===== PASSWORD GEN =====
password_gen(){
  read -p "Password length: " len
  len=${len:-16}
  tr -dc 'A-Za-z0-9!@#$%^&*()_+-=' </dev/urandom | head -c "$len"
  echo
  pause
}

# ===== PING =====
ping_tool(){
  read -p "Host: " host
  ping -c 4 "${host:-8.8.8.8}"
  pause
}

# ===== LOCAL SCAN =====
local_scan(){
  read -p "Base (e.g. 192.168.1): " base
  for i in $(seq 1 254); do
    (ping -c 1 -W 1 "$base.$i" >/dev/null && echo "[+] $base.$i") &
  done
  wait
  pause
}

# ===== PORT SCAN =====
port_scan(){
  read -p "Target: " target
  for port in $(seq 1 1024); do
    (echo >/dev/tcp/$target/$port) >/dev/null 2>&1 && echo "[+] Open $port" &
  done
  wait
  pause
}

# ===== WHOIS =====
whois_lookup(){
  read -p "Domain/IP: " dom
  whois "$dom"
  pause
}

# ===== DNS =====
dns_lookup(){
  read -p "Domain: " dom
  dig "$dom" ANY +short
  pause
}

# ===== HEADERS =====
header_scan(){
  read -p "URL: " url
  curl -I "$url"
  pause
}

# ===== MAC GEN =====
mac_gen(){
  printf "02:%02X:%02X:%02X:%02X:%02X\n" \
  $((RANDOM%256)) $((RANDOM%256)) $((RANDOM%256)) $((RANDOM%256)) $((RANDOM%256))
  pause
}

# ===== CLEAR LOGS =====
clear_logs(){
  rm -f ~/.bash_history 2>/dev/null
  history -c 2>/dev/null
  echo "Done."
  pause
}

# ===== MENU LOOP =====
while true; do
  clear
  logo
  echo "[1] IP Info"
  echo "[2] System Info"
  echo "[3] Password Generator"
  echo "[4] Ping Tool"
  echo "[5] Local Network Scan"
  echo "[6] Port Scanner"
  echo "[7] Whois"
  echo "[8] DNS Lookup"
  echo "[9] URL Headers"
  echo "[10] Random MAC"
  echo "[11] Clear Logs"
  echo "[0] Exit"
  echo

  read -p "Select option: " opt

  case "$opt" in
    1) ip_info ;;
    2) system_info ;;
    3) password_gen ;;
    4) ping_tool ;;
    5) local_scan ;;
    6) port_scan ;;
    7) whois_lookup ;;
    8) dns_lookup ;;
    9) header_scan ;;
    10) mac_gen ;;
    11) clear_logs ;;
    0) exit 0 ;;
    *) echo "Invalid option"; sleep 1 ;;
  esac
done

