Function Get-Quote {
    Param(
        $uri = 'http://www.quotationspage.com/qotd.html',
        [ValidateRange(1,4)]
        [int]$numberOfQuotes = 4
    )
    
    #$today = (Get-Date).GetDateTimeFormats()[8] # Get current date in "Month Day, Year" format
    $page = Invoke-WebRequest $uri
    
    #As an alternative to the following approach, consider using multi-line regex mode modifier as seen here:
    # https://www.apharmony.com/software-sagacity/2014/08/multi-line-regular-expression-replace-in-powershell/
    $anchorString = 'Michael Moncur'
    $quote = $page.Content.Split("`n") | Select-String $anchorString -Context 0,7
    $quote = $quote -replace '> <div.*</div>',''
    $quote = $quote -replace '</a> </dt>.*"/quotes/\w+/">',' '
    $quote = $quote -replace '</a>.*class="author".*"/quotes/[\w\.]+/">',' '
    $quote = $quote -replace '.*class="quote".*html">',''
    $quote = $quote -replace '</dd>',''    
    $quote = $quote -replace '&nbsp;.*>',''
    $quote = $quote -replace '</[abi]>',''
    $quote = $quote -replace '<i>',''
    $quote = $quote -replace '\n\s*\n',"`n"
    $quote = $quote -replace '<br>',''
    $quote = $quote -split "`n" | Select -Skip 1
    For($i=0;$i -le $numberOfQuotes - 1;$i++){
        Write-Output $quote[$i] `n 
    }
}