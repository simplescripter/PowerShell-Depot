Param(
    [Parameter(Mandatory=$true)]
    [string]$message = 'SOS'
)

$ditLength = 200
$dashLength = $ditLength * 3
$charSpace = $ditLength
$letterSpace = $dashLength
$wordSpace = $ditLength * 4 # because a word break (7 units) will always follow a letter break (3 units), we'll just add 4 units to the 3-unit letter break 
$frequency = 3000

Function dit {
    [console]::Beep($frequency,$ditLength)
}
Function dash {
    [console]::Beep($frequency,$dashLength)
}
Function 1U {
    Start-Sleep -Milliseconds $charSpace
}
Function 3U {
    Start-Sleep -Milliseconds $letterSpace
}
Function 4U {
    Start-Sleep -Milliseconds $wordSpace
}
$messageWords = $message -split "\s+"
ForEach ($word in $messageWords){
    ForEach ($letter in ($word.ToCharArray())){
        Switch ($letter) {
            "A" {
                dit
                1U
                dash
            }
            "B" {
                dash
                1U
                dit
                1U
                dit
                1U
                dit
            }
            "C" {
                dash
                1U
                dit
                1U
                dash
                1U
                dit
            }
            "D" {
                dash
                1U
                dit
                1U
                dit
                1U
            }
            "E" {
                dit
            }
            "F" {
                dit
                1U
                dit
                1U
                dash
                1U
                dit
            }
            "G" {
                dash
                1U
                dash
                1U
                dit
            }
            "H" {
                dit
                1U
                dit
                1U
                dit
                1U
                dit
            }
            "I" {
                dit
                1U
                dit
            }
            "J" {
                dit
                1U
                dash
                1U
                dash
                1U
                dash
            }
            "K" {
                dash
                1U
                dit
                1U
                dash
            }
            "L" {
                dit
                1U
                dash
                1U
                dit
                1U
                dit
            }
            "M" {
                dash
                1U
                dash
            }
            "N" {
                dash
                1U
                dit
            }
            "O" {
                dash
                1U
                dash
                1U
                dash
            }
            "P" {
                dit
                1U
                dash
                1U
                dash
                1U
                dit
            }
            "Q" {
                dash
                1U
                dash
                1U
                dit
                1U
                dash
            }
            "R" {
                dit
                1U
                dash
                1U
                dit
            }
            "S" {
                dit
                1U
                dit
                1U
                dit
            }
            "T" {
                dash
            }
            "U" {
                dit
                1U
                dit
                1U
                dash
            }
            "V" {
                dit
                1U
                dit
                1U
                dit
                1u
                dash
            }
            "W" {
                dit
                1U
                dash
                1U
                dash
            }
            "X" {
                dash
                1U
                dit
                1U
                dit
                1u
                dash
            }
            "Y" {
                dash
                1U
                dit
                1U
                dash
                1u
                dash
            }
            "Z" {
                dash
                1U
                dash
                1U
                dit
                1U
                dit
            }
            1 {
                dit
                1U
                dash
                1U
                dash
                1U
                dash
                1U
                dash
            }
            2 {
                dit
                1U
                dit
                1U
                dash
                1U
                dash
                1U
                dash
            }
            3 {
                dit
                1U
                dit
                1U
                dit
                1U
                dash
                1U
                dash
            }
            4 {
                dit
                1U
                dit
                1U
                dit
                1U
                dit
                1U
                dash
            }
            5 {
                dit
                1U
                dit
                1U
                dit
                1U
                dit
                1U
                dit
            }
            6 {
                dash
                1U
                dit
                1U
                dit
                1U
                dit
                1U
                dit
            }
            7 {
                dash
                1U
                dash
                1U
                dit
                1U
                dit
                1U
                dit
            }
            8 {
                dash
                1U
                dash
                1U
                dash
                1U
                dit
                1U
                dit
            }
            9 {
                dash
                1U
                dash
                1U
                dash
                1U
                dash
                1U
                dit
            }
            0 {
                dash
                1U
                dash
                1U
                dash
                1U
                dash
                1U
                dash
            }
        }
        3U #delay between letters
    } # End ForEach
    4U # delay between words
} # End ForEach