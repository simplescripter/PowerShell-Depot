$i = 0
For($j = 1;$j -le 5;$j++){
    Do {
        $i = $i + 1000
        [console]::beep($i,200)
    } Until ($i -eq 10000)
    Do {
        $i = $i - 1000
        [console]::beep($i,200)
    } Until ($i -eq 1000)
}