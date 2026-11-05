@echo off
setlocal
cd /d "%~dp0"

set "FASTBOOT=fastboot"
if exist "%~dp0..\platform-tools\fastboot.exe" set "FASTBOOT=%~dp0..\platform-tools\fastboot.exe"

echo ============================================
echo  JioFi M2 - Full Upgrade to PEG_M2_B38.2
echo ============================================
echo.
"%FASTBOOT%" devices
echo.
echo [1/6] Flashing system...
"%FASTBOOT%" erase system
"%FASTBOOT%" flash system mtd13_system.img

echo [2/6] Flashing boot...
"%FASTBOOT%" erase boot
"%FASTBOOT%" flash boot mtd6_boot.img

echo [3/6] Flashing modem...
"%FASTBOOT%" erase modem
"%FASTBOOT%" flash modem mtd9_modem.img

echo [4/6] Flashing modm2...
"%FASTBOOT%" erase modm2
"%FASTBOOT%" flash modm2 mtd10_modm2.img

echo [5/6] Flashing systm2...
"%FASTBOOT%" erase systm2
"%FASTBOOT%" flash systm2 mtd14_systm2.img

echo [6/6] Flashing bot2...
"%FASTBOOT%" erase bot2
"%FASTBOOT%" flash bot2 mtd7_bot2.img

echo.
echo ============================================
echo  Flash complete! Rebooting device...
echo ============================================
"%FASTBOOT%" reboot
pause
