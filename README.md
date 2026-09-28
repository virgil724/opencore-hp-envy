# HP ENVY x360 15-cp0xxx OpenCore

Public backup for the HP ENVY x360 15-cp0xxx with Ryzen 5 2500U (4 cores / 8 threads), Raven Vega 1002:15dd, BIOS F.48, and ALC295 audio. Target: macOS Ventura 13.x / Darwin 22.x.

Ventura Recovery and the installed Ventura desktop have booted on the actual laptop. The USB's current DEBUG EFI is backed up in `tested/EFI` with the owner's Mac identity removed. The camera appears in macOS but currently produces a black preview; GPU acceleration, audio, networking, battery, touchscreen and sleep have not been fully verified.

## Files

- `tested/EFI/`: the current USB EFI with OpenCore 1.0.7 DEBUG binaries and sanitized Mac identity. This is the configuration backed up from the USB on 2026-09-28.
- `EFI/`: matching configuration with OpenCore 1.0.7 RELEASE binaries; this variant has not been boot-tested.
- `profiles/config-pci3000.plist`: the successful DEBUG USB configuration.
- `profiles/config-diagnostic.plist`: equivalent DEBUG logging configuration.
- `profiles/config-no-MAT.plist`: main configuration with the firmware's required memory settings.
- `profiles/config-touchscreen.plist`: touchscreen-enabled profile; the current USB now enables the same four VoodooI2C entries. Touchscreen operation remains unverified.
- `ACPI-source/`: injected SSDT sources and compiled AML.
- `licenses/`: upstream license texts supplied with the drivers.
- `evidence/`: hardware details, upstream download URLs/checksums, and a concise boot verification record.

## Before using

The public configs have empty SystemSerialNumber, MLB, SystemUUID, and an all-zero ROM. Generate your own MacBookPro16,2 identity using the official OpenCore macserial utility and populate `PlatformInfo -> Generic` in your local config before use. The owner's original identity remains only in the private local backup.

Disable firmware Secure Boot and use UEFI boot. The firmware reports no MAT support, so EnableWriteUnprotector is true while RebuildAppleMemoryMap and SyncRuntimePermissions are false. `npci=0x3000` resolved the observed PCI initialization stall; keep BIOS Above 4G Decoding disabled or unavailable when using this argument. Preserve the existing 1 GiB UMA graphics allocation.

For the tested setup, copy `tested/EFI` to a FAT32 USB. Obtain Apple's Ventura recovery DMG and chunklist separately with official OpenCore macrecovery, placing them in `com.apple.recovery.boot` at the USB root. The observed recovery entry is `OPENCORE (external) (dmg)`.

This repository contains the OpenCore configuration and third-party driver binaries. Apple's recovery image, personal Mac identifiers, raw firmware dumps, boot logs, photos, videos, disk images, and USB backups are not published.

## Hardware support

NVMeFix is disabled in the main and current USB configuration after installation failures followed by the SSD disappearing. The user reports subsequent boot success. Historical diagnostic profiles retain their original NVMeFix choices. VoodooPS2Trackpad sets both ForceTouchMode entries to 0 by user request; executables are unchanged upstream binaries.

NootedRed provides the AMD graphics driver; AppleALC follows it in load order and uses `alcid=1`. VoodooPS2Controller is enabled for keyboard and Synaptics touchpad. The USB map derives from this laptop's firmware and needs physical port validation. Fake EC/USB power, USB hub reset, AMD brightness/ambient-light tables, and XOSI are included.

The original RTL8822BE card was replaced with an Intel AX210 (Wi-Fi 8086:2725, Bluetooth 8087:0032). AirportItlwm 2.3.0 for Ventura, IntelBluetoothFirmware 2.4.0, IntelBTPatcher 2.4.0, and BlueToolFixup 2.7.2 are included. The current USB also sets BlueToolFixup's required zero-valued Bluetooth NVRAM keys. Wi-Fi and Bluetooth still require hardware tests. HoRNDIS 9.2 is included for Android USB tethering. The current USB enables VoodooI2CServices, VoodooGPIO, VoodooI2C and VoodooI2CHID for the ELAN touchscreen, but touch input is unverified. Do not erase an existing Linux installation: dual boot needs a separately prepared macOS partition.

## Sources


- [OpenCore releases and configuration documentation](https://github.com/acidanthera/OpenCorePkg/releases/tag/1.0.7)
- [AMD Vanilla patches and four-core patch instructions](https://github.com/AMD-OSX/AMD_Vanilla)
- [NootedRed release](https://github.com/ChefKissInc/NootedRed/releases/tag/v0.8.10)
- [NootedRed/AppleALC ordering requirement](https://github.com/ChefKissInc/NootedRed/discussions/422)
- [NootedRed guide source: hardware, SMBIOS and brightness requirements](https://github.com/ChefKissInc/ChefKissInc.github.io/blob/7a8d5f6582e73a0e11c2422eb649dbda724b77cb/src/content/docs/applehax/nootedred.mdx)
- [AppleALC ALC295 layouts](https://github.com/acidanthera/AppleALC/blob/master/Resources/ALC295/Info.plist)
- [USBMap native personality format](https://github.com/corpnewt/USBMap)
- [AMD CPU power management and dependency ordering](https://github.com/trulyspinach/SMCAMDProcessor)


Third-party binaries retain their upstream licenses. See `licenses/`. ECEnabler upstream did not provide a standalone license text in the downloaded source; its source and release URL are listed in `evidence/downloads.json`.
