#!/usr/bin/env python3
"""
bt_tools.py
- BLE scan using bleak (cross-platform)
- show discovered devices + RSSI
- pair hint (platform-specific)
"""
import asyncio, sys, os
LOG = os.path.expanduser("~/.v0id_logs/bt.log")
os.makedirs(os.path.dirname(LOG), exist_ok=True)

def write_log(txt):
    with open(LOG, "a") as f:
        f.write(txt + "\n")

async def scan_ble(duration=5):
    try:
        from bleak import BleakScanner
    except Exception:
        print("bleak not installed. pip install bleak")
        return
    print(f"Scanning BLE devices for {duration}s...")
    devices = await BleakScanner.discover(timeout=duration)
    for d in devices:
        print(f"{d.address} | {d.name} | RSSI: {d.rssi}")
        write_log(f"{d.address} {d.name} rssi={d.rssi}")

def menu():
    while True:
        print("\nV0ID3A6 GhostConsole — Bluetooth Tools")
        print("1) BLE scan (5s)")
        print("2) BLE scan (30s)")
        print("3) Show log")
        print("0) Exit")
        c = input("Choice: ").strip()
        if c == "1":
            asyncio.run(scan_ble(5))
        elif c == "2":
            asyncio.run(scan_ble(30))
        elif c == "3":
            if os.path.exists(LOG):
                print(open(LOG).read()[-2000:])
            else:
                print("No bt log.")
        elif c == "0":
            break
        else:
            print("Invalid")

if __name__ == "__main__":
    menu()
