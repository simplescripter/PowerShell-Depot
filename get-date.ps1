Function global:Date-Stamp()
  {
  Write-Host -ForegroundColor "Red" $i `t (Get-Date)
  $global:i++
  if(!(Read-Host -prompt "Enter to Continue, any other key to cancel")){
    Date-Stamp
    }
  }