DefinitionBlock ("", "SSDT", 2, "HPENVY", "ECUSBX", 0x00000001)
{
    External (\_SB.PCI0.SBRG, DeviceObj)
    Scope (\_SB.PCI0.SBRG)
    {
        Device (EC)
        {
            Name (_HID, "ACID0001")
            Method (_STA, 0, NotSerialized)
            {
                If (_OSI ("Darwin")) { Return (0x0F) }
                Return (Zero)
            }
        }
    }
    Scope (\_SB)
    {
        Device (USBX)
        {
            Name (_ADR, Zero)
            Method (_STA, 0, NotSerialized)
            {
                If (_OSI ("Darwin")) { Return (0x0F) }
                Return (Zero)
            }
            Method (_DSM, 4, NotSerialized)
            {
                If (!Arg2) { Return (Buffer (One) { 0x03 }) }
                Return (Package ()
                {
                    "kUSBSleepPowerSupply", 0x13EC,
                    "kUSBSleepPortCurrentLimit", 0x0834,
                    "kUSBWakePowerSupply", 0x13EC,
                    "kUSBWakePortCurrentLimit", 0x0834
                })
            }
        }
    }
}
