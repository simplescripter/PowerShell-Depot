$obj = New-Object System.Media.SoundPlayer
$obj.SoundLocation = "D:\Users\Shawn.ELYSIUM\Documents\Scripting Reference\PowerShell\psinvaders\samples\insertcoin.wav"
$ok = $false
Do{
    Sleep 20
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
        Sleep 1
        $obj.Play()
        Sleep 1
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