Param(
	$loops = 60,
	$interval = 5
	)
cls
$i = $null
$d1Total = $null
$d2Total = $null
$d3Total = $null
Write-Host -ForegroundColor Yellow -BackgroundColor DarkGray ("{0,-12}{1,9} {2,9} {3,9}" -f "Time","Verizon","Google","Yahoo")
Do{
	$d1 = Test-Connection 4.2.2.2 -Count 1 -ErrorAction SilentlyContinue
	$d2 = Test-Connection 8.8.8.8 -Count 1 -ErrorAction SilentlyContinue
	$d3 = Test-Connection www.yahoo.com -Count 1 -ErrorAction SilentlyContinue
	If($d1 -eq $null){$d1ResponseTime = 1000}Else{$d1ResponseTime = $d1.ResponseTime}
	If($d2 -eq $null){$d2ResponseTime = 1000}Else{$d2ResponseTime = $d2.ResponseTime}
	If($d3 -eq $null){$d3ResponseTime = 1000}Else{$d3ResponseTime = $d3.ResponseTime}
	$d1Total += $d1ResponseTime
	$d2Total += $d2ResponseTime
	$d3Total += $d3ResponseTime
	$i++
	$d1Avg = ($d1Total/$i)
	$d2Avg = ($d2Total/$i)
	$d3Avg = ($d3Total/$i)
	Write-Host -ForegroundColor White ("{0,-8:hh:mm:ss}" -f (Get-Date)) -NoNewline
	If($d1ResponseTime -ge ($d1Avg * 2)){
		Write-Host -ForegroundColor Red ("{0,10} ms" -f $d1ResponseTime) -NoNewline} Else{
		Write-Host -ForegroundColor White ("{0,10} ms" -f $d1ResponseTime) -NoNewline}
	If($d2ResponseTime -ge ($d2Avg * 2)){
		Write-Host -ForegroundColor Red ("{0,7} ms" -f $d2ResponseTime) -NoNewline} Else{
		Write-Host -ForegroundColor White ("{0,7} ms" -f $d2ResponseTime) -NoNewline}
	If($d3ResponseTime -ge ($d3Avg * 2)){
		Write-Host -ForegroundColor Red ("{0,7} ms" -f $d3ResponseTime)} Else{
		Write-Host -ForegroundColor White ("{0,7} ms" -f $d3ResponseTime)}
	Sleep $interval
}Until(
	$i -ge $loops
	)
