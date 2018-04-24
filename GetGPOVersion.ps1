Import-Module GroupPolicy
Get-GPO -all |
	Select-Object DisplayName, `
	@{Label='User AD';Expression={$_.User.DSVersion}}, `
	@{Label='User SysVol';Expression={$_.User.SysVolVersion}}, `
	@{Label='Computer AD';Expression={$_.Computer.DSVersion}}, `
	@{Label='Computer SysVol';Expression={$_.Computer.SysVolVersion}} |
	Format-Table -auto