If(! (Get-Module -ListAvailable Az.Security)){Install-Module Az.Security -Force}
$resourceGroup = 'JIT-Test-RG'
$location = (Get-AzResourceGroup $resourceGroup).Location
$subscriptionID = (Get-AzSubscription).Id
$vms = (Get-AzVm -ResourceGroupName $resourceGroup).Name


ForEach($vm in $vms){
    $JitPolicy = @{
        id="/subscriptions/$subscriptionId/resourceGroups/$resourceGroup/providers/Microsoft.Compute/virtualMachines/$vm"
        ports= @{
            number=3389
            protocol="*"
            allowedSourceAddressPrefix=@("*")
            maxRequestAccessDuration="PT3H"
        }
    }
    $JitPolicyArray = @($JitPolicy)
    Set-AzJitNetworkAccessPolicy -Kind 'Basic' -Location $location -Name $vm -ResourceGroupName $resourceGroup -VirtualMachine $JitPolicyArray
}