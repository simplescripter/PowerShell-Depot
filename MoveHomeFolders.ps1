$OldPath = "C:\Home"
$NewPath = "D:\HomeArchive"
$UserList = "C:\users.txt"

Get-Content $UserList | foreach{
    Copy-Item -Recurse -Force $OldPath\$_ $NewPath\$_ -ErrorVariable moveErr -ErrorAction SilentlyContinue
    If ($moveErr = $NULL){
        Write-Host -ForeGroundColor red $_ ": MOVE FAILED"
	$moveErr = $NULL}
    Else{
	Remove-Item -Recurse -Force $OldPath\$_
	Write-Host -ForeGroundColor green $_ ": SUCCESS"
        }
}