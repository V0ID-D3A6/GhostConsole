#!/usr/bin/env python3
import os, getpass, base64
from cryptography.hazmat.primitives.kdf.scrypt import Scrypt
from cryptography.hazmat.backends import default_backend
from cryptography.fernet import Fernet

SALT_FILE = os.path.expanduser("~/.v0id_salt")
NOTES_DIR = os.path.expanduser("~/.v0id_notes")
os.makedirs(NOTES_DIR, exist_ok=True)

def derive_key(password: str, salt: bytes) -> bytes:
    kdf = Scrypt(salt=salt, length=32, n=2**14, r=8, p=1, backend=default_backend())
    key = kdf.derive(password.encode())
    return base64.urlsafe_b64encode(key)

def init_salt():
    if not os.path.exists(SALT_FILE):
        salt = os.urandom(16)
        open(SALT_FILE, "wb").write(salt)
    return open(SALT_FILE, "rb").read()

def create_note():
    salt = init_salt()
    pwd = getpass.getpass("Set a password for notes: ")
    key = derive_key(pwd, salt)
    f = Fernet(key)
    title = input("Note title: ").strip()
    content = input("Note content: ").strip()
    token = f.encrypt(content.encode())
    with open(os.path.join(NOTES_DIR, f"{title}.note"), "wb") as fh:
        fh.write(token)
    print("Note saved.")

def read_note():
    salt = init_salt()
    pwd = getpass.getpass("Enter password: ")
    key = derive_key(pwd, salt)
    f = Fernet(key)
    title = input("Title to read: ").strip()
    path = os.path.join(NOTES_DIR, f"{title}.note")
    if not os.path.exists(path):
        print("Note not found.")
        return
    token = open(path, "rb").read()
    try:
        print("Note content:\n", f.decrypt(token).decode())
    except:
        print("Decryption failed. Wrong password?")

if __name__ == "__main__":
    a = input("Create (c) or Read (r)? ").lower().strip()
    if a.startswith("c"):
        create_note()
    else:
        read_note()
