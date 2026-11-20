#!/usr/bin/env python3
"""Stream YubiKey touch-request state as JSON lines for the Noctalia widget.

Connects to the socket exposed by yubikey-touch-detector.service and prints one
JSON object per state change. The detector sends fixed 5-byte frames:
GPG_1 / GPG_0, U2F_1 / U2F_0, MAC_1 / MAC_0 (1 = touch requested, 0 = done).
"""

import json
import os
import socket
import sys
import time

RUNTIME_DIR = os.environ.get("XDG_RUNTIME_DIR", f"/run/user/{os.getuid()}")
SOCKET_PATH = os.path.join(RUNTIME_DIR, "yubikey-touch-detector.socket")
FRAME_LEN = 5
LABELS = {"GPG": "GPG", "U2F": "U2F", "MAC": "HMAC"}


def emit(active):
    if active:
        names = [LABELS[k] for k in ("GPG", "U2F", "MAC") if k in active]
        payload = {
            "text": "touch",
            "alt": "waiting",
            "class": "yubikey-waiting",
            "tooltip": "YubiKey waiting for touch: " + ", ".join(names),
        }
        print(json.dumps(payload), flush=True)
    else:
        # Plain "false" (not a JSON object) so the widget hides itself.
        print("false", flush=True)


def watch():
    sock = socket.socket(socket.AF_UNIX, socket.SOCK_STREAM)
    sock.connect(SOCKET_PATH)
    active = set()
    buf = b""
    with sock:
        while True:
            chunk = sock.recv(64)
            if not chunk:
                return
            buf += chunk
            changed = False
            while len(buf) >= FRAME_LEN:
                frame, buf = buf[:FRAME_LEN].decode("ascii", "replace"), buf[FRAME_LEN:]
                name, _, state = frame.partition("_")
                if name not in LABELS:
                    continue
                if state == "1":
                    changed |= name not in active
                    active.add(name)
                elif state == "0":
                    changed |= name in active
                    active.discard(name)
            if changed:
                emit(active)


def main():
    emit(set())
    while True:
        try:
            watch()
        except (OSError, ConnectionError) as exc:
            print(f"yubikey-touch: {exc}", file=sys.stderr)
        emit(set())
        time.sleep(2)


if __name__ == "__main__":
    main()
