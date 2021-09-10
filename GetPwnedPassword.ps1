Function Get-PwnedPassword {
    Param(
        [string]$passwordString,

        [switch]$showHashes
    )

    # If a cleartext password wasn't provided, prompt for the password and obscure the typing:

    If($passwordString -eq ''){
        $securePasswordString = Read-Host 'Enter the password string:' -AsSecureString

        # Extract the password string for processing:

        $passwordString = (New-Object PSCredential "user",$securePasswordString).GetNetworkCredential().Password
    }

    [System.Net.ServicePointManager]::SecurityProtocol = [System.Net.SecurityProtocolType]::Tls12
    $passwordStringBuilder = New-Object System.Text.StringBuilder
    $byteArray = [System.Security.Cryptography.HashAlgorithm]::Create('SHA1').ComputeHash([System.Text.Encoding]::UTF8.GetBytes($passwordString))
    ForEach ($byte in $byteArray) {
        [Void]$passwordStringBuilder.Append($byte.ToString("x2"))
    }
    $hash = $passwordStringBuilder.ToString()
    $prefix = $hash.Substring(0,5)
    $suffix = $hash.Substring(5,35)
    $results = Invoke-RestMethod -Uri https://api.pwnedpasswords.com/range/$prefix
    # Results are a single long string. Need to break out the individual hashes and number of matches:
    $results =  ($results | Select-String  "(\w{35}:\d{1,})" -AllMatches).Matches.Value
#    If($showHashes){
#        ForEach($hash in $results){
#            Write-Host $hash
#        }
#    }
    $unmatched = $true
    ForEach($entry in $results){
        If($showHashes){
            Write-Host $prefix$entry
        }
        $entry = $entry.split(':')
        If($entry[0] -eq $suffix){
            Write-Host "THAT PASSWORD HAS BEEN SEEN IN $($entry[1]) BREACHES!!!" -ForegroundColor White -BackgroundColor DarkRed
            $unmatched = $false
            Break
        }
    }
    If($unmatched){
        Write-Host 'Congratulations, that password does not appear to be exposed' -ForegroundColor Black -BackgroundColor White
    }
}

