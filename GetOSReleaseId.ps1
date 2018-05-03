# Function to fetch the ReleaseId value from one or more Windows systems using WMI and the STDREG provider
# (Windows clients don't have PowerShell remoting enabled by default, but WMI may be available)

Function Get-OSReleaseID {
    [CmdletBinding()]
    Param (
        [Parameter(ValueFromPipeline=$true,ValueFromPipelineByPropertyName=$true)]
        [string[]]$computerName = 'localhost'
    )
    Process {
        $HKLM = 2147483650
        $key = "SOFTWARE\Microsoft\Windows NT\CurrentVersion"
        $releaseID = "ReleaseId"
        $productName = "ProductName"
        ForEach($computer in $computerName){
            $wmi = [wmiclass]"\\$computer\root\default:stdRegProv"
            $releaseIDValue = ($wmi.GetStringValue($HKLM,$key,$releaseID)).sValue
            $productNameValue = ($wmi.GetStringValue($HKLM,$key,$productName)).sValue
            $properties = @{
                ComputerName = $computer
                ProductName = $productNameValue
                ReleaseID = $releaseIDValue
            }
            $return = New-Object -TypeName PSObject -Property $properties
            Write-Output $return
        }
    }
}
