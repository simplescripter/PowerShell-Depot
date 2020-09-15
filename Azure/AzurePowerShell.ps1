Function IsAdmin
{
    $IsAdmin = ([Security.Principal.WindowsPrincipal] [Security.Principal.WindowsIdentity]::GetCurrent()`
        ).IsInRole([Security.Principal.WindowsBuiltInRole] "Administrator") 
    Return $IsAdmin
}

Function InstallWinRMCertificateForVM()
{
    # This code sourced from https://gallery.technet.microsoft.com/scriptcenter/Configures-Secure-Remote-b137f2fe
    param(
        [string]$CloudServiceName,
        [string]$Name
    )
	if((IsAdmin) -eq $false)
	{
		Write-Error "Must run PowerShell elevated to install WinRM certificates."
		return
	}

    Write-Host "Installing WinRM Certificate for remote access: $CloudServiceName $Name"
	$WinRMCert = (Get-AzureVM -ServiceName $CloudServiceName -Name $Name | Select-Object -ExpandProperty vm).DefaultWinRMCertificateThumbprint
	$AzureX509cert = Get-AzureCertificate -ServiceName $CloudServiceName -Thumbprint $WinRMCert -ThumbprintAlgorithm sha1

	$certTempFile = [IO.Path]::GetTempFileName()
	$AzureX509cert.Data | Out-File $certTempFile

	# Target The Cert That Needs To Be Imported
	$CertToImport = New-Object System.Security.Cryptography.X509Certificates.X509Certificate2 $certTempFile

	$store = New-Object System.Security.Cryptography.X509Certificates.X509Store "Root", "LocalMachine"
	$store.Open([System.Security.Cryptography.X509Certificates.OpenFlags]::ReadWrite)
	$store.Add($CertToImport)
	$store.Close()
	
	Remove-Item $certTempFile
}

Function Setup-AzureRemotePS{
<#
.SYNOPSIS
    Prepares the local host to use PowerShell remoting for Azure VMs
.DESCRIPTION
    Setup-AzureRemotePS configures the local machine to use PowerShell remoting for Azure VMs. It
    either modifies the local TrustedHosts store and attempts to authenticate without certificate
    validation (in unsecure mode), or it will use InstallWinRMCertificateForVM to install the 
    VM certificate in the local root store (when the -Secure switch is used)
.PARAMETER cloudName
    The name of the Azure cloud service containing the VM.  The Get-AzureService command can be
    used to view cloud service names in the current Azure subscription.
.PARAMETER VMName
    The name of the Azure VM you want to remote into using PowerShell.  The Get-AzureVM command
    can be used to view Azure VM names.
.PARAMETER Secure
    If enabled, the secure switch will download and the VM's machine certifcate and install it
    in the local machine root store.  When the -Secure parameter is not used, Setup-AzureRemotePS
    will add the VM FQDN to the local WinRM TrustedHosts list. 
To do:

--Parameters should include
    Secure (requires downloading and installing PS self-signed certificate) or
    Unsecure (Use New-PSSessionOption to enable SkipCACheck and use the option
        with Enter-PSSession
--Remove Verbose statements?
#>
    #Requires -module Azure
    Param(
        [Parameter(Mandatory=$True)]
        [string]$cloudName,
        [string]$VMName,
        [switch]$Secure        
    )
    $VerbosePreference = "Continue"

    If((IsAdmin) -eq $false)
	{
		Write-Error "You must run PowerShell elevated to install WinRM certificates or modify Trusted Hosts."
		Return
	}

    # If we're not logged on to Azure, use Add-AzureAccount to log on

    If(-not (Get-AzureSubscription -ErrorAction SilentlyContinue)){
        Add-AzureAccount
    }
    Select-AzureSubscription -SubscriptionName "MSDN Platforms" -Current
    $global:winRMURI = Get-AzureWinRMUri -ServiceName $cloudName -Name $VMName
    If($Secure){
        InstallWinRMCertificateForVM -CloudServiceName $cloudName -Name $VMName
    }Else{
        $originalTrustedHosts = (Get-Item WSMan:\localhost\Client\TrustedHosts).Value
        If($originalTrustedHosts){
            Set-Item WSMan:\localhost\Client\TrustedHosts -Value "$originalTrustedHosts,$cloudName.cloudapp.net" -Force
        }Else{
            Set-Item WSMan:\localhost\Client\TrustedHosts -Value "$cloudName.cloudapp.net" -Force
        }
    }
    $VerbosePreference = "SilentlyContinue"
}

Setup-AzureRemotePS -cloudName DatacenterImages -VMName JuneImage
Enter-PSSession -ConnectionUri $winRMURI -Credential "JuneImage\shawn" -SessionOption (New-PSSessionOption -SkipCACheck)