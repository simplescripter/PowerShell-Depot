Import-Module ActiveDirectory
$domain = "DC=Contoso,DC=Com"
$OUs = Get-ADOrganizationalUnit -Filter * | Select-Object Name
$OUarray = @()
ForEach($name in $OUs){
	$OUarray+= $name.name
	}
ForEach($computer in (Get-ADComputer -filter * -SearchBase "CN=Computers,$domain")){
	$first5 = ($computer.Name).SubString(0,5)
	If($OUarray -contains "$first5"){
		Move-ADObject $computer "OU=$first5,$domain"
		Write-Host "Moved $computer to OU=$first5,$domain"
		}
	}
