
##USB Blocker is a lightweight security tool for Linux systems that prevents unauthorized USB mass‑storage devices (like flash drives or external hard disks) from being mounted.
It enforces a default‑deny policy: all USB storage devices are blocked unless their Vendor ID is explicitly whitelisted.

## Installation

1. Clone the repository:
   ```bash
   git clone https://github.com/bahman/usb-blocker.git
   cd usb-blocker

2. Copy the script:
   ```bash
   sudo cp usb_blocker.sh /usr/local/bin/
   sudo chmod +x /usr/local/bin/usb_blocker.sh
   
3. Copy the udev rule:
   ```bash
   sudo cp 99-usb-block.rules /etc/udev/rules.d/
4. Reload udev rules:
   ```bash
   sudo udevadm control --reload-rules
   sudo udevadm trigger 
