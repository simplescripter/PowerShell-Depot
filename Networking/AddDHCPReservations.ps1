Param(
    [string]$subnet = '172.16.0.',
    [array]$hosts = 9..11,
    [string]$fakeMACPrefixNoPing = 'AA-AA-AA',
    [string]$fakeMACPrefixNoWMI = 'BB-BB-BB',
    [string]$DHCPServer,
    [string]$DHCPScopeId
)

Function Search-Subnet {
    Param(
        [string]$subnet,
        [array]$hosts
    )
    ForEach($hostIP in $hosts){
        # NOTE: because we're connecting to WMI using an IP, it's a good idea
        # to make sure you've DNS reverse lookup records for the machine.  Otherwise,
        # Kerberos auth will take MUCH longer for each IP
        $computer = "$subnet$hostIP"
        $pingResult = Test-NetConnection -ComputerName $computer -WarningAction SilentlyContinue
        If($pingResult.PingSucceeded){
            $properties = @{
                PingSucceeded = $pingResult.PingSucceeded
                IPAddress = $pingResult.RemoteAddress
            }
           
            Try{
                # Get-WMIObject query assumes a single physical NIC
                $nic = Get-WmiObject -Class Win32_NetworkAdapterConfiguration -ComputerName $computer -Filter "IPEnabled=$true" -ErrorAction Stop
                $properties.Add('hostName',$nic.PSComputerName)
                $properties.Add('ClientId',$($nic.MACAddress -replace ':','-'))
            }Catch{
                $properties.Add('hostname','WMI_FAILED')
                $properties.Add('ClientId',(New-RandomMACSuffix -MACPrefix $fakeMACPrefixNoWMI))
            }
        }Else{
            $properties = @{
                PingSucceeded = $pingResult.PingSucceeded
                IPAddress = $pingResult.RemoteAddress
                hostName = "UNAVAILABLE"
                ClientId = (New-RandomMACSuffix -MACPrefix $fakeMACPrefixNoPing)
            }
        }
        $obj = New-Object -TypeName PSObject -Property $properties
        Write-Output $obj
    }
}

Function New-RandomMACSuffix {
    Param(
        [string]$MACPrefix
    )
    $MACSuffix = '{0:X6}' -f (Get-Random -Maximum 16777215)
    $MACSuffix = $MACSuffix -replace '(\w{2})(\w{2})(\w{2})', '$1-$2-$3'
    Write-Output "$MACPrefix-$MACSuffix"
}

Search-Subnet -subnet $subnet -hosts $hosts | Add-DhcpServerv4Reservation -ComputerName $DHCPServer -ScopeId $DHCPScopeId -ErrorAction SilentlyContinue
