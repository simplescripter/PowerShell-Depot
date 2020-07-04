Function Start-ContinuousPing {
    Param(
        [string]$nameOrIP,
        [int]$interval = 5
    )
    $key = $null
    $global:ProgressPreference = 'SilentlyContinue'
    
    If($PSBoundParameters.Keys -contains 'nameOrIP'){
        Write-Host "Pinging $nameOrIP every $interval seconds. Hit any key to quit." -BackgroundColor White -ForegroundColor DarkMagenta
    }else{
        Write-Host "Pinging internetbeacon.msedge.net every $interval seconds. Hit any key to quit." -BackgroundColor White -ForegroundColor DarkMagenta
    }
    Do{
        $timeStamp = (Get-Date).ToLongTimeString()
        If($PSBoundParameters.Keys -contains 'nameOrIP'){
            $result = Test-NetConnection $nameOrIP -WarningAction SilentlyContinue
        }else{
            $result = Test-NetConnection -WarningAction SilentlyContinue
        }
        Write-Host "$timeStamp : Ping success: $($result.PingSucceeded)"
        Start-Sleep $interval
        while([console]::KeyAvailable){
            $key = [console]::Readkey("NoEcho").Key
        }
    }Until($key)
    Write-Host "Key pressed. Quitting" -ForegroundColor DarkRed -BackgroundColor White
    $global:ProgressPreference = 'Continue'
}

Start-ContinuousPing -nameOrIP 8.8.8.8 -interval 3