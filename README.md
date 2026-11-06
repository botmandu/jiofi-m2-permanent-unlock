# JioFi 2 (Model M2 - Pegasus) Permanent SIM Unlock & Firmware Upgrade Guide

Complete step-by-step guide, flashing scripts, companion Android app, and firmware files to unlock the **Reliance JioFi 2 (Model M2 / `PEG_M2_D04`)** portable 4G Wi-Fi hotspot router so it works with **any 4G LTE SIM card** (Ncell, NTC, Airtel, Vi, BSNL, etc.).

---

## ⚠️ Critical Hardware Note: **M2** vs. **M2S**

Before flashing anything, check your device's hardware model in the web admin panel (`http://192.168.1.1/st_dev.w.xml` or `http://jiofi.local.html/st_dev.w.xml`) or on the label under the battery:

| Feature | **JioFi M2 (Pegasus)** *(This Repo)* | **JioFi M2S** |
| :--- | :--- | :--- |
| **Model String** | `M2` (`hwver: PEG_M2_D04`) | `M2S` |
| **Stock Firmware** | `PEG_M2_B23` / `PEG_M2_B34` / `PEG_M2_B38.2` | `PEG_M2S_B04` / `PEG_M2S_B11` |
| **NAND Flash Geometry** | **4KB Page + 128B OOB** | **2KB Page + 64B OOB** |
| **Supported LTE Bands** | **B3 (1800 MHz), B5 (850 MHz), B40 (2300 MHz)** | B3, B5, B40 |

> **Warning:** Do **NOT** flash `M2S` firmware (`aboot_jiofi2_m2s.img` / `modem_jiofi2_m2s.img`) onto an **M2** device. Because the M2 uses 4KB NAND pages and a different partition table, flashing M2S images onto an M2 will immediately brick the device into Qualcomm EDL 9008 mode.

---

## 📦 Files Included in This Repository & Releases

| File | Size | MD5 Checksum | Description |
| :--- | :--- | :--- | :--- |
| `aboot_jiofi2_m2.img` | `524,288` bytes | `fd4ec36625504ce0b311bbf33b327ce4` | Unlocked bootloader (`aboot`) for JioFi M2 |
| `modem_jiofi2_m2.img` | `37,748,736` bytes | `7b643dcfe5a33c09c29da51e4391248b` | SIM-unlocked baseband modem image for JioFi M2 |
| `JioFi_tools_v1.0.5.apk` | `25,551,196` bytes | `a305f98be0e27afebf11459310f8cf60` | Companion Android app to unlock the bootloader and apply userspace routing fixes |
| `jiofi_m2_complete_backup.zip` *(in Releases)* | `521,671,558` bytes | — | Full **`PEG_M2_B38.2`** partition package (`system`, `boot`, `modem`, `modm2`, `systm2`, `bot2`, `aboot`) |
| `flash_all_b38_2.bat` / `.sh` | — | — | Automated Fastboot script to upgrade older M2 firmware (`PEG_M2_B34`) to unlocked `PEG_M2_B38.2` |
| `flash_unlock_m2.bat` | — | — | Standalone Fastboot script to flash `aboot_jiofi2_m2.img` and `modem_jiofi2_m2.img` |

---

## 🛠️ Prerequisites

1. **A JioFi M2 (`PEG_M2_D04`)** with battery charged above 50%.
2. **A Micro-USB data cable** and a PC (Windows, Linux, or macOS) with **Android Platform Tools (`fastboot`)** and **Android/Qualcomm Fastboot USB Drivers** installed.
3. **An Android phone** to run `JioFi_tools_v1.0.5.apk` over Wi-Fi for the initial bootloader unlock.

---

## 🚀 Step-by-Step Unlocking Procedure

### Why Older Firmware (`PEG_M2_B34`) Shows `invalid sim`
On the JioFi M2, SIM locking is enforced in **two** places:
1. **Baseband Modem (`modem` / `modm2` partitions):** Restricts network attachment to Reliance Jio SIMs.
2. **Linux Userspace (`system` partition):** Checks the SIM's Home PLMN (`hplmn_valid`) against Reliance Jio (`4058xx`) and displays `invalid sim` (`<hplmn>0</hplmn>`) on older `PEG_M2_B34` builds even if the modem is unlocked.

Upgrading the device to **`PEG_M2_B38.2`** and flashing the unlocked M2 modem resolves both locks cleanly.

---

### Step 1: Unlock the Bootloader via Android App (`JioFi_tools_v1.0.5.apk`)

On factory firmware (`PEG_M2_B34`), the stock bootloader blocks `fastboot erase` and `fastboot oem unlock`. You must first flash the unlocked bootloader from inside the running OS:

1. Install **`JioFi_tools_v1.0.5.apk`** on an Android phone.
2. While your phone has internet access, open the app once so it caches the required bootloader image.
3. Turn on the JioFi M2 and connect your Android phone to the JioFi M2's Wi-Fi network.
4. In the **JioFi Tools** app, select **JioFi 2 Tools → Unlock Bootloader**.
5. Enter your router's web admin credentials (default: `administrator` / `administrator`) when prompted.
6. Wait for the app to report **Bootloader Flashed / Unlocked** and allow the router to reboot.

---

### Step 2: Boot the JioFi M2 into Fastboot Mode

1. Unplug the USB cable and **power off** the JioFi M2 completely.
2. Press and hold **both the WPS button and the Power button** simultaneously for **3–5 seconds** until the indicator LEDs stay lit.
3. Connect the JioFi M2 to your PC via the Micro-USB data cable.
4. Verify that the device is detected in Fastboot mode:
   ```bat
   fastboot devices
   ```

---

### Step 3: Flash the Full `PEG_M2_B38.2` Unlocked Firmware via Fastboot

1. Download and extract **`jiofi_m2_complete_backup.zip`** from the **Releases** section into a folder on your PC.
2. Run **`flash_all_b38_2.bat`** (Windows) or **`./flash_all_b38_2.sh`** (Linux/macOS), which executes:
   ```bat
   fastboot erase system
   fastboot flash system mtd13_system.img

   fastboot erase boot
   fastboot flash boot mtd6_boot.img

   fastboot erase modem
   fastboot flash modem mtd9_modem.img

   fastboot erase modm2
   fastboot flash modm2 mtd10_modm2.img

   fastboot erase systm2
   fastboot flash systm2 mtd14_systm2.img

   fastboot erase bot2
   fastboot flash bot2 mtd7_bot2.img

   fastboot reboot
   ```
   > **Note on `system` / `systm2` Bad Blocks:** Because `mtd13_system.img` and `mtd14_systm2.img` span the full 384 NAND eraseblocks (`98,304 KB`) and the last ~130 blocks in the UBI image are empty free blocks, `fastboot flash system` may report `FAILED (remote: 'flash write failure')` at the very end if your NAND chip has 1–2 factory bad blocks. All active UBI logical eraseblocks are located in the earlier blocks and will still boot cleanly into `PEG_M2_B38.2`.

---

### Step 4: Configure Your SIM Card's APN for IPv4/IPv6 Internet

Once the router reboots into **`PEG_M2_B38.2`**:

1. Insert your 4G SIM card and power on the JioFi M2.
2. Connect to the JioFi M2 via Wi-Fi or USB and open **`http://192.168.1.1`** (or **`http://jiofi.local.html`**) in your browser.
3. Click **Login** in the top-right corner and sign in with:
   - **Username:** `administrator`
   - **Password:** `administrator`
4. Navigate to **Setting → LTE**.
5. Change **APN Mode** from **Auto** to **Manual** (leaving it on Auto defaults to `jionet`, which prevents IPv4 WAN assignment on other carriers).
6. Enter your carrier's APN and set **PDP / IP Type** to **`IPv4v6`** (or **`IPv4`**):

   | Carrier | APN | PDP / IP Type |
   | :--- | :--- | :--- |
   | **Airtel** | `airtelgprs.com` | `IPv4v6` / `IPv4` |
   | **Vi (Vodafone Idea)** | `www` or `portalnmms` | `IPv4v6` / `IPv4` |
   | **BSNL** | `bsnlnet` | `IPv4v6` / `IPv4` |

7. Click **Save / Apply**. *(Optional: You can also run **Unlock Network** in `JioFi_tools_v1.0.5.apk` once on `PEG_M2_B38.2` to install the persistent `rmnet_fix.sh` routing watchdog.)*

---

## 🙏 Credits & Attribution

- **`abhimortal6` (`ab_hi_j` on XDA):** Reverse-engineering the JioFi 2 M2/M2S baseband, creating `JioFi_tools_v1.0.5.apk`, and providing the unlocked `aboot_jiofi2_m2.img`, `modem_jiofi2_m2.img`, and `PEG_M2_B38.2` backup images.
- **`sheikhshahnawaz41299`:** JioFi M2 V2 partition research and firmware dumps.

---

## ⚠️ Disclaimer

This repository is provided for educational and experimental hardware research purposes only. Flashing bootloaders and modem partitions carries a risk of bricking your device if interrupted or used on an incompatible hardware model. Proceed at your own risk.
