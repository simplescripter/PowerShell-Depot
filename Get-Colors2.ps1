$colors = [enum]::GetNames([consolecolor])
ForEach($fg in $colors){
    ForEach($bg in $colors){
        Write-Host "This is $fg on $bg" -ForegroundColor $fg -BackgroundColor $bg
    }
}