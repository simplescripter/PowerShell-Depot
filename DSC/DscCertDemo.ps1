# For a DSC Demo using 55202 Lab on Demand VMs
# Run from StudentServer

Param(
    [string]$computerName = 'StudentServer',
    [string]$dirPath = 'C:\DSC'
)

If(-not (Test-Path $dirPath)){
    New-Item $dirPath -ItemType Directory
}

# TODO: encryptdecrypt module requires PowerShell 5.1, but the 55202 lab environment run 5...

# Grab EncryptDecrypt if necessary. New-SelfSignedCertificate before Windows 10/Server 2016 doesn't support
If(-not (Get-Module encryptdecrypt -ListAvailable)){
    Install-Module encryptdecrypt -Force
}

# Define the parameters required for a DSC cert:
$certParams = @{
	'Subject' = "CN=$computerName"
	'SubjectAlternativeName' = $computerName
	'EnhancedKeyUsage' = '1.3.6.1.4.1.311.80.1' # Document Encryption key usage OID
	'KeyUsage' = 'KeyEncipherment', 'DataEncipherment'
	'FriendlyName' = 'DSC Encryption Certificate'
	'StoreLocation' = 'LocalMachine'
	'StoreName' = 'My'
	'ProviderName' = 'Microsoft Enhanced Cryptographic Provider v1.0'
	 #'PassThru' = $true
	'KeyLength' = 2048
	'AlgorithmName' = 'RSA'
	'SignatureAlgorithm' = 'SHA256'
}
# Use New-SelfSignedCertificateEx to generate a self-signed cert for the local host
New-SelfSignedCertificateEx @certParams
$cert = Get-ChildItem Cert:\LocalMachine\My -DocumentEncryptionCert

# Export the certificate for the MOF compilation system
Export-Certificate -FilePath $dirPath\$computerName.cer -Cert $cert

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
          DependsOn = "[User]UserResourceExample"
        }
    }
}

LocalAccounts -OutputPath $dirPath -ConfigurationData $configData
