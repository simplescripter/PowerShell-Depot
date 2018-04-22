Function Get-DiceWarePassword {
    Param(
            $filePath = "C:\Users\shawn.ELYSIUM\Documents\Scripting Reference\diceware.wordlist.txt",
            $numberOfWords = 5
        )
    $wordList = Import-CSV -Delimiter "`t" -Path $filePath -Header 'Number','Value'
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