#this is a work in progress; NOT complete yet

cls
$table = Import-Csv .\test.csv
$keyProperty = "Name"
$properties = $table | Get-Member -MemberType NoteProperty |
	Where-Object {$_.Name -ne $keyProperty} |
	Select Name
$hash = @{}
$headerarray = @()
For($i = 0;$i -lt $properties.count;$i++){
	$headerarray += $($row.(($properties[$i]).name))
}
ForEach ($row in $table){
	$hash[$row.Name] = $headerarray
	$headerarray = @()
}

$hash