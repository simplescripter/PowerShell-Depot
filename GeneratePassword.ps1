# Requires the Basic Authentication feature of IIS
 
 Function Generate-Password{
    Param(
        [int]$Length = 8,
        [int]$numberOfSymbols = 1
    )
    [System.Web.Security.Membership]::GeneratePassword($Length,$numberOfSymbols)
}
