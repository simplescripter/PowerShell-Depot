cls
$a = 0
$b = 1
$c = 0
While($a -lt 10000){
	$c = $a + $b
	Write-Host "$c " -NoNewline
	$b = $a
	$a = $c
}