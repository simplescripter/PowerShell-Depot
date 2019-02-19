Param(
    [Parameter(Mandatory=$true)]
    [string]$location
)

ForEach($publisher in (Get-AzVmImagePublisher -Location $location | Select-Object -ExpandProperty PublisherName)){
    ForEach($type in (Get-AzVmExtensionImageType -Location $location -PublisherName $publisher | Select-Object -ExpandProperty Type)){
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