Function Get-AzureVmSizeByLocation {
<#
    .SYNOPSIS
        Given a VM size, displays the Azure regions where that VM may be hosted in the current subscription  

    .EXAMPLE
        Get-AzureVmSizeByLocation -vmSize Standard_D1_v2

    .EXAMPLE
        Get-AzureVmSizeByLocation -vmSize Standard_DS1_v2 | Sort Size | Format-Table LocationAvailable -GroupBy Size

    .EXAMPLE
        Get-AzureVmSizeByLocation -vmSize Standard_D2_v2 -location westus2

    .EXAMPLE
        Get-AzureVmSizeByLocation | Sort locationAvailable | Format-Table Size -GroupBy locationAvailable
#>

    Param(
        [ValidateSet(            # common sizes used in MOC AZ-103T00
            'Standard_DS1_v2',
            'Standard_DS2_v2',
            'Standard_D1_v2',
            'Standard_D2_v2',
            'Standard_D2s_v3'
        )]
        [string]$vmSize,

        [string]$location        # optional
    )

    # Look for Az module and, if present, load the equivalent -AzureRm aliases:
    If(Get-Module -ListAvailable Az.*){
        Enable-AzureRmAlias
    }

    # Check for Azure login:
    Try{
        Get-AzureRmContext -ErrorAction Stop | Out-Null
    }Catch{
        Add-AzureRmAccount
    }
    
    $locations = Get-AzureRmLocation | Select-Object -ExpandProperty location
    If($PSBoundParameters.ContainsKey('location')){
        If($locations -contains $location){
            $locations = $location
        }Else{
            throw "INVALID LOCATION"
        }
    }
    $locationCount = 0
    $allVmSKUs = Get-AzComputeResourceSku | Where-Object {$_.ResourceType -like 'virtualMachines' -and $_.Restrictions.ReasonCode -ne 'NotAvailableForSubscription'}
    ForEach ($location in $locations){
        $locationCount++
        Write-Progress -Activity "Searching location.." -Status $location -PercentComplete ($locationCount/$locations.count * 100)
        $list = @()
        Try{
            If(-not ($vmSize -eq $null)){
                $list += $allVmSKUs | 
                    Where-Object {$_.Locations -contains $location -and $_.Name -match $vmSize} | Select-Object -ExpandProperty Name
            }Else{
                $list += $allVmSKUs | 
                    Where-Object {$_.Locations -contains $location} | Select-Object -ExpandProperty Name
            }
        }Catch{
            
        }
        $objList = @()
        ForEach ($size in $list){
            $properties = @{
                Size = $size
                LocationAvailable = $location
            }
            $objList += New-Object -TypeName psobject -Property $properties
        }
        Write-Output $objList
    }
}
