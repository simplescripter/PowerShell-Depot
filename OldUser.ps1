Function Global:Get-OldUser{
	Param(
		$days = 90,
		$ignoreNewUsers = $true
		)
	Import-Module ActiveDirectory
	$interval = New-TimeSpan -Days $days
	If($ignoreNewUsers){
		Get-ADUser -filter * -Properties lastlogontimestamp |
			Where-Object{($_.lastlogontimestamp) -and ([datetime]::FromFileTime($_.lastlogontimestamp) -le ((Get-Date) - $interval))}
		}
	Else{
		Get-ADUser -filter * -Properties lastlogontimestamp |
			Where-Object{[datetime]::FromFileTime($_.lastlogontimestamp) -le ((Get-Date) - $interval)}
		}
}