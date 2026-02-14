#!/usr/bin/env bash
# logger.sh - session logging and secure notes wrapper (BASH)
set -e
LOG_DIR="$HOME/.ghostconsole"
SESSION_LOG="$LOG_DIR/session.log"
NOTES_DIR="$LOG_DIR/notes"
mkdir -p "$LOG_DIR" "$NOTES_DIR"

timestamp() { date -u +"%Y-%m-%dT%H:%M:%SZ"; }

usage() {
  cat <<US
Logger - usage:
  --view             View last 500 log lines
  --tail N           Show last N lines
  --notes            Launch notes helper (create/read)
US
}

# simple encrypted notes using openssl (AES-256) - passphrase-based
create_note() {
  read -p "Note title: " title
  read -s -p "Set passphrase: " pass; echo
  read -p "Note content (single line): " content
  outf="$NOTES_DIR/${title}.enc"
  echo "$content" | openssl enc -aes-256-cbc -pbkdf2 -salt -pass pass:"$pass" -out "$outf"
  echo "Saved: $outf"
  echo "[$(timestamp)] [NOTES] Created $title" >> "$SESSION_LOG"
}

read_note() {
  read -p "Note title to read: " title
  outf="$NOTES_DIR/${title}.enc"
  if [ ! -f "$outf" ]; then echo "Not found."; return; fi
  read -s -p "Passphrase: " pass; echo
  openssl enc -d -aes-256-cbc -pbkdf2 -pass pass:"$pass" -in "$outf" 2>/dev/null || echo "Decryption failed."
  echo "[$(timestamp)] [NOTES] Read $title" >> "$SESSION_LOG"
}

view_logs() {
  if [ ! -f "$SESSION_LOG" ]; then echo "No logs yet."; return; fi
  tail -n 500 "$SESSION_LOG"
}

if [ "$1" = "--view" ]; then
  view_logs
  exit 0
fi

if [ "$1" = "--tail" ]; then
  tail -n "${2:-100}" "$SESSION_LOG"
  exit 0
fi

if [ "$1" = "--notes" ]; then
  echo "Notes:"
  echo "1) Create note"
  echo "2) Read note"
  echo "0) Exit"
  read -p "Choice: " c
  case "$c" in
    1) create_note ;;
    2) read_note ;;
    *) echo "Exit" ;;
  esac
  exit 0
fi

usage
