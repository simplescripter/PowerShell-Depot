Function Get-Frequency {
    # A function to do a basic alphabetic letter frequency count on a piece of text
    Param(
        [Parameter(Mandatory=$true)]
        [string]$string
    )
    [string]$string = $string -replace"\W","" # Remove non-word characters from the string
    [string]$string = $string -replace"\d","" # Remove digits from the string
    [string]$string = $string.ToLower() # Convert string to lower case
    [int]$TotalChars = $string.Length
    ForEach($letter in 97..122){
        [char]$letter = $letter
        [int]$letterTotalChars = ($string.Replace("$letter","")).Length
        $properties = @{
            "Letter" = $letter
            "Number of Occurences" = ($TotalChars - $letterTotalChars)
            "Frequency %" = [math]::Round((($TotalChars - $letterTotalChars)/ $TotalChars) * 100,2)
            }
        New-Object -TypeName PSObject -Property $properties
    }
}
    