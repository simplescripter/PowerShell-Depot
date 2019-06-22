Clear-Host
$message = Read-Host "Enter your message"
$mixedWord = $null
$words = $message.split()
foreach($word in $words){
	If($word.Length -lt 4){
		$mixedWord += $word + " "
		#$mixedWord
	}else{		
		$first = $word.substring(0,1)
		$last = $word.substring(($word.length - 1),1)
		$middleLetters = $word.Substring(1,($word.Length -2))
		$midLetterCount = $middleLetters.Length
		$randomOrder = $middleLetters.ToCharArray() | Get-Random -Count $midLetterCount | Out-String
		$randomOrder = $randomOrder -replace "`n"
		$mixedWord += $first + $randomOrder + $last + " "
		#$mixedWord
	}
}

$mixedWord