# HP ENVY x360 15-cp0xxx OpenCore

Public backup for the HP ENVY x360 15-cp0xxx with Ryzen 5 2500U (4 cores / 8 threads), Raven Vega 1002:15dd, BIOS F.48, and ALC295 audio. Target: macOS Ventura 13.x / Darwin 22.x.

Ventura Recovery successfully booted on the actual laptop on 2026-09-28 using the DEBUG EFI in `tested/EFI`. This confirms recovery boot and a working graphical recovery interface. Full macOS installation, GPU acceleration, audio, networking, battery and sleep remain unverified.

## Files

- `tested/EFI/`: the hardware-tested USB EFI with OpenCore 1.0.7 DEBUG binaries.
- `EFI/`: matching configuration with OpenCore 1.0.7 RELEASE binaries; this variant has not been boot-tested.
- `profiles/config-pci3000.plist`: the successful DEBUG USB configuration.
- `profiles/config-diagnostic.plist`: equivalent DEBUG logging configuration.
- `profiles/config-no-MAT.plist`: main configuration with the firmware's required memory settings.
- `profiles/config-touchscreen.plist`: optional I2C touchscreen support; untested.
- `ACPI-source/`: injected SSDT sources and compiled AML.
- `licenses/`: upstream license texts supplied with the drivers.
- `evidence/`: hardware details, upstream download URLs/checksums, and a concise boot verification record.

## Before using

The public configs have empty SystemSerialNumber, MLB, SystemUUID, and an all-zero ROM. Generate your own MacBookPro16,2 identity using the official OpenCore macserial utility and populate `PlatformInfo -> Generic` in your local config before use. The owner's original identity remains only in the private local backup.

Disable firmware Secure Boot and use UEFI boot. The firmware reports no MAT support, so EnableWriteUnprotector is true while RebuildAppleMemoryMap and SyncRuntimePermissions are false. `npci=0x3000` resolved the observed PCI initialization stall; keep BIOS Above 4G Decoding disabled or unavailable when using this argument. Preserve the existing 1 GiB UMA graphics allocation.

For the tested setup, copy `tested/EFI` to a FAT32 USB. Obtain Apple's Ventura recovery DMG and chunklist separately with official OpenCore macrecovery, placing them in `com.apple.recovery.boot` at the USB root. The observed recovery entry is `OPENCORE (external) (dmg)`.

This repository contains the OpenCore configuration and third-party driver binaries. Apple's recovery image, personal Mac identifiers, raw firmware dumps, boot logs, photos, videos, disk images, and USB backups are not published.

## Hardware support

NootedRed provides the AMD graphics driver; AppleALC follows it in load order and uses `alcid=1`. VoodooPS2Controller is enabled for keyboard and Synaptics touchpad. The USB map derives from this laptop's firmware and needs physical port validation. Fake EC/USB power, USB hub reset, AMD brightness/ambient-light tables, and XOSI are included.

Built-in RTL8822BE Wi-Fi and Realtek Bluetooth are unsupported by this EFI. HoRNDIS 9.2 is included for Android USB tethering; recovery network access still requires testing. Touchscreen support is disabled in the main configuration. Do not erase an existing Linux installation: dual boot needs a separately prepared macOS partition.

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
