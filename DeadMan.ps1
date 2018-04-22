# The WriteTo-Pos function is taken from Tibor Soos at
# http://blogs.technet.com/b/heyscriptingguy/archive/2010/03/26/hey-scripting-guy-march-26-2010.aspx?Redirected=true
# It doesn't work in the PowerShell ISE, only in the console, so if you want to  see the deadman seconds counting
# down, you need to run Dead-Man from an ordinary PowerShell console.

function WriteTo-Pos ([string] $str, [int] $x = 0, [int] $y = [console]::CursorTop, # adjusted this to do countdown in-line with PS prompt
      [string] $bgc = [console]::BackgroundColor, 
      [string] $fgc = [Console]::ForegroundColor)
{
      if($x -ge 0 -and $y -ge 0 -and $x -le [Console]::WindowWidth -and 
            $y -le [Console]::WindowHeight) 
      {
            $saveY = [console]::CursorTop
            $offY = [console]::WindowTop        
            [console]::setcursorposition($x,$offY+$y)
            Write-Host -Object $str -BackgroundColor $bgc `
                  -ForegroundColor $fgc -NoNewline
            [console]::setcursorposition(0,$saveY)
      }
}

#The Dead-Man function is mine, but it uses a couple of the techniques from the same source,
# http://blogs.technet.com/b/heyscriptingguy/archive/2010/03/26/hey-scripting-guy-march-26-2010.aspx?Redirected=true

Function Dead-Man{
# An example of a PowerShell "dead man" switch.  Someone must press a key within numSec number of seconds, or the script
# will quit/continue/whatever.  If a key is clicked, the counter starts over at numSec again.

    Param(
        $numSec = 5
    )
    $originalLength = $numSec.ToString().Length
    Do{
        $key = $null
        For($i = $numSec;$i -ge 0;$i--){ #For loop is so we can display an update each second
            WriteTo-Pos "$i$(' ' * $($originalLength - $i.ToString().Length))"  # This code is because the countdown will display digits from earlier columns without it.
            # So we get the original number of digits in numSec, then multiply the difference between the original number of digits and the current number by a space character.
            # This way, the WriteTo-Pos function will add extra space after shorter digits to hide the previous columns in the countdown.
            If([console]::KeyAvailable){break} #If is necessary to restart timer when a key is pressed
            Sleep 1
        }
        while([console]::KeyAvailable){  # Can't use $host variable here
            $key = [console]::Readkey("NoEcho").Key # ...or here
        }
        If($key -eq $null){
            Write-Host "DEAD MAN!"
            [System.Media.SystemSounds]::Hand.Play()
            Sleep -Milliseconds 500
            [System.Media.SystemSounds]::Hand.Play()
            Sleep -Milliseconds 500
            [System.Media.SystemSounds]::Hand.Play()
            break
        }
        #Write-Host "Current key is $key"
    }While($true)
}