Function Decode-DNA{
	Param(
		$block
		)
	$Script:numberBlock = @()
	ForEach($char in $block){
		Switch ($char){
			"A" {
				$Script:numberBlock += 0
				Break
			}
			"C" {
				$Script:numberBlock += 1
				Break
			}
			"G" {
				$Script:numberBlock += 2
				Break
			}
			"T" {
				$Script:numberBlock += 3
				Break
			}
		}		
	}
}
Function ExpandTo-ASCII{
	Param(
		$DNANumbers
		)
	$Script:ASCIINums += [char](($DNANumbers[0] * 64) + ($DNANumbers[1] * 16) `
		+ ($DNANumbers[2] * 4) + ($DNANumbers[3]))
}
$secret = Read-Host "Enter Code to Decode"
$secret = $secret.Split()
$ASCIINums = @()
For($char = $null, $i = 0;$i -le ($secret.Count - 1);$i+=4){
	$char = $secret[$i..($i+3)]
	Decode-DNA ($char)
	ExpandTo-ASCII ($numberBlock)
	}
"$ASCIINums"