Function Guess-TheNumber{
    Param(
        [int]$upperRange = 100
    )
Clear-Host
[int]$number = Get-Random -Minimum 1 -Maximum $upperRange
$guesses = $null
$allBelow = @(1)
$allAbove = @($upperRange)
Do
{
    $guesses++
    $floor = $allBelow | Sort-Object | Select-Object -Last 1
    $ceiling = $allAbove | Sort-Object | Select-Object -First 1
    [int]$guess = Read-Host "Guess the number between $floor and $ceiling"
    If([int]$guess -lt $number){
        Write-Host "That's too low!  Try again." -ForegroundColor Red
        $allBelow += $guess
    }
    ElseIf([int]$guess -gt $number){
        Write-Host "That's too high! Try again." -ForegroundColor Red
        $allAbove += $guess
    }
}Until($guess -eq $number)
Write-Host "You got it!  The number was $number.  It took you $guesses guesses." -ForegroundColor Green
}