Do {
	If(Test-Connection "8.8.8.8" -Count 1 -Quiet -ea SilentlyContinue){
		Write-Host "$(Get-Date) Success"
	} Else{
		Write-Host "$(Get-Date) FAILED" -ForegroundColor Red
	}
	Sleep 10
} Until ((Get-Date) -gt [datetime]"7/19/2012 7:00:00 AM")