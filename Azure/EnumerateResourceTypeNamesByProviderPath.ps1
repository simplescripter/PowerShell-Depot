# Look for Az module and, if present, load the equivalent -AzureRm aliases:

If(Get-Module -ListAvailable Az.*){
    Enable-AzureRmAlias
}

# Check for Azure login:

Try{
    Get-AzureRmContext -ErrorAction Stop 
}Catch{
    Add-AzureRmAccount
}
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