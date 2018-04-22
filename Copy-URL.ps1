Function Copy-Cam{
	Param(
		$script:camURL = $(Read-Host "URL")
	)
	If (! $sourcefile){
		$script:sourcefile = 'C:\Users\Shawn.ELYSIUM\Desktop\Anony fun\anony-stripped.htm'
		}
	
	Get-content $sourcefile | Where-Object{$_ -like "*$camURL*"}
}

Function Swap{
	Param(
		$filePath = 'C:\Users\Shawn.ELYSIUM\Desktop\Anony fun\anony-on-06.htm'
	)
	If(!(Test-Path $filePath)){
		"<table border=1>  <tbody>" | Out-File $filePath
	}
	If((Get-Content $filePath | Measure-Object).count -ge 10){
		Write-Host -ForegroundColor Red "$filePath is full."
		Return
		}
	$line = Copy-Cam
	$line | Out-File $filePath -Append
	(Get-Content $sourcefile) -notlike "*$camURL*" | Out-File $sourcefile
}