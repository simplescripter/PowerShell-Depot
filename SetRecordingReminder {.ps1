Function Global:Set-RecordingReminder {
    Param(
        [string]$soundFile = "D:\Users\Shawn.ELYSIUM\Documents\Scripting Reference\PowerShell\psinvaders\samples\insertcoin.wav",
        [Parameter(Mandatory=$true)]
        [datetime]$reminderTime,
        [int]$offset = 30 # number of seconds earlier than $ReminderTime to set reminder
    )
    $obj = New-Object System.Media.SoundPlayer
    $obj.SoundLocation = $soundFile
    Do{
        Start-Sleep 10
    }Until((Get-Date) -ge (($reminderTime).AddSeconds(-$offset)))
    For($i=1;$i -le 3;$i++){
        $obj.Play()
        Start-Sleep 1
    }
}