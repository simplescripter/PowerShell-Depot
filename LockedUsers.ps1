Function Global:Get-LockedUser{
	Import-Module ActiveDirectory
	Get-ADUser -filter * -Properties lockedOut|
		Where-Object {$_.lockedout -eq $true}
}