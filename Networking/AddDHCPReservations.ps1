$subnet = '172.16.0.'
$hosts = 9..11
$dhcpServer = 'LON-DC1'
ForEach($hostIP in $hosts){
    # NOTE: because we're connecting to WMI using an IP, it's a good idea
    # to make sure you've DNS reverse lookup records for the machine.  Otherwise,
    # Kerberos auth will take MUCH longer for each IP
    $computer = "$subnet$hostIP"
    $pingResult = Test-NetConnection -ComputerName $computer
    If($pingResult.PingSucceeded){
        # Add error handling
        # Get-WMIObject query assumes a single physical NIC
        $nic = Get-WmiObject -Class Win32_NetworkAdapterConfiguration -ComputerName $computer -Filter "IPEnabled=$true"
        $properties = @{
            PingSucceeded = $pingResult.PingSucceeded
            IP = $pingResult.RemoteAddress
            Name = $nic.__SERVER
            MACaddress = $nic.MACAddress
        }
    }Else{
        $properties = @{
            PingSucceeded = $pingResult.PingSucceeded
            IP = $pingResult.RemoteAddress
            Name = "UNAVAILABLE"
            MACaddress = "UNAVAILABLE"
        }
    }
    $obj = New-Object -TypeName PSObject -Property $properties
    Write-Output $obj
}
