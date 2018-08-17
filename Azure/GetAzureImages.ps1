Try{
    Get-AzureRmContext -ErrorAction Stop 
}Catch{
    Add-AzureRmAccount
}
$location = Get-AzureRmLocation | Out-GridView -PassThru -Title "SELECT A LOCATION AND CLICK OK" | Select -ExpandProperty Location
$publisher = Get-AzureRmVMImagePublisher -Location $location | Out-GridView -PassThru -Title "SELECT A PUBLISHER AND CLICK OK" | Select -ExpandProperty PublisherName
$offer = Get-AzureRmVMImageOffer -Location $location -PublisherName $publisher | Out-GridView -PassThru -Title "SELECT AN OFFER AND CLICK OK" | Select -ExpandProperty Offer 
$sku = Get-AzureRmVMImageSKU -Location $location -PublisherName $publisher -Offer $offer |
    Out-GridView -PassThru -Title "SELECT AN SKU AND CLICK OK" | Select -ExpandProperty SKUs
Get-AzureRmVMImage -Location $location -PublisherName $publisher -Offer $offer -Skus $sku | Out-Gridview -PassThru -Title "SELECT AN IMAGE and CLICK OK"