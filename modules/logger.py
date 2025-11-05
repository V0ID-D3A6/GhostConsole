#!/usr/bin/env python3
"""
Logger module: save session entries and view logs
"""
import os, argparse, datetime, subprocess, sys
LOG_DIR = os.path.expanduser("~/.v0id_logs")
os.makedirs(LOG_DIR, exist_ok=True)
SESSION_LOG = os.path.join(LOG_DIR, "session.log")

def log_entry(tag, text):
    ts = datetime.datetime.utcnow().isoformat() + "Z"
    entry = f"[{ts}] [{tag}] {text}\n"
    with open(SESSION_LOG, "a") as f:
        f.write(entry)

def view_logs():
    if not os.path.exists(SESSION_LOG):
        print("No session logs found.")
        return
    with open(SESSION_LOG, "r") as f:
        lines = f.readlines()
    for i, l in enumerate(lines[-500:], start=1):  # show last 500 lines
        print(f"{i:04d}: {l.strip()}")

def tail_logs(n=100):
    try:
        data = subprocess.check_output(["tail", "-n", str(n), SESSION_LOG]).decode()
        print(data)
    except Exception as e:
        print("Tail not available or error:", e)

if __name__ == "__main__":
    parser = argparse.ArgumentParser()
    parser.add_argument("--view", action="store_true")
    parser.add_argument("--tail", type=int, default=0)
    args = parser.parse_args()
    if args.view:
        view_logs()
    elif args.tail:
        tail_logs(args.tail)
    else:
        # example log entry
        log_entry("INFO", "Logger module called without args")
        print("Wrote sample entry to log.")
