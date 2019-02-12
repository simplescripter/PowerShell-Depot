Function Build-AllNodesList {
    #requires -module  ActiveDirectory
    $computerList = Get-ADComputer -Filter *
    $nodes = @()
    ForEach ($computer in $computerList){
        $nodes += @"
          @{
                NodeName = "$($computer.Name)"
            }`n
"@
    }
    $AllNodeString = @"
    `$ConfigurationData =
        @{
            AllNodes = @(
                $nodes
            )
        }
"@
    Write-Output $AllNodeString
}