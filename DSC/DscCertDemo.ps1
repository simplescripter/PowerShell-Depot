# For a DSC Demo using 55202 Lab on Demand VMs
# Run from StudentServer

Param(
    [string]$computerName = 'StudentServer2',
    [string]$dirPath = 'C:\DSC'
)

If(-not (Test-Path $dirPath)){
    New-Item "C:\DSC" -ItemType Directory
}
<#  New-xSelfSignedDscEncryptionCertificate doesn't work with older versions of New-SelfSignedCertificate

# Grab xDscUtils if necessary
If(-not (Get-Module xDscUtils -ListAvailable)){
    Install-Module xDscUtils
}

# Use New-xSelfSignedDscEncryptionCertificate to generate a self-signed cert for the local host
$cert = New-xSelfSignedDscEncryptionCertificate -EmailAddress DscCertDemo -ValidityYears 5 -ExportFilePath C:\$computerName.cer
#>

# Instead of New-xSelfSignedDscEncryptionCertificate, use Microsoft's technique documented with 
# Protect-CmsMessage:

    # Create .INF file for certreq

{[Version]
Signature = "$Windows NT$"

[Strings]
szOID_ENHANCED_KEY_USAGE = "2.5.29.37"
szOID_DOCUMENT_ENCRYPTION = "1.3.6.1.4.1.311.80.1"

[NewRequest]
Subject = "cn=DscCertDemo"
MachineKeySet = false
KeyLength = 2048
KeySpec = AT_KEYEXCHANGE
HashAlgorithm = Sha1
Exportable = true
RequestType = Cert
KeyUsage = "CERT_KEY_ENCIPHERMENT_KEY_USAGE | CERT_DATA_ENCIPHERMENT_KEY_USAGE"
ValidityPeriod = "Years"
ValidityPeriodUnits = "1000"

[Extensions]
%szOID_ENHANCED_KEY_USAGE% = "{text}%szOID_DOCUMENT_ENCRYPTION%"
} | Out-File -FilePath "$($dirPath)\$($computerName)_DocumentEncryption.inf"

# After you have created your certificate file, run the following command to add the certificate file to the certificate store.Now you are ready to encrypt and decrypt content with the next two examples.
certreq -new "$($dirPath)\$($computerName)_DocumentEncryption.inf" "$($dirPath)\$($computerName).cer"

# Configuration Data section
$configData = @{
    AllNodes = @(
        @{
            NodeName = "*"
        }
        @{
            NodeName = $computerName
            CertificateFile = "C:\DSC\$computerName.cer" # local path where MOF is being compiled
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
          Members = "Bob","BlueBuffalo\Administrator"
          Credential = (Get-Credential -Message 'Enter domain user credentials')
          #DependsOn = "[User]UserResourceExample"
        }
    }
}

LocalAccounts -OutputPath $dirPath -ConfigurationData $configData
