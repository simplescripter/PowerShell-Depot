1..10 | %{(33..57),(65..90),(97..122) -split ' ' | %{[char][int]$_} | Get-Random | Write-Host -NoNewline}; "`n"
