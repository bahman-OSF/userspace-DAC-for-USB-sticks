#!/bin/bash

DEVPATH="$1"
SYS="/sys$DEVPATH"
LOGFILE="/var/log/usb_blocker.log"
WHITELIST="/etc/usb_whitelist.conf"

log() {
    echo "$(date '+%Y-%m-%d %H:%M:%S')  $1" >> "$LOGFILE"
}

# Ensure interface class file exists
if [[ ! -f "$SYS/bInterfaceClass" ]]; then
    exit 0
fi

CLASS=$(cat "$SYS/bInterfaceClass")

# Only act on Mass Storage interfaces (08h)
if [[ "$CLASS" != "08" ]]; then
    exit 0
fi

# Parent device (one directory up)
PARENT=$(dirname "$SYS")

VID=$(cat "$PARENT/idVendor" 2>/dev/null)
PID=$(cat "$PARENT/idProduct" 2>/dev/null)
SERIAL=$(cat "$PARENT/serial" 2>/dev/null)

log "----------------------------------------"
log "USB Mass Storage detected:"
log "Interface Path : $SYS"
log "Parent Path    : $PARENT"
log "Vendor ID      : $VID"
log "Product ID     : $PID"
[[ -n "$SERIAL" ]] && log "Serial         : $SERIAL"

# Check whitelist
if [[ -f "$WHITELIST" ]] && grep -q "^$VID$" "$WHITELIST"; then
    log "Device ALLOWED (Vendor ID whitelisted)"
    exit 0
fi

# Block the device
if [[ -w "$PARENT/authorized" ]]; then
    echo 0 > "$PARENT/authorized"
    log "Device BLOCKED (authorized=0)"
else
    log "Cannot block device: no permission"
fi

log "----------------------------------------"

