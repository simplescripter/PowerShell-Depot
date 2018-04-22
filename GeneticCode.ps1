<#
A fun exercise in making up a secret code based on the DNA bases ATCG
Of course, close inspection reveals "illegal" base pairs in the secret code (biologically, cytosine always pairs with guanine, 
and adenine always pairs with thymine).

The system uses a base-4 model for performing the switch.  With base-4 math, we can use 4 "digits" to produce 256
unique values.  For example:

            Base-4: 1101
            Decimal (base-10): 81
            1*(4^3) + 1*(4^2) + 0*(4^1) + 1*(4^0) = 64 + 16 + 0 + 1 = 81
            ASCII character 81 = Q

So, encoding the base-4 number "1101" using ConvertTo-DNA, we get "CCAC"

#>
Function ConvertTo-DNA{
	Param(
		$number
		)
	Switch ($number){
		"0"{
			$Script:DNA += "A"
			Break
			}
		"1"{
			$Script:DNA += "C"
			Break
			}
		"2"{
			$Script:DNA += "G"
			Break
			}
		"3"{
			$Script:DNA += "T"
			Break
			}
		}
}

Function ConvertTo-Quad{
	Param(
		[int]$number
		)
	$decimal = $number
	$binary = @()
	Do{
		$binary += ($decimal % 4)
		$decimal /=4
		$decimal = [Math]::Floor($decimal)
		} While ($decimal -ge 1)
	[array]::Reverse($binary)
	ForEach($char in $binary){
		ConvertTo-DNA ($char)
		}
}
$DNA = @()
$message = Read-Host "Enter your secret message"
$message = $message.ToCharArray()
ForEach($character in $message){
	$charNum = [byte][char]$character
	If($charNum -lt 64){
		$DNA+= "A"
		ConvertTo-Quad ($charNum)
	}Else{
	ConvertTo-Quad ($charNum)
	}
}
"$DNA"