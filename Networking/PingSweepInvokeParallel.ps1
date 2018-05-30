# Requires Rambling Cookie Monster's Invoke-Parallel function: https://gallery.technet.microsoft.com/scriptcenter/Run-Parallel-Parallel-377fd430/view/Discussions

1..254 | Invoke-Parallel -Throttle 32 -ScriptBlock {
    If(Test-Connection "192.168.1.$_" -Count 1 -Quiet){
        Write-Host "192.168.1.$_`n" -ForegroundColor Green -NoNewline
    }Else{
        Write-Host "192.168.1.$_`n" -ForegroundColor Red -NoNewline
    }
}