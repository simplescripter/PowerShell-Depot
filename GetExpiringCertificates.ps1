$numberOfDays = 1000
$deadline = (Get-Date).AddDays($numberOfDays)
$results = $null
$computers = Get-Content "E:\computers.txt"
ForEach($computer in $computers){
    $certStore = New-Object System.Security.Cryptography.X509Certificates.X509Store("\\$computer\My","LocalMachine")
	$certStore.Open("ReadOnly")
    $results += $certStore.certificates | ForEach-Object{
        If ($_.NotAfter -lt $deadline){
            $_ | Select Issuer, Subject, NotAfter, @{Label = "Expires In (Days)"; Expression={($_.NotAfter - (Get-Date)).Days}}
        }
    }
}
$results