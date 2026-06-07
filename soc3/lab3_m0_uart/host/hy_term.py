#!/usr/bin/env python3
# --=========================================================================--
# Copyright (c) 2025-2026 DSAL, Hanyang University. All rights reserved
#                     DSAL Confidential Proprietary
#  ----------------------------------------------------------------------------
# FILE NAME       : hy_term.py
# DEPARTMENT      : Digital System Architecture Lab.
# AUTHOR          : Ji-Hoon Kim
# AUTHOR'S EMAIL  : jhoonkim@hanyang.ac.kr
# -----------------------------------------------------------------------------
# RELEASE HISTORY
# VERSION DATE         AUTHOR         DESCRIPTION
# 1.0     2026-04-02   Ji-Hoon Kim    Simple serial terminal for HY-SoC
# -----------------------------------------------------------------------------

"""hy_term.py — Simple Serial Terminal for HY-SoC

Connects to the FPGA UART port and displays received data in real time.
Keyboard input is forwarded to the FPGA.

Usage:
  python3 hy_term.py /dev/ttyUSB0              # default 115200 baud
  python3 hy_term.py /dev/ttyUSB0 -b 9600      # custom baud rate

  Press Ctrl+] to exit.

Requirements:
  pip install pyserial
"""

import argparse
import sys
import threading

try:
    import serial
except ImportError:
    print("Error: pyserial not installed. Run: pip install pyserial")
    sys.exit(1)


def rx_loop(ser, stop_event):
    """Read from serial port and print to stdout."""
    while not stop_event.is_set():
        data = ser.read(256)
        if data:
            text = data.decode('ascii', errors='replace')
            sys.stdout.write(text)
            sys.stdout.flush()


def main():
    parser = argparse.ArgumentParser(
        description='HY-SoC Simple Serial Terminal')
    parser.add_argument('port', help='Serial port (e.g., /dev/ttyUSB0)')
    parser.add_argument('-b', '--baud', type=int, default=115200,
                        help='Baud rate (default: 115200)')
    args = parser.parse_args()

    ser = serial.Serial(args.port, args.baud, timeout=0.1)
    print(f"Connected to {args.port} @ {args.baud} baud")
    print("Press Ctrl+] to exit.\n")

    stop_event = threading.Event()
    rx_thread = threading.Thread(target=rx_loop, args=(ser, stop_event),
                                 daemon=True)
    rx_thread.start()

    try:
        import tty
        import termios
        old_settings = termios.tcgetattr(sys.stdin)
        tty.setraw(sys.stdin.fileno())
        try:
            while True:
                ch = sys.stdin.read(1)
                if ch == '\x1d':  # Ctrl+]
                    break
                ser.write(ch.encode('ascii'))
        finally:
            termios.tcsetattr(sys.stdin, termios.TCSADRAIN, old_settings)
    except Exception: # termios 에러 무시하고 윈도우용 모드로 진입
        # Fallback for non-Unix
        try:
            while True:
                line = input()
                ser.write((line + '\r\n').encode('ascii'))
        except (EOFError, KeyboardInterrupt):
            pass

    stop_event.set()
    rx_thread.join(timeout=1.0)
    ser.close()
    print("\nDisconnected.")


if __name__ == '__main__':
    main()
