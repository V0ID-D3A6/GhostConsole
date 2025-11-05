#!/usr/bin/env bash
set -e
REPO_DIR="$HOME/V0ID3A6-GhostConsole"
BRANCH="main"

echo "Installing V0ID3A6 GhostConsole..."

# detect Termux
if [ -n "$TERMUX_VERSION" ]; then
  PLATFORM="termux"
else
  PLATFORM="linux"
fi

mkdir -p "$REPO_DIR"

echo "Copying files to $REPO_DIR (if you used manual download, ensure files are present)..."

# If running from within repo folder, just ensure perms and deps
# Try to install dependencies where possible
if [ "$PLATFORM" = "termux" ]; then
  echo "Detected Termux. Installing recommended packages..."
  pkg update -y >/dev/null 2>&1 || true
  pkg install -y python git curl nmap pv termux-api >/dev/null 2>&1 || true
else
  echo "Detected Linux. Attempting to install recommended packages (apt)..."
  if command -v apt >/dev/null 2>&1; then
    sudo apt update -y >/dev/null 2>&1 || true
    sudo apt install -y python3 python3-pip git nmap pv wireless-tools iw >/dev/null 2>&1 || true
  fi
fi

# python deps
if command -v python3 >/dev/null 2>&1; then
  echo "Installing python dependencies..."
  python3 -m pip install --user --upgrade pip >/dev/null 2>&1 || true
  python3 -m pip install --user cryptography psutil bleak >/dev/null 2>&1 || true
fi

# create alias or symlink if files present
if [ -f "./ghost.sh" ]; then
  # assume installer run from repo root -> move files to REPO_DIR
  rsync -a --exclude .git ./ "$REPO_DIR"/
fi

chmod +x "$REPO_DIR/ghost.sh" "$REPO_DIR/ghost.py" || true

if [ "$PLATFORM" = "termux" ]; then
  SHELL_RC="$HOME/.bashrc"
  if [ -f "$HOME/.zshrc" ]; then
    SHELL_RC="$HOME/.zshrc"
  fi
  grep -qxF "alias ghost='$REPO_DIR/ghost.sh'" "$SHELL_RC" || echo "alias ghost='$REPO_DIR/ghost.sh'" >> "$SHELL_RC"
  echo "Alias 'ghost' added to $SHELL_RC. Run: source $SHELL_RC"
else
  if [ -w "/usr/local/bin" ]; then
    sudo ln -sf "$REPO_DIR/ghost.sh" /usr/local/bin/ghost || true
    echo "Symlink /usr/local/bin/ghost created."
  else
    echo "Add $REPO_DIR to your PATH or create a symlink manually."
  fi
fi

echo ""
echo "V0ID3A6 GhostConsole installed to: $REPO_DIR"
echo "Run: ghost  (bash) or python3 $REPO_DIR/ghost.py (python)"
