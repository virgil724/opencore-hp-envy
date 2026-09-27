DefinitionBlock ("", "SSDT", 2, "HPENVY", "XOSI", 1)
{
    Method (XOSI, 1, NotSerialized)
    {
        If (_OSI ("Darwin"))
        {
            Store (Package ()
            {
                "Windows 2001", "Windows 2001.1", "Windows 2001 SP1",
                "Windows 2001 SP2", "Windows 2001 SP3", "Windows 2006",
                "Windows 2006 SP1", "Windows 2006 SP2", "Windows 2009",
                "Windows 2012", "Windows 2013", "Windows 2015"
            }, Local0)
            Return (Match (Local0, MEQ, Arg0, MTR, Zero, Zero) != Ones)
        }
        Return (_OSI (Arg0))
    }
}
