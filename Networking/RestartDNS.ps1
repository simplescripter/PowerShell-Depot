<# Assumes E:\dns.txt contains a server list in the following format:

plant,server
1,ServerA
1,ServerB
2,ServerC
3,ServerD
3,ServerE

etc.
#>
$list = Import-CSV "E:\dns.txt"
$i = $null
$numberOfPlants = 10
$delayBetweenPlants = 300 # in seconds
Do{
    $i++
    $plant = $list | Where-Object {$_.plant -eq $i}
    Write-Progress -Activity "Restarting DNS for Plant:" -Status $i -PercentComplete ($i/$numberOfPlants * 100)
    Write-Host "Plant $i" -ForegroundColor Yellow -BackgroundColor DarkCyan
    ForEach($server in $plant){
        $serverName = $server.server
        #Invoke-Command $serverName {Restart-Service DNS}
        Write-Host "Restarting DNS on $serverName"
    }
    Sleep $delayBetweenPlants
}Until($i -ge $numberOfPlants)

