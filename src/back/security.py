import hashlib
import binascii
import secrets

def generate_salt():
    return secrets.token_bytes(16)

def find_hash(pw,salt):
    dk = hashlib.pbkdf2_hmac('sha256', pw.encode('utf-8'), salt, 100000 , 32)
    return dk
