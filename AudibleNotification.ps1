$obj = New-Object System.Media.SoundPlayer
$obj.SoundLocation = "C:\Users\Shawn.ELYSIUM\Documents\Classes\Scripting Reference\PowerShell\psinvaders\samples\insertcoin.wav"
$ok = $false
Do{
    Sleep 5
    If(Test-NetConnection 8.8.8.8 -InformationLevel Quiet){
        $obj.Play()
        Sleep 1
        $obj.Play()
        Sleep 1
        $obj.Play()
        Sleep 1
        $obj.Play()
        Sleep 1
        $obj.Play()
        $ok = $true
    }
}Until($ok -eq $true)