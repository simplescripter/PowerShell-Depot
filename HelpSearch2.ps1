cls
Set-Location $PSHOME\En-Us
Get-Childitem about* | 	
	Select @{Label="FullName";Expression={$_.fullname}},
		@{Label="Text"; Expression={"$(cat $_.FullName)"}} |		
	Select-String -inputobject $fullname "\bregex\b" -List | select fullname