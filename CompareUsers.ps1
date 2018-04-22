#Updated 2-15-2018
#Note: When the first user in the comparison contains a very long attribute value (for example, the MemberOf property), the second 
#user may be pushed beyond the console's right boundary.  If you extend the console enough before running the command, the 
#second user column will be displayed.  Alternatively, you can export the pipeline to CSV, XML, or another format (but not
#Out-File

Function Compare-User {
    Param(
        [Parameter(Mandatory=$true)][string]$firstuser,
        [Parameter(Mandatory=$true)][string]$seconduser,
        [string]$firstDC,
        [int]$firstDCPort = 389,
        [string]$secondDC,
        [int]$secondDCPort = 389,
        [switch]$showMetaData = $false
    )
    $metaDataProps = @(
        'Created',
        'createTimeStamp',
        'Modified',
        'modifyTimeStamp',
        'ObjectGUID',
        'objectSid',
        'pwdLastSet',
        'sDRightsEffective',
        'uSNChanged',
        'uSNCreated',
        'whenChanged',
        'whenCreated'
    )
    If(! $firstDC){
        $firstDC = Get-ADDomainController | Select-Object -ExpandProperty Hostname
    }
    If(! $secondDC){
        $secondDC = Get-ADDomainController | Select-Object -ExpandProperty Hostname
    }
    $snapshot = Get-ADUser $firstUser -Properties * -Server "$firstDC`:$firstDCPort" 
    $now = Get-ADUser $secondUser -Properties * -Server "$secondDC`:$secondDCPort"
    $masterPropList = @()
    $masterPropList = $snapshot | Get-Member -MemberType Property | Select -ExpandProperty Name # Get the prop list from the first user
    $masterPropList += $now | Get-Member -MemberType Property | Select -ExpandProperty Name # ...and the second user
    $masterPropList = $masterPropList | Select-Object -Unique # Combine the properties, selecting only those that are unique
    If(-not $showMetaData){
        $shortPropList = @()
        ForEach($name in $masterPropList){
            If($metaDataProps -notcontains $name){
                $shortPropList += $name
            }
        }
        $masterPropList = $shortPropList
    }
    ForEach($property in $masterPropList){
        If($compare = Compare-Object $snapshot $now -Property $property){
            $hash = @{
                Property = $property;
                "$FirstUser" = $compare[1].$property;
                "$SecondUser" = $compare[0].$property
            }
            $PSObject = New-Object -TypeName PSObject -Property $hash
            Write-Output $PSObject | Select Property, "$FirstUser", "$SecondUser"
        }
    }
}