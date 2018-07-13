Function Rename-Admin {
    [CmdletBinding()]
    Param(
        [Parameter(ValueFromPipeline=$true,ValueFromPipelineByPropertyName=$true)]
        [string[]]$computerName = 'localhost',

        [Parameter(Mandatory=$true)]
        [string]$newName
    )
    Process{
        ForEach($computer in $computerName){
            $admin = Get-WmiObject -ComputerName $computer -Query "Select * From Win32_UserAccount Where LocalAccount = TRUE AND SID LIKE 'S-1-5%-500'"
            $admin.Rename($newName) | Out-Null
        }
    }
}

<#
$comp = "LON-CL1"
Write-Host "Old name is " (Get-WmiObject -ComputerName $comp -Query "Select * From Win32_UserAccount Where LocalAccount = TRUE AND SID LIKE 'S-1-5%-500'").Name
Rename-Admin -newName Bigfoot -computerName $comp
Write-Host "New name is " (Get-WmiObject -ComputerName $comp -Query "Select * From Win32_UserAccount Where LocalAccount = TRUE AND SID LIKE 'S-1-5%-500'").Name
#>