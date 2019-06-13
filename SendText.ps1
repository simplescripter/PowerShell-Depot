# may need to reduce security of the mail account to authenticate to the SMTP server.  For Yahoo, Account Security --> Allow apps that use less secure sign in
Function Send-Text {
    Param(
    [Parameter(Mandatory=$true)]    
    [ValidateSet(
            'Verizon',
            'ATT',
            'TMobile',
            'Sprint',
            'VirginMobile',
            'Tracfone',
            'MetroPCS',
            'BoostMobile',
            'Cricket'
        )]
        [string]$provider,

        [Parameter(Mandatory=$true)] 
        [string]$smtpServer,

        [Parameter(Mandatory=$true)] 
        [int]$smtpPort,

        [string]$smtpUserName,

        $smtpPassword,

        [Parameter(Mandatory=$true)] 
        [int64]$cellNumberToText,

        [string]$textMessage
    )
    Switch ($provider){
        Verizon {$domain='vtext.com'}
        ATT {$domain='txt.att.net'}
        TMobile{$domain='tmomail.net'}
        Sprint{$domain='messaging.sprintpcs.com'}
        VirginMobile{$domain='vmobl.com'}
        Tracfone{$domain='mmst5.tracfone.com'}
        MetroPCS{$domain='mymetropcs.com'}
        BoostMobile{$domain='sms.myboostmobile.com'}
        Cricket{$domain='sms.cricketwireless.net'}
    }
    $smtpPassword = ConvertTo-SecureString $smtpPassword -AsPlainText -Force
    $credential = New-Object System.Management.Automation.PSCredential($smtpUserName,$smtpPassword)
    $mailValues = @{
        From = $smtpUserName
        To = "$cellNumberToText@$domain"
        Subject = 'Send-Text'
        Body = $textMessage
        SmtpServer = $smtpServer
        Port = $smtpPort
        Credential = $credential
        UseSsl = $true
    }
    Send-MailMessage @mailValues
}

