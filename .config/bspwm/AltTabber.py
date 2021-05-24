import sys
import os
import subprocess
import socket

from Xlib import X, XK, display
from Xlib.ext import record
from Xlib.protocol import rq

# Only allow one instance of this file to run
try:
    sock = socket.socket(socket.AF_UNIX, socket.SOCK_STREAM)
    sock.bind("\x00xlibTabGrabLock")  # <-- Abstract unix socket
except socket.error as e:
    print(f"Process already running {e.args} - Exiting now.")
    sys.exit()

# local_dpy = display.Display()
record_dpy = display.Display()


def lookup_keysym(keysym):
    for name in dir(XK):
        if name[:3] == "XK_" and getattr(XK, name) == keysym:
            return name[3:]
    return "[%d]" % keysym


Tabbed = False
Shifted = set()
Supered = False
Changed = False


def record_callback(reply):
    global Tabbed, Supered, Changed
    if reply.category != record.FromServer:
        return
    if reply.client_swapped:
        print("* received swapped protocol data, cowardly ignored")
        return
    if not len(reply.data) or reply.data[0] < 2:
        # not an event
        return

    data = reply.data
    while len(data):
        event, data = rq.EventField(None).parse_binary_value(data, record_dpy.display, None, None)

        if event.type not in [X.KeyPress, X.KeyRelease]:
            continue

        # pr = event.type == X.KeyPress and "Press" or "Release"

        # Key codes:
        # 23 Tab
        # 64 Alt_L
        # 50 Shift_L
        # 62 Shift_R
        # 133 Super_L

        # keysym = local_dpy.keycode_to_keysym(event.detail, 0)
        # # print (event)
        # print(event.detail)
        # if not keysym:
        #     print("KeyCode%s" % pr, event.detail)
        # else:
        #     print("KeyStr%s" % pr, lookup_keysym(keysym))

        # if event.type == X.KeyPress and keysym == XK.XK_Escape:
        #     local_dpy.record_disable_context(ctx)
        #     local_dpy.flush()
        #     return

        if event.type == X.KeyPress:
            if event.detail == 133:
                Supered = True
            if event.detail == 64:
                Tabbed = True
            if event.detail in [50, 62]:
                Shifted.add(event.detail)

            if event.detail == 23 and (Tabbed or Supered):
                subprocess.run(["bspc", "wm", "-h", "off"])
                if Tabbed:
                    subprocess.run(["bspc", "node", "newer" if Shifted else "older", "-f"])
                elif Supered:
                    subprocess.run(
                        ["bspc", "node", ("newer" if Shifted else "older") + ".local", "-f"]
                    )
                Changed = True
                subprocess.run(["bspc", "wm", "-h", "on"])

        else:
            if event.detail in [64, 133]:
                if Changed:
                    subprocess.run(["bspc", "node", "-f"])
                    Changed = False
                if event.detail == 64:
                    Tabbed = False
                else:
                    Supered = False
            if event.detail in Shifted:
                Shifted.remove(event.detail)


# Check if the extension is present
if not record_dpy.has_extension("RECORD"):
    print("RECORD extension not found")
    sys.exit(1)
r = record_dpy.record_get_version(0, 0)
# print("RECORD extension version %d.%d" % (r.major_version, r.minor_version))

# Create a recording context; we only want key and mouse events
ctx = record_dpy.record_create_context(
    0,
    [record.AllClients],
    [
        {
            "core_requests": (0, 0),
            "core_replies": (0, 0),
            "ext_requests": (0, 0, 0, 0),
            "ext_replies": (0, 0, 0, 0),
            "delivered_events": (0, 0),
            "device_events": (X.KeyPress, X.KeyRelease),
            "errors": (0, 0),
            "client_started": False,
            "client_died": False,
        }
    ],
)

# Enable the context; this only returns after a call to record_disable_context,
# while calling the callback function in the meantime
record_dpy.record_enable_context(ctx, record_callback)

# Finally free the context
record_dpy.record_free_context(ctx)
