# For a DSC Demo using 55202 Lab on Demand VMs
# Run from StudentServer2.  If you run the script from any other system, you'll need to import the certificate 
# into the destination system's local machine certificate store before the configuration can be pushed or pulled

Param(
    [string]$computerName = 'StudentServer2',
    [string]$dirPath = 'C:\CERTDEMO'
)

If(-not (Test-Path $dirPath)){
    New-Item $dirPath -ItemType Directory
}
# Grab Adam Bertram's New-SelfSignedCertificateEx if necessary (New-SelfSignedCertificate before Windows 10/Server 2016 doesn't support
# the necessary parameters for a DSC certicate):

If(-not (Test-Path "$dirpath\New-SelfSignedCertificateEx.ps1")){
    $pathToScript = "https://raw.githubusercontent.com/adbertram/Random-PowerShell-Work/f88241b7942e343eeef08ab583212e682df89eb3/Security/New-SelfSignedCertificateEx.ps1"
    Invoke-WebRequest -Uri $pathToScript -OutFile C:\CERTDEMO\New-SelfSignedCertificateEx.ps1
}

# Define the parameters required for a DSC cert:
$certParams = @{
	'Subject' = "CN=$computerName"
	'SAN' = $computerName
	'EnhancedKeyUsage' = 'Document Encryption'
	'KeyUsage' = 'KeyEncipherment', 'DataEncipherment'
	'FriendlyName' = 'DSC Encryption Certifificate'
	'StoreLocation' = 'LocalMachine'
	'StoreName' = 'My'
	'ProviderName' = 'Microsoft Enhanced Cryptographic Provider v1.0'
	'PassThru' = $true
	'KeyLength' = 2048
	'AlgorithmName' = 'RSA'
	'SignatureAlgorithm' = 'SHA256'
}
# Use New-SelfSignedCertificateEx to generate a self-signed cert for the local host
. "$dirPath\New-SelfSignedCertificateEx.ps1"
$cert = New-SelfSignedCertificateEx @certParams

# Export the certificate for the MOF compilation system
$cert | Export-Certificate -FilePath "$dirPath\$computerName.cer"

# Configuration Data section
$configData = @{
    AllNodes = @(
        @{
            NodeName = "*"
        }
        @{
            NodeName = $computerName
            CertificateFile = "$dirPath\$computerName.cer" # local path where MOF is being compiled
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
