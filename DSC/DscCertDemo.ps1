# For a DSC Demo using 55202 Lab on Demand VMs
# Run from StudentServer

Param(
    [string]$computerName = 'StudentServer',
    [string]$dirPath = 'C:\DSC'
)

If(-not (Test-Path $dirPath)){
    New-Item "C:\DSC" -ItemType Directory
}

# Grab xDscUtils if necessary
If(-not (Get-Module xDscUtils -ListAvailable)){
    Install-Module xDscUtils -Force
}

# Use New-xSelfSignedDscEncryptionCertificate to generate a self-signed cert for the local host
$cert = New-xSelfSignedDscEncryptionCertificate -EmailAddress DscCertDemo -ValidityYears 5 -ExportFilePath C:\$computerName.cer

# Configuration Data section
$configData = @{
    AllNodes = @(
        @{
            NodeName = "*"
        }
        @{
            NodeName = $computerName
            CertificateFile = "C:\$computerName.cer" # local path where MOF is being compiled
            CertificateID = $cert.Thumbprint
        }
    )
}

# Update the host Local Configuration Manager meta-config to include the CertificateID
[DSCLocalConfigurationManager()]
configuration LCMConfig
{
    Node $AllNodes.NodeName
    {
        Settings
        {
            CertificateID = $Node.CertificateID
        }
    }
}
LCMConfig -OutputPath $dirPath -ConfigurationData $configData
Set-DscLocalConfigurationManager -Path $dirPath -ComputerName $computerName

# System configuration example.  The credentials will be encrypted in the resulting MOF
Configuration LocalAccounts {
    Import-DscResource -ModuleName 'PSDesiredStateConfiguration'
    Node $AllNodes.NodeName {

        User UserResourceExample {
            Ensure = 'Present'
            UserName = 'Bob'
            Password = (Get-Credential -UserName "Bob" -Message "Enter the password for the new user")
        }

        Group GroupResourceExample {
          GroupName = "ExampleGroup"
          Members = "Nicole", "Rocky", "Mark","BlueBuffalo\Administrator"
          Credential = (Get-Credential -Message 'Enter domain user credentials')
          #DependsOn = "[User]UserResourceExample"
        }
    }
}

LocalAccounts -OutputPath $dirPath -ConfigurationData $configData
