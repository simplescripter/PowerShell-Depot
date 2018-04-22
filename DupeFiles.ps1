Param(
	$dir = (Get-Location),
	$moveOrdelete = "move", #use "move" or "delete"
	$moveDir = "C:\Users\Shawn.Elysium\Desktop\50331 to Delete\dupes", # path to a directory to store duplicates when moving
	$maxFiles = 100 #maximum number of file duplicates to move or delete
	)
If($moveOrdelete -eq "move"){
	If(-not (Test-Path $moveDir)){
		Throw "Directory $moveDir does not exist.  Exiting."
		Break
		}
	$dupeFiles = Get-ChildItem $dir -Recurse | 
		Group-Object Name, Length, LastWriteTime |
		Where-Object {$_.Count -gt 1}
	ForEach($fileName in $dupeFiles){
		ForEach($file in $fileName.Group[1..$maxFiles]){Write-Host -ForegroundColor Green "Moving" $file.FullName "to $moveDir"}
		if($fileName.Count -eq 2){
			ForEach-Object{$fileName.Group[1..$maxFiles]} |
			Move-Item -Destination $moveDir}
		else{
			$dupes = $fileName.Group[1..$maxFiles]
			ForEach($duplicate in $dupes){
				Move-Item -Path $duplicate.Fullname -Destination (("$movedir\" + $duplicate.Name) + "_" + (Get-Random))
				}
			}
	}
}
Else{
	$dupeFiles = Get-ChildItem $dir -Recurse | 
		Group-Object Name, Length, LastWriteTime |
		Where-Object {$_.Count -gt 1}
	ForEach($file in $dupeFiles){
		Write-Host -ForeGroundColor Green "Deleting" $file.group[0]
		$file.Group[1..$maxFiles] |
		Remove-Item}
	}