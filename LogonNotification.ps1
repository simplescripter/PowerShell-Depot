# Code to monitor logons on a set of computers.  The code takes as input one or more computer names, 
# then registers a WMI event for each computer.  It monitors changes to the Win32_ComputerSystem
# class.  When a user logs on, the class is modified, and the script reports who just logged on,
# when and where.  The ForEach loop is required because the -ComputerName parameter of the Register-WMIEvent
# class does not support multiple values, so instead of a single event subscription being registered asynchronously (like
# in VBScript, for example), you need to register multiple event subscriptions.

$i = 0 # we need unique -SourceIdentifier parameters for each event subscription, so we'll use a counter
"LON-CLI1", "LON-SVR1", "LON-SVR2" | # There are lots of other ways we could pipe computer names in
	ForEach-Object {
		If(Test-Connection -ComputerName $_ -Count 1 -Quiet){
			$i++
			Register-WmiEvent -Query "Select * From __instanceModificationEvent within 5 Where
				targetinstance isa 'Win32_ComputerSystem'" `
				-ComputerName $_ `
				-SourceIdentifier "LogonMon$i" `
				-Action {
					If($user = $Event.SourceEventArgs.NewEvent.TargetInstance.UserName){
						$machine = $Event.SourceEventArgs.NewEvent.TargetInstance.__SERVER
						Write-Host "$(Get-Date) $user Logged on to $machine" -ForegroundColor Green
						"$(Get-Date) $user Logged on to $machine" | Out-File "C:\logons.txt" -append
					}
				}
		}
	}