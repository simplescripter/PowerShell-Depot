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

# Build an Out-Gridview pipeline for selection of an Azure Marketplace VM image:

$location = Get-AzureRmLocation | Out-GridView -OutputMode Single -Title "SELECT A LOCATION AND CLICK OK" | Select -ExpandProperty Location
$publisher = Get-AzureRmVMImagePublisher -Location $location | Out-GridView -OutputMode Single -Title "SELECT A PUBLISHER AND CLICK OK" | Select -ExpandProperty PublisherName
$offer = Get-AzureRmVMImageOffer -Location $location -PublisherName $publisher | Out-GridView -OutputMode Single -Title "SELECT AN OFFER AND CLICK OK" | Select -ExpandProperty Offer 
$sku = Get-AzureRmVMImageSKU -Location $location -PublisherName $publisher -Offer $offer |
    Out-GridView -OutputMode Single -Title "SELECT AN SKU AND CLICK OK" | Select -ExpandProperty SKUs
Get-AzureRmVMImage -Location $location -PublisherName $publisher -Offer $offer -Skus $sku | Out-Gridview -OutputMode Single -Title "SELECT AN IMAGE and CLICK OK"