<#
.SYNOPSIS
A function to make use of a cellular provider's SMS gateway to send a text through email
.DESCRIPTION
Many cellular carriers provide an SMS gateway service that forwards SMTP email as a text message.  The "mail to" attribute is the phone number of the recipient,
and the destination domain is the SMS gateway of the recipient's cellular provider.
.PARAMETER Provider
The name of the recipient's cellular provider.  
.PARAMETER smtpServer
The FQDN of an SMTP server you have access to route email through.  Some common web-based SMTP services are:
        GMail................ smtp.gmail.com
        Outlook.............. smtp-mail.outlook.com
        Yahoo................ smtp.mail.yahoo.com
.PARAMETER smtpPort
The port number of the SMTP server.  Traditional SMTP is port 25, but most servers now require a secure connection. SMTP over SSL is usually defined on port 465,
and SMTP over TLS is usually defined on port 587
.PARAMETER smtpUserName
The user name with permission to use the SMTP server.  You may need to reduce the security of the mail account to authenticate to the SMTP server.  For example, 
you can adjust Yahoo account settings under Account Security --> Allow apps that use less secure sign in
.PARAMETER smtpPassword
Password for SMTP user
.PARAMETER cellNumberToText
The cell number you want to text.  Must be on the provider's network defined by the "provider" parameter
.PARAMETER subject
"Subject" of the text.  The subject might appear in parenthesis to the left of the text message, or it might not appear in the resulting text
.PARAMETER textMessage
The text message
.EXAMPLE
Send-TextMessage -provider Verizon -smtpServer smtp.mail.yahoo.com -smtpPort 587 -smtpUserName some_user@yahoo.com -smtpPassword Pa55w.rd `
-cellNumberToText 3035551234 -subject 'Hello!' -textMessage 'Here's my message'
#>

Function Send-TextMessage {
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

        $smtpPassword, # Can't cast as [string] because converting to securestring will fail

        [Parameter(Mandatory=$true)]
        [int64]$cellNumberToText,

        [string]$subject = $(Get-Date),

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
        Subject = (Get-Date)
        Body = $textMessage
        SmtpServer = $smtpServer
        Port = $smtpPort
        Credential = $credential
        UseSsl = $true
    }
    Send-MailMessage @mailValues
}

