#!/usr/bin/env python3
"""
wifi_tools.py
- scan nearby APs (uses nmcli/iwlist/termux-wifi-scaninfo if available)
- show current connection info
- show saved networks (NetworkManager or wpa_supplicant)
"""
import os, subprocess, json, shutil
LOG = os.path.expanduser("~/.v0id_logs/wifi.log")
os.makedirs(os.path.dirname(LOG), exist_ok=True)

def write_log(txt):
    with open(LOG, "a") as f:
        f.write(txt + "\n")

def nmcli_scan():
    try:
        out = subprocess.check_output(["nmcli", "-f", "SSID,BSSID,CHAN,SIGNAL,SECURITY", "device", "wifi", "list"], stderr=subprocess.DEVNULL).decode()
        print(out)
        write_log("nmcli_scan:\n" + out)
        return True
    except Exception:
        return False

def iwlist_scan():
    try:
        out = subprocess.check_output(["sudo", "iwlist", "scan"], stderr=subprocess.DEVNULL).decode()
        print(out[:2000])
        write_log("iwlist_scan:\n" + out[:2000])
        return True
    except Exception:
        return False

def termux_scan():
    try:
        out = subprocess.check_output(["termux-wifi-scaninfo"], stderr=subprocess.DEVNULL).decode()
        data = json.loads(out)
        for ap in data.get("results", []):
            print(f"{ap.get('SSID')}  BSSID:{ap.get('BSSID')}  RSSI:{ap.get('level')}  frequency:{ap.get('frequency')}")
        write_log("termux_scan")
        return True
    except Exception:
        return False

def current_connection():
    # try nmcli first
    try:
        out = subprocess.check_output(["nmcli", "-t", "-f", "ACTIVE,SSID,BSSID,DEVICE,IP4", "connection", "show", "--active"]).decode()
        print("Active connections:")
        print(out)
        write_log("current_connection:\n" + out)
    except:
        # fallback to iwconfig / termux
        try:
            out = subprocess.check_output(["iwconfig"]).decode()
            print(out)
            write_log("iwconfig:\n" + out)
        except:
            print("Unable to determine current connection.")

def saved_networks_nmcli():
    try:
        out = subprocess.check_output(["nmcli", "-g", "NAME,UUID,DEVICE", "connection", "show"], stderr=subprocess.DEVNULL).decode()
        print("Saved networks (NetworkManager):")
        print(out)
        write_log("saved_networks:\n" + out)
    except:
        print("No NetworkManager data.")

def menu():
    while True:
        print("\nV0ID3A6 GhostConsole — Wi-Fi Tools")
        print("1) Scan nearby APs")
        print("2) Show current connection")
        print("3) Show saved networks")
        print("4) Export scan to file")
        print("0) Exit")
        c = input("Choice: ").strip()
        if c == "1":
            if not nmcli_scan():
                if not termux_scan():
                    iwlist_scan()
        elif c == "2":
            current_connection()
        elif c == "3":
            saved_networks_nmcli()
        elif c == "4":
            fname = os.path.expanduser("~/v0id_wifi_scan.txt")
            print("Writing last scan to", fname)
            write_log("exported scan to " + fname)
            # do a scan and write summary
            try:
                out = subprocess.check_output(["nmcli", "-f", "SSID,BSSID,CHAN,SIGNAL,SECURITY", "device", "wifi", "list"]).decode()
                open(fname, "w").write(out)
                print("Saved.")
            except:
                print("Failed to export.")
        elif c == "0":
            break
        else:
            print("Invalid")

if __name__ == "__main__":
    menu()
