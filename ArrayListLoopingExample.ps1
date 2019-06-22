# An example of looping through an arraylist of computer names and removing
# those names that responded.  Loops until all systems have been contacted.

[System.Collections.ArrayList]$computerList = 'LON-DC1','LON-SVR1','LON-CL1'
Do {
    [array]$list = $computerList
    ForEach($computer in $list){
        If(Test-Connection -ComputerName $computer -Count 1 -Quiet){
            $computerList.Remove($computer)
        }
    }
    If($computerList.Count -gt 0){Start-Sleep 5}
}Until($computerList.Count -eq 0)
Write-Host 'All systems in $computerList have been contacted.' -ForegroundColor DarkCyan -BackgroundColor Yellow