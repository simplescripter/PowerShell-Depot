<#

Map a drive from a Windows machine to an Azure file share

Requirements:

From outside of Azure: Windows 8/Server 2012 or later
From within Azure: Windows 7/Server 2008R2 or later

#>
Function Map-AzureDrive{
    Param(
        [Parameter(Mandatory=$true)]
        [string]$acctKey,

        [Parameter(Mandatory=$true)]
        [string]$storageAcctName,

        [Parameter(Mandatory=$true)]
        [string]$shareName,

        [string]$driveLetter = 'Z'
    )
    $secureKey = ConvertTo-SecureString -String $acctKey -AsPlainText -Force
    $credential = New-Object System.Management.Automation.PSCredential -ArgumentList "Azure\$storageAcctName", $secureKey
    New-PSDrive -Name $driveLetter -PSProvider FileSystem `
        -Root "\\$storageAcctName.file.core.windows.net\$shareName" `
        -Credential $credential -Persist -Scope Global
}