Function Get-WebSensor {
    Param(
        $sourcePath = "http://bit.ly/1KzgLeX"
        )
    $web = New-Object System.Net.WebClient
    $statistics = $web.DownloadString($sourcePath).split("`n") |
        Select-String '<body>' 
    $statistics = $statistics -replace '(.*?)TF:', ""
    $statistics = $statistics -replace 'HU:', ","
    $statistics = $statistics -replace '%IL\s+', ","
    $statistics = $statistics -replace '\s+</body></html>', ""
    $statistics = $statistics.Split(",")
 
	$statObject = New-Object PSObject
	$statObject | Add-Member NoteProperty "TempF" ([decimal]$statistics[0])
    $statObject | Add-Member NoteProperty "Humidity" ([decimal]$statistics[1])
    $statObject | Add-Member NoteProperty "Illumination" ([decimal]$statistics[2])
 
    Write-Output $statObject
}
