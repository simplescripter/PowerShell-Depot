Function Get-AzureVmSizesByLocation {
<#
    .SYNOPSIS
        Given a VM family, displays the Azure regions where that VM may be hosted  

    .EXAMPLE
        Get-AzureVmSizesByLocation -vmSeries Esv3 | Sort Size | Format-Table Location -GroupBy Size
#>

    Param(
        [ValidateSet('Dv3','Dsv3','Ev3','Esv3')]
        [string]$vmSeries
    )

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
    If(-not ($vmSeries -eq $null)){
        Switch ($vmSeries){
            'Dv3' {$pattern = '\w+_D\d+_v3$'}
            'Dsv3' {$pattern = '\w+_D\d+s_v3$'}
            'Ev3' {$pattern = '\w+_E\d+_v3$'}
            'Esv3' {$pattern = '\w+_E\d+s_v3$'}
        }
    }
    $locations = Get-AzureRmLocation | Select -ExpandProperty location
    $locationCount = 0
    ForEach ($location in $locations){
        $locationCount++
        Write-Progress -Activity "Searching location:" -Status $location -PercentComplete ($locationCount/$locations.count * 100)
        $list = @()
        Try{
            If(-not ($vmSeries -eq $null)){
                $list += Get-AzureRmVmSize -Location $location -ErrorAction Stop | Where-Object {$_.Name -cmatch $pattern} | Select -ExpandProperty Name
            }Else{
                $list += Get-AzureRmVmSize -Location $location -ErrorAction Stop | Select -ExpandProperty Name
            }
        }Catch{
            
        }
        ForEach ($size in $list){
            $properties = @{
                Size = $size
                Location = $location
            }
            $obj = New-Object -TypeName psobject -Property $properties
            Write-Output $obj
        }
    }
}