$physicalAdapters = Get-WMIObject -Class Win32_NetworkAdapter -Filter "PhysicalAdapter=$true"
$adapterNames = @()
ForEach ($adapter in $physicalAdapters){
    $adapterNames += $adapter.Name
}

Get-WMIObject -Namespace root\WMI -Class MSNdis_PhysicalMediumType | 
    Where-Object {$_.InstanceName -in $adapterNames} | 
    Select InstanceName, @{
        Name='MediumType'
        Expression={
            Switch ($_.NdisPhysicalMediumType){
                0 {"Ethernet or Other"}
                9 {"Wifi"}
                10 {"Bluetooth"}
                default {"Unknown"}
            }
        }
    }