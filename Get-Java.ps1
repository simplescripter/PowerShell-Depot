Function Get-Java{
	Param(
		[switch]$raw,
		[switch]$novisualization
		)
	$counter = "\Process(javaw)\Working Set - Private"
	$sample = Get-Counter $counter
	If($raw){
		Write-OutPut $sample
		}
	Else{
		$text =	"JAVAW Private Working Set Memory at $((Get-Date).ToLongTimeString()): {0:N2} MB" -f ($($sample.CounterSamples).CookedValue / 1MB)
		If($novisualization){
			Write-Host -ForegroundColor DarkGreen $text
			}
		Else{
			Write-Host -ForegroundColor DarkGreen "$text $("I" * (($($sample.CounterSamples).CookedValue / 1MB) / 10))"
			}
		}
	}