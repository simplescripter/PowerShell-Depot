Function Get-PrivateBytes {
    $i = 0
    $total = 0
    $procs = Get-Process
    $count = $procs.Count
    ForEach($processName in (Get-Process)){
        $i++
        $percent = [math]::Round($i/$count * 100)
        $privateBytes = get-counter -counter "\Process($($processName.name))\Private Bytes" -ErrorAction SilentlyContinue | 
            select -expandproperty countersamples | select -expandproperty cookedvalue
        $total = $total + $privateBytes
        $running = "{0:N0} K" -f ($total/1KB)
        Write-Progress -Activity "Collecting Private Working Set info" -PercentComplete $percent -Status "Commit Size : $running" -CurrentOperation "$percent% complete"
        "$($processName.name) - {0:N0} K" -f ($privateBytes/1KB)
    }
    Write-Progress -Activity "Collecting Private Working Set info" -Completed
    $total = "`nTotal : {0:N2}GB" -f ($total/1GB)
    Write-Host $total -ForegroundColor DarkCyan -BackgroundColor DarkRed
}