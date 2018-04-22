# A function to strip the digital signature block from
# a signed script.
# Example 1: dir file.ps1 | Strip-Sig
# Example 2: dir -filter *.ps1 | Strip-Sig
Function global:Strip-Sig()
{
 $sig = "# SIG # Begin signature block"
 ForEach ($_ in $input){
 $j = $null
 Write-Host -ForegroundColor Green "Stripping $_"
 $filestream = cat $_
 Clear-Content $_
 ForEach($i in $filestream)
 {
  if($i -ne $sig)
  {
    $j = $j + $i + "`n";
  }
  Else
  {
   Break
  } 
 }
 Set-Content $_ $j
 }
}


