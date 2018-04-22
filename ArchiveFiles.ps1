Function Archive-File{
    [CmdletBinding()]
    Param(
        [string]$searchPath = "E:\",
        [Parameter(Mandatory=$true)][string[]]$extensions
    )
    Get-Childitem -recurse -path $searchPath -Include $extensions |
        ForEach-Object {
            Move-Item $PSItem.FullName -Destination "C:\Archive\$($PSItem.BaseName)-$(Get-Random -Minimum 1000000 -Maximum 100000000)$($PSItem.Extension)"
        }
}