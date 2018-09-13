Function Register-Repo {
    Param(
        [Parameter(Mandatory=$true)]
        [string]$name,

        [Parameter(Mandatory=$true)]
        [string]$sourceLocation,

        [ValidateSet('Trusted','Untrusted')]
        [string]$installationPolicy = 'Trusted'
    )
    # Many sites, including GitHub, now require TLS 1.2 or greater, so let's enable it:
    [Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12

    Register-PSRepository -Name $name -SourceLocation $sourceLocation -InstallationPolicy $installationPolicy
}