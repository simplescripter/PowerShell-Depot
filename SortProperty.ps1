Function Sort-Property{
    [CmdletBinding()]
    Param(
        [Parameter(Mandatory=$true,ValueFromPipeline=$true)]
        $object
    )
    Process{
        $props = $object | Get-Member -MemberType *Property | Sort Name | Select -ExpandProperty Name
        $object | Format-List -Property $props
    }
}