cls
$query = "SELECT * FROM __instanceCreationEvent Within 3 WHERE TargetInstance ISA 'Win32_Process'"
Register-WmiEvent -Query $query -Action {Write-Host "$($event.timeGenerated) : $($event.sourceEventArgs.NewEvent.TargetInstance.Name) launched" -ForegroundColor Red}
Set-Alias ue Unregister-Event