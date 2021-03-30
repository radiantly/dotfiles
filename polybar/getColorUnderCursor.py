#!/usr/bin/python3

import sys
from time import sleep
from signal import signal, pause, SIGUSR1

import gi
from Xlib import display

gi.require_version("Gdk", "3.0")

from gi.repository import Gdk

colored = False

def sigHandle(sig, frame):
    global colored
    colored = not colored

def pixelAt(x, y):
    w = Gdk.get_default_root_window()
    pb = Gdk.pixbuf_get_from_window(w, x, y, 1, 1)
    return pb.get_pixels()

signal(SIGUSR1, sigHandle)

while True:
    data = display.Display().screen().root.query_pointer()._data
    px = pixelAt(data["root_x"], data["root_y"]).hex()
    print(f"%{{F#{px if colored else '55d5c4a1'}}}#{px}%{{F-}}" if len(sys.argv) > 1 else f"#{px}", flush=True)
