$number = 224
$decimal = $number
$binary = @()
Do{
	$binary += ($decimal % 2)
	$decimal /=2
	$decimal = [Math]::Floor($decimal)
	} While ($decimal -ge 1)
[array]::Reverse($binary)
"Binary for $number is $binary"