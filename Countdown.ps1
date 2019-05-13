Param (
    $startingPage = 1
)
For($i = $startingPage; $i -le 607;$i++){
    Write-Host "Page $i, pages remaining = $(607 - $i), percent remaining = $(100 - [math]::Round((($i / 607)*100),2))" -NoNewline -ForegroundColor DarkGray 
    Read-Host   
}