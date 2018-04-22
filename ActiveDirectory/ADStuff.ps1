$root = [ADSI]""
$domain = $root.distinguishedName
$binding = [ADSI]"LDAP://$domain"
$OU = Read-Host "Enter the OU Name"
$newOU = $binding.Create("OrganizationalUnit", "OU=$OU")
$newOU.SetInfo()
$userFirstName = Read-Host "Enter User's First Name"
$userLastName = Read-Host "Enter User's Last Name"
$userUPN = Read-Host "Enter User's UPN Logon"
$userPass = Read-Host -AsSecureString "Enter User's Password"
$global = Read-Host "Enter Name for Global Group"
$local = Read-Host "Enter Name for Local Group"
$user = $newOU.Create("user", "CN=$userFirstName $userLastName")
$user.Put("sAMAccountName", $userFirstName)
$user.Put("givenName", $userFirstName)
$user.Put("sn", $userLastName)
$user.Put("userPrincipalName", $userUPN)
$user.SetInfo()
$user.psbase.Invoke("SetPassword", "$userPass")
$user.psbase.CommitChanges()
$newGlobal = $newOU.Create("group","CN=GG_$global")
$newGlobal.SetInfo()
$newLocal = $newOU.Create("group","CN=DLG_$local")
$newLocal.Put("groupType", "-2147483644")
$newLocal.SetInfo()
$newGlobal.add("LDAP://"+$user.distinguishedname)
$newLocal.add("LDAP://"+$newGlobal.distinguishedname)