Function Get-AdAttributes {
    Param(
        [Parameter(Mandatory=$true)]
        [string]$AdClass
    )
 
    $Schema = [DirectoryServices.ActiveDirectory.ActiveDirectorySchema]::GetCurrentSchema()
    $Schema.FindClass("$AdClass").MandatoryProperties | Select Name, Syntax, IsSingleValued, CommonName
    $Schema.FindClass("$AdClass").OptionalProperties | Select Name, Syntax, IsSingleValued, CommonName
}