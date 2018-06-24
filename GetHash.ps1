# From http://www.vistax64.com/powershell/207882-get-md5-digest-powershell.html
function Global:Get-Hash ($file) {
 $hasher = [System.Security.Cryptography.MD5]::Create()
 $inputStream = New-Object System.IO.StreamReader ($file)
 $hashBytes = $hasher.ComputeHash($inputStream.BaseStream)
 $inputStream.Close()
 $builder = New-Object System.Text.StringBuilder
 $hashBytes | Foreach-Object { [void] $builder.Append($_.ToString("X2")) }
 $output = New-Object PsObject
 $output | Add-Member NoteProperty HashValue ([string]$builder.ToString())
 $output.hashvalue
}
 
