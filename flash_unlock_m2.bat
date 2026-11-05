@echo off
setlocal
cd /d "%~dp0"

set "FASTBOOT=fastboot"
if exist "%~dp0..\platform-tools\fastboot.exe" set "FASTBOOT=%~dp0..\platform-tools\fastboot.exe"

echo =======================================================
echo  JioFi 2 M2 (PEG_M2_D04) - Fastboot Bootloader + Modem
echo =======================================================
echo.
"%FASTBOOT%" devices
echo.
echo [1/3] Flashing Unlocked Bootloader (aboot_jiofi2_m2.img)...
"%FASTBOOT%" flash aboot aboot_jiofi2_m2.img

echo.
echo [2/3] Erasing and Flashing Primary Modem Partition...
"%FASTBOOT%" erase modem
"%FASTBOOT%" flash modem modem_jiofi2_m2.img

echo.
echo [3/3] Erasing and Flashing Secondary Modem Partition (modm2)...
"%FASTBOOT%" erase modm2
"%FASTBOOT%" flash modm2 modem_jiofi2_m2.img

echo.
echo =======================================================
echo  Flash complete! Rebooting device...
echo =======================================================
"%FASTBOOT%" reboot
pause
