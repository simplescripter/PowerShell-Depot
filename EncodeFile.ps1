Function Encode-File {
    [CmdletBinding()]
    Param(
        [Parameter(ValueFromPipeline=$true,Mandatory=$true)]
        [string[]]$file,

        [string]$saveAsHTML
    )
    Begin{
    $html = @"
            <html>
            <td><img border=0 alt="image"
            src="data:image/jpeg;base64,
"@
    }
    Process{
        $Base64 = [convert]::ToBase64String((Get-Content $file -Encoding Byte))
        If ($PSBoundParameters.ContainsKey('saveAsHTML')){
            Out-File -InputObject $html,$Base64,"`"></td></html>" -FilePath $saveAsHTML
        }Else{
            Write-Output $Base64
        }
    }
}