$results = @()
Get-AzureRmResourceProvider | ForEach-Object {
    $resources = $_ | Select -ExpandProperty ResourceTypes | Select ResourceTypeName
    ForEach($resource in $resources){
        $properties = @{
            ResourceTypeName = "$($resource.ResourceTypeName)"
            ProviderPath = "$($_.ProviderNameSpace)/$($resource.ResourceTypeName)"
        }
        $results += New-Object -TypeName PSObject -Property $properties
    }
}
$results | Sort ResourceTypeName