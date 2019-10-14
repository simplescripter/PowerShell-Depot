[int]$iG = Read-Host "Enter a prime number"
[int]$iP = Read-Host "Enter another prime number GREATER than $iG"

# Note: the random number needs to be very small here, or 
# "Not a Number" (NaN) errors will result in PowerShell

$iXa = Read-Host "Enter a random number.  Keep this secret, Student1"
$iXb = Read-Host "Enter a random number.  Keep this secret, Student2"

$iYa = ([math]::Pow($iG,$iXa)) % $iP
$iYb = ([math]::Pow($iG,$iXb)) % $iP

Write-Host "Student1 Ya = $iYa `n`nOpenly exchange this number with Student2."
Write-Host "Student2 Yb = $iYb `n`nOpenly exchange this number with Student1."

Write-Host "Now you can compute your secret key."
Write-Host "Student1 key formula is (Yb^Xa) Mod P `n`t`t = " ([math]::Pow($iYb,$iXa)) % $iP "`n`t`t = " (([math]::Pow($iYb,$iXa)) % $iP)
Write-Host "Student2 key formula is (Ya^Xb) Mod P `n`t`t = " ([math]::Pow($iYa,$iXb)) % $iP "`n`t`t = " (([math]::Pow($iYa,$iXb)) % $iP)