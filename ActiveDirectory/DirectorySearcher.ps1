$root = [ADSI]""
$rootDN = $root.distinguishedName
$searcher = New-Object System.DirectoryServices.DirectorySearcher $rootDN
$name = Read-Host "What name are you looking for?"
$searcher.Filter = "(&(objectCategory=user)(sAMAccountName=$name))"
($searcher.Findall())[0].properties