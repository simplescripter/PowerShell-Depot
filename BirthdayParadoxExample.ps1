# A demonstration of the 'Birthday Paradox,' wherein a 50% probability exists that 
# any two random people will share the same birthday within a group of 23.
# By the time the group size reaches 60, there is over a 99% probability that 2 people
# will share the same birthday

$start = Get-Date "1/1/2016" # 2016 was a leap year, so we'll use it to get all possible birthdays
Remove-Variable daysOfYear -ErrorAction SilentlyContinue
# Using an a .NET arraylist because it's faster than a fixed array...
$daysOfYear = New-Object System.Collections.ArrayList
For($i = 0; $i -le 366;$i++){
    $daysOfYear.add((Get-Date ($start.AddDays($i)) -Format 'MMMM dd')) | Out-Null
}
# ...but Get-Random doesn't seem to like picking from an arraylist, so 
# convert it to a standard array.  Which requires deleting the $daysOfYear variable
# at the beginning of the script

[array]$daysOfYear = $daysOfYear
$quit = $false
$birthdays = @()
$runningTotal = 0
Do{
    $runningTotal ++
    $birthday = Get-Random $daysOfYear
    Write-Host $runningTotal -NoNewline -ForegroundColor DarkCyan
    Write-Host " $birthday"
    If($birthdays -contains $birthday){$quit = $true}
    $birthdays += $birthday
}Until($quit)
Write-Host "`n$runningTotal people before birthday collision" -ForegroundColor DarkCyan
