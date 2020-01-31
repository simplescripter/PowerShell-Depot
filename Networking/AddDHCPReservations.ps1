Function Search-Subnet {
    Param(
        [string]$subnet = '172.16.0.',
        [array]$hosts = 8..11
    )
    ForEach($hostIP in $hosts){
        # NOTE: because we're connecting to WMI using an IP, it's a good idea
        # to make sure you've DNS reverse lookup records for the machine.  Otherwise,
        # Kerberos auth will take MUCH longer for each IP
        $computer = "$subnet$hostIP"
        $pingResult = Test-NetConnection -ComputerName $computer -WarningAction SilentlyContinue
        If($pingResult.PingSucceeded){
            # Add error handling
            # Get-WMIObject query assumes a single physical NIC
            $nic = Get-WmiObject -Class Win32_NetworkAdapterConfiguration -ComputerName $computer -Filter "IPEnabled=$true"
            $properties = @{
                PingSucceeded = $pingResult.PingSucceeded
                IPAddress = $pingResult.RemoteAddress
                hostName = $nic.PSComputerName
                ClientId = $($nic.MACAddress -replace ':','-')
            }
        }<#Else{
            $properties = @{
                PingSucceeded = $pingResult.PingSucceeded
                IPAddress = $pingResult.RemoteAddress
                hostName = "UNAVAILABLE"
                ClientId = "UNAVAILABLE"
            }
        }#>
        $obj = New-Object -TypeName PSObject -Property $properties
        Write-Output $obj
    }
}

Search-Subnet | Add-DhcpServerv4Reservation -ComputerName 'LON-DC1' -ScopeId '172.16.0.0'