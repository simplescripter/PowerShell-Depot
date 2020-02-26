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

# Build an Out-Gridview pipeline for display of available VM extensions:

$location = Get-AzureRmLocation | Out-GridView -OutputMode Single -Title "SELECT A LOCATION AND CLICK OK" | Select-Object -ExpandProperty Location
$publisher = Get-AzureRmVMImagePublisher  -Location $location | Out-GridView -OutputMode Single -Title "SELECT A PUBLISHER AND CLICK OK" | Select-Object -ExpandProperty PublisherName
$type = Get-AzureRmVMExtensionImageType -Location $location -PublisherName $publisher | Out-GridView -OutputMode Single -Title "SELECT A TYPE AND CLICK OK" | Select-Object -ExpandProperty Type 
Try {
    Get-AzVMExtensionImage -Location $location -PublisherName $publisher -Type $type -ErrorAction Stop
}Catch {
    Write-Host "No extensions types for publisher $publisher in $location" -ForegroundColor DarkCyan -BackgroundColor  DarkRed
}
