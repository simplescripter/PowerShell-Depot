$sourcePath = "http://checkip.dyndns.org"
$web = new-object system.net.webclient
$raw = $web.DownloadString($sourcePath)
$raw -match "\d{1,3}\.\d{1,3}\.\d{1,3}\.\d{1,3}" | Out-Null
$currentIP = $matches.values
If(!(Test-Path "$($psscriptroot)\CurrentIP.txt")){
    $currentIP | Out-File "$($psscriptroot)\CurrentIP.txt"
    Send-MailMessage -From "nobodaddy@nowhere.net" -To "stugart@gmail.com" -Subject "IP ADDRESS CHANGE" -SmtpServer 192.168.1.2 -Body $currentIP
    }
Else{
    If((Get-Content "$($psscriptroot)\CurrentIP.txt" | Select -first 1) -ne ($currentIP | Select -first 1)){
        $currentIP | Out-File "$($psscriptroot)\CurrentIP.txt" -Force
        Send-MailMessage -From "nobodaddy@nowhere.net" -To "stugart@gmail.com" -Subject "IP ADDRESS CHANGE" -SmtpServer 192.168.1.2 -Body $currentIP
    }
}


