# HP ENVY x360 15-cp0xxx OpenCore

Public backup for the HP ENVY x360 15-cp0xxx with Ryzen 5 2500U (4 cores / 8 threads), Raven Vega 1002:15dd, BIOS F.48, and ALC295 audio. Target: macOS Ventura 13.x / Darwin 22.x.

Ventura Recovery and the installed Ventura desktop have booted on the actual laptop. On 2026-09-29 the OpenCore 1.0.7 RELEASE build booted the installed macOS Ventura 13.7.8. The USB's current EFI is backed up in `tested/EFI` with the owner's Mac identity removed. The built-in camera works with [UVC15Fix](https://github.com/virgil724/UVC15Fix) (see Camera below). GPU acceleration, audio, networking, battery, touchscreen and sleep have not been fully verified.

## Files

- `tested/EFI/`: the current USB EFI with OpenCore 1.0.7 RELEASE binaries and sanitized Mac identity. This is the configuration backed up from the USB on 2026-09-29.
- `EFI/`: identical to `tested/EFI/`. It was previously an untested RELEASE variant; the RELEASE build is now the tested one.
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

## Current configuration notes

Compared with the 2026-09-28 backup, the current configuration:

- Uses OpenCore RELEASE binaries with file logging off (`Misc -> Debug -> Target 0`, `AppleDebug`/`ApplePanic` off) and a 5-second picker timeout.
- Boots without verbose or debug arguments: `alcid=1 npci=0x3000 uvcfixdelay=60`.
- Fixes a trailing space in the `_cpuid_set_info` Base of the 11.3+ `CPUFAMILY_INTEL_PENRYN` patch. The CPU family was already reported correctly, so this is cleanup.
- Moves `DeviceProperties` back to the top level. In earlier configs it was nested inside `Kernel`, so OpenCore ignored it and the NVMe `ps-max-latency-us = 0` (APST off) property never applied. That property is dropped, which keeps the behavior that was actually tested. The NVMe device now gets `built-in = 01` so macOS no longer shows the internal SSD as external.
- Adds `UVC15Fix.kext` after Lilu.

## Camera

The HP Wide Vision FHD Camera (Chicony `04f2:b634`) enumerates, but on stock Ventura it produces no frames. It reports UVC 1.5 and always returns the full 48-byte probe/commit structure, while macOS `UVCAssistant` asks for 26/34 bytes. The xHCI controller then reports `kIOReturnOverrun`, and streaming never starts.

`UVC15Fix.kext` reissues only those probe/commit reads with a 48-byte buffer. Source, diagnosis and build instructions are in [virgil724/UVC15Fix](https://github.com/virgil724/UVC15Fix). The kext here is built byte-for-byte from that repository.

The route is installed 60 seconds after boot (`uvcfixdelay=60`), so the camera starts working about a minute after startup. Routing during early boot hard-reset this laptop right after `IONVMeController::start`. Add `-uvcfixoff` to boot-args, or delete the kext, to disable the fix.

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
