Function Get-DiceWarePassword {
    Param(
            $filePath = 'https://raw.githubusercontent.com/simplescripter/PowerShell-Depot/master/DicewarePasswordWordlist.txt', #$filepath is a local path or URL
            $numberOfWords = 5
        )
    If ($filepath -match '^http'){
        $wordList = (Invoke-WebRequest $filePath).Content | ConvertFrom-Csv -Delimiter "`t" -Header 'Number','Value'
    }Else{
        $wordList = Import-CSV -Delimiter "`t" -Path $filePath -Header 'Number','Value'
    }
    $hashList = @{}
    
    # Create a hash table of diceware words
    ForEach ($word in $wordList){
        $hashList.Add($word.Number,$word.Value)
    }


    $password = @()
    For ($i = 1; $i -le $numberOfWords; $i++){
        $randomNumber = @()

        # Simulate rolling a single die 5 times and join the values into an integer

        For ($j = 1; $j -le 5; $j++){
            $randomNumber += Get-Random -Minimum 1 -Maximum 6
        }
        $randomNumber = $randomNumber -join ''

        #Look up the 5-digit number in hash table and add it to our password 
        $password += $hashList."$randomNumber"
    }
    $password = $password -join " "
    Write-Output $password
}