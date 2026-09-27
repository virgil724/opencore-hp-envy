DefinitionBlock ("", "SSDT", 2, "HPENVY", "USBRST", 1)
{
    External (\_SB.PCI0.GP17.XHC0.RHUB, DeviceObj)
    External (\_SB.PCI0.GP17.XHC1.RHUB, DeviceObj)
    Scope (\_SB.PCI0.GP17.XHC0.RHUB)
    {
        Method (_STA, 0, NotSerialized)
        {
            If (_OSI ("Darwin")) { Return (Zero) }
            Return (0x0F)
        }
    }
    Scope (\_SB.PCI0.GP17.XHC1.RHUB)
    {
        Method (_STA, 0, NotSerialized)
        {
            If (_OSI ("Darwin")) { Return (Zero) }
            Return (0x0F)
        }
    }
}
