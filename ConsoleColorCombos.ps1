# Displays the possible combinations of console colors, foreground and background

# Possible console text and background colors:
$colors = 
    'Black',
    'Blue',
    'Cyan',
    'DarkBlue',
    'DarkCyan',
    'DarkGray',
    'DarkGreen',
    'DarkMagenta',
    'DarkRed',
    'DarkYellow',
    'Gray',
    'Green',
    'Magenta',
    'Red',
    'White',
    'Yellow'

    ForEach ($foregroundColor in $colors){
        ForEach ($backgroundColor in $colors){
            Write-Host "$foregroundColor on $backgroundColor" -ForegroundColor $foregroundColor -BackgroundColor $backgroundColor
        }
    }



