Param(
    $inputFile = "C:\Users\Shawn.ELYSIUM\Desktop\10325 to Delete\test.csv",
    $outputFile = $inputFile
    )
$results = Import-CSV $inputFile |
    Select Type,ComputerName,@{Name="Success";Expression= `
    {Test-Connection -ComputerName $_.ComputerName -Count 1 -Quiet}}
$results | Export-CSV -Force -NoTypeInformation -Path $outputFile