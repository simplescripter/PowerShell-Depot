#A *Nix-like uptime function, from student Timothy Kite
function Get-Uptime {
	Param( $computer = "localhost" )
	$os = Get-WmiObject Win32_OperatingSystem -ComputerName $computer
	$uptime = (Get-Date) - $os.ConvertToDateTime($os.LastBootUpTime)
    $now = "$((Get-Date).Hour):$((Get-Date).Minute)"
    $users = Get-WmiObject Win32_ComputerSystem -ComputerName $computer | select Username | Measure-Object | select -ExpandProperty Count
    $loadAverage = Get-WmiObject win32_processor -ComputerName $computer | Measure-Object -Property LoadPercentage -Average | 
        select -ExpandProperty Average
    return "[$now] System $computer up " + $uptime.Days + " days, " + $uptime.Hours + ":" + $uptime.Minutes + ", " + 
        $users + " users, load average: " + $loadAverage
}get-