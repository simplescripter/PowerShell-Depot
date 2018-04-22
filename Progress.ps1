for($i = 327; $i -lt 412; $i++ ) {
	$percent = (($i/412)*100)
	$actual = "{0:N}" -f $percent
 	write-progress -activity "Counting Down" -status "Percent Total Hours Complete (Actual = $actual)" -percentcomplete $percent
	for($j = 1; $j -lt 101; $j++){
		Sleep -Milliseconds 600
		write-progress -activity "Counting Down" -status "Minute Tracker" -percentcomplete $j -Id 1
		}
	}