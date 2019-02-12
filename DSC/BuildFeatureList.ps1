# We can pull the existing feature list from a server and add it to a ConfigurationData hash table.
#To speed up the process, do this: 

$list = Get-WindowsFeature | Where-Object Installed -eq $true | Select-Object -ExpandProperty Name 
$list = $list -join ",`n"

@"
 `$configData = @{
    AllNodes = @(
        NodeName = "*"
        WindowsFeature = @(
            $($list)
        )
    )
 }
"@