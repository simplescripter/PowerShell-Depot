Param(
    [Parameter(Mandatory=$true)]
    [string]$location
)

# Check for Azure login:

Try{
    Get-AzContext -ErrorAction Stop | Out-Null
}Catch{
    Add-AzAccount
}

$publishers = Get-AzVmImagePublisher -Location $location | Select-Object -ExpandProperty PublisherName
$publisherCount = $publishers.Count
$count = 0
ForEach($publisher in $publishers){
    $count++
    Write-Progress -Activity 'Enumerating Publisher:' -Status $publisher -PercentComplete ($count/$publisherCount * 100)
    $types = Get-AzVmExtensionImageType -Location $location -PublisherName $publisher | Select-Object -ExpandProperty Type
    ForEach($type in $types){
        If(Get-AzVMExtensionImage -Location $location -PublisherName $publisher -Type $type -ErrorAction SilentlyContinue){
            $properties = @{
                'Publisher' = $publisher
                'Type' = $type
            }
            $object = New-Object -TypeName PSObject -Property $properties
            Write-Output $object
        }
    }
}