For($i = 0;$i -le 15;$i++){
    For($j = 0;$j -le 15;$j++){
        $background = '{0:X}' -f $i
        $foreground = '{0:X}' -f $j
        cmd /c color $background$foreground
        Write-Host "Color scheme # $background$foreground"
        Sleep 1
    }
}