Function Get-PwnedPassword {
    Param(
        [Parameter(Mandatory=$true)]
        [string]$string
    )
    $stringBuilder = New-Object System.Text.StringBuilder
    $byteArray = [System.Security.Cryptography.HashAlgorithm]::Create('SHA1').ComputeHash([System.Text.Encoding]::UTF8.GetBytes($string))
    ForEach ($byte in $byteArray) {
        [Void]$StringBuilder.Append($byte.ToString("x2"))
    }
    $hash = $StringBuilder.ToString()
    $prefix = $hash.Substring(0,5)
    $suffix = $hash.Substring(5,35)
    $results = Invoke-RestMethod -Uri https://api.pwnedpasswords.com/range/$prefix
    # Results are a single long string. Need to break out the individual hashes and number of matches:
    $results =  ($results | Select-String  "(\w{35}:\d{1,})" -AllMatches).Matches.Value
    $unmatched = $true  
    ForEach($entry in $results){
        $entry = $entry.split(':')
        If($entry[0] -eq $suffix){
            Write-Host "$($entry[1]) MATCHES!!!" -ForegroundColor White -BackgroundColor DarkRed
            $unmatched = $false
            Break
        }
    }
    If($unmatched){
        Write-Host 'Congratulations, that password does not appear to be exposed' -ForegroundColor gray -BackgroundColor White
    }
}

