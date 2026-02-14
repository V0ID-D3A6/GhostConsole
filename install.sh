#!/usr/bin/env bash
set -e
REPO_DIR="$HOME/GhostConsole"
LOG_DIR="$HOME/.ghostconsole"
mkdir -p "$REPO_DIR" "$LOG_DIR"

echo "Installing GhostConsole to $REPO_DIR ..."
# If running installer from inside project, copy files (rsync if available)
if [ -f "./ghost.sh" ]; then
  echo "Detected local files — copying into $REPO_DIR ..."
  if command -v rsync >/dev/null 2>&1; then
    rsync -a . "$REPO_DIR"/ --exclude '.git'
  else
    cp -r . "$REPO_DIR"/
  fi
fi

PLATFORM="linux"
if [ -n "$TERMUX_VERSION" ]; then
  PLATFORM="termux"
fi

echo "Platform detected: $PLATFORM"

if [ "$PLATFORM" = "termux" ]; then
  echo "Installing packages (Termux) if available..."
  pkg update -y >/dev/null 2>&1 || true
  pkg install -y python curl git nmap pv termux-api >/dev/null 2>&1 || true
else
  echo "Installing recommended packages (Linux)..."
  if command -v apt >/dev/null 2>&1; then
    sudo apt update -y >/dev/null 2>&1 || true
    sudo apt install -y git nmap iw wireless-tools wpasupplicant pv >/dev/null 2>&1 || true
  fi
fi

# link/alias
if [ "$PLATFORM" = "termux" ]; then
  SHELL_RC="$HOME/.bashrc"
  [ -f "$HOME/.zshrc" ] && SHELL_RC="$HOME/.zshrc"
  grep -qxF "alias ghost='$REPO_DIR/ghost.sh'" "$SHELL_RC" 2>/dev/null || echo "alias ghost='$REPO_DIR/ghost.sh'" >> "$SHELL_RC"
  echo "Alias 'ghost' added to $SHELL_RC (reload shell or run: source $SHELL_RC)"
else
  if [ -w "/usr/local/bin" ]; then
    sudo ln -sf "$REPO_DIR/ghost.sh" /usr/local/bin/ghost || true
    echo "Symlink /usr/local/bin/ghost created."
  else
    echo "Add $REPO_DIR to PATH or create symlink manually: sudo ln -s $REPO_DIR/ghost.sh /usr/local/bin/ghost"
  fi
fi

chmod +x "$REPO_DIR/ghost.sh" "$REPO_DIR/modules/"*.sh 2>/dev/null || true

echo ""
echo "Installation complete. Run 'ghost' or '$REPO_DIR/ghost.sh'"
