#!/bin/bash
echo "============================================"
echo " JioFi M2 - Flash All (Stock Recovery)"
echo " Firmware: PEG_M2_B38.2"
echo "============================================"
echo ""
echo "WARNING: This will erase and flash all main partitions."
echo "Make sure your device is in fastboot mode."
echo ""
read -p "Press Enter to continue or Ctrl+C to cancel..."

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
cd "$SCRIPT_DIR"

echo ""
echo "[1/6] Flashing system..."
fastboot erase system
fastboot flash system mtd13_system.img

echo "[2/6] Flashing boot..."
fastboot erase boot
fastboot flash boot mtd6_boot.img

echo "[3/6] Flashing modem..."
fastboot erase modem
fastboot flash modem mtd9_modem.img

echo "[4/6] Flashing modm2..."
fastboot erase modm2
fastboot flash modm2 mtd10_modm2.img

echo "[5/6] Flashing systm2..."
fastboot erase systm2
fastboot flash systm2 mtd14_systm2.img

echo "[6/6] Flashing bot2..."
fastboot erase bot2
fastboot flash bot2 mtd7_bot2.img

echo ""
echo "============================================"
echo " Flash complete! Rebooting device..."
echo "============================================"
fastboot reboot
