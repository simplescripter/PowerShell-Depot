$ComputerList = “slasher”,“zombie”,"XPS"

[Array]$AuditOSinfo = `
ForEach($ComputerName in $ComputerList)
{
    $SavedAuditOS = get-wmiobject -Class Win32_OperatingSystem `
        -ComputerName $ComputerName
    $SavedAuditIPAddr = Get-WmiObject -query `
        "SELECT * FROM Win32_PingStatus WHERE Address = '$ComputerName'"
    $MyPSObject = New-Object PSObject -Property @{
        ComputerName  = $SavedAuditOS.csname
        IPv4Address   = $SavedAuditIPAddr.IPv4Address
        IPStatusCode  = $SavedAuditIPAddr.StatusCode
        SerialNumber  = $SavedAuditOS.SerialNumber
        OSversion     = $SavedAuditOS.Version
        SystemDescrip = $SavedAuditOS.Description
        OSName        = $SavedAuditOS.Name.Split("|")[0]
        } 
    $MyPSObject
}

$AuditOSinfo | Export-CSV -Path C:\temp\TestReport.csv -NoTypeInformation
ii C:\temp\TestReport.csv
