Publish-DscConfiguration -Path .\AdatumEnvVars -ComputerName 'localhost'
Publish-DscConfiguration -Path .\AdatumRegistry -ComputerName 'localhost'
Start-DscConfiguration -UseExisting -ComputerName 'localhost'

Get-ItemProperty -Path 'HKLM:\Software\AdatumRegKey1'
[Environment]::GetEnvironmentVariable("AdatumEnvVar1","Machine")
