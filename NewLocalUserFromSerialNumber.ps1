# Requires an input CSV with SerialNumber and LocalUser info
$input = Import-CSV E:\serials.txt
$lookupTable = @{}
ForEach($row in $input){
    $lookupTable.Add($row.SerialNumber,$row.LocalUser)
}
$serial = Get-CIMInstance Win32_BIOS | Select-Object -ExpandProperty SerialNumber
$user = $lookTable.$serial
New-LocalUser $user -NoPassword | Add-LocalGroupMember -Name 'Administrators'