$query = "Select * From __InstanceModificationEvent within 5 Where TargetInstance
	ISA 'ds_group' AND TargetInstance.ds_name = 'Domain Admins'"
Register-WMIEvent -query $query -namespace "root/directory/LDAP" -sourceIdentifier "AdminChange" `
	-action {Write-Host "Domain Admins has changed!!!" -Foregroundcolor Red -BackgroundColor Black}
