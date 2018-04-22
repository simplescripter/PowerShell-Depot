Workflow PingSweep{
    $computers = @()
    For ($i = 1; $i -le 254; $i++){$computers += "192.168.1.$i"}
    ForEach -Parallel ($computer in $computers){
        If(Test-Connection -computerName $computer -count 1 -quiet){
            Write-Output -InputObject "$computer,ONLINE"
        }else{
            Write-Output -InputObject "$computer,OFFLINE"
        }
    }
}

PingSweep | ForEach{
    $ip = $_.Split(",")[0]
    $status = $_.Split(",")[1]
    If($status -eq 'ONLINE'){
        Write-Host "$ip" -ForegroundColor Green
    }Else{
        Write-Host "$ip" -ForegroundColor Red
    }
}