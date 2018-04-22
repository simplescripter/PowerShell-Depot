<#
This is a work in progress.  Currently, the script will create a scheduled task on the
remote machine, BUT

--The script is scheduled for ONE DAY after it runs
--Instead of scheduling the task for the exact second, it schedules it for the
next full minute
--When I try executing the scheduled task manually, it doesn't "speak" anyway

#>

$computer = "XPS"
[WMIClass]$wmi = "\\$computer\root\CIMv2:Win32_ScheduledJob"
$5Seconds = New-TimeSpan -Seconds 5
$OS = gwmi Win32_OperatingSystem -ComputerName $computer
$newTime = ($OS.ConvertToDateTime($OS.LocalDateTime)) + $5Seconds
$scheduleTime = $OS.ConvertFromDateTime($newTime)
$wmi.Create("wscript.exe c:\temptemp\voice.vbs", $scheduleTime, $False, $Null , $Null , $True)

