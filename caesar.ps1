Function Add-Characters{
	Param(
	[char]$i
	)
	If([int]$i + $places -gt 90){
		$result=[char]((([int]$i + $places) - 90) + 64)
	}Else{
		$result=[char]([int]$i + $places)
	}
	Write-Output $result
}
Function Caesar{
	Param(
		[string]$string,
		[int]$places
		)
	#Write-Host "Shifted $places Places"
	ForEach($char in [char[]]$string.ToUpper()){$result+= Add-Characters $char}
	Write-Output "Shifted $places Places: $result"
}