For ($i = 1; $i -lt 255; ++$i){
 If(Test-Connection "192.168.0.$i" -Count 1 -Quiet){
  Write-Host -ForegroundColor Green "192.168.0.$i"
  }
 Else{
  Write-Host -ForegroundColor Red "192.168.0.$i"
  }
 }
 