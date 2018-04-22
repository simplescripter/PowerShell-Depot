<#
A fun goof.  Provide any file, preferrably a script or source code file, to the -source parameter.
When run, hacker_typist.ps1 will sequentially display random-length pieces of the 
source code file as you hit any keys on the keyboard, giving the appearance of a very fast
typist writing the code.

If you don't provide a $source file, this script itself will be used as the input text, skipping 
these first comment lines.

Increase the value for $maximumIncrement to make "typing" appear faster

Requires a PowerShell console because reading and writing keystrokes isn't supported by the ISE

#>
Param(
    $source,
    $maximumIncrement = 3
)
If ($PSBoundParameters.ContainsKey('source')){
    $source = Get-Content $source
}Else{
    $source = Get-Content $MyInvocation.InvocationName | Select -Skip 14
}

Clear-Host
Write-Host "PS C:\>" -NoNewline
$maximumIncrement ++

ForEach ($line in $source){
    $index = 0
    $lineLength = $line.length
    Do{
        If($host.UI.RawUI.ReadKey("NoEcho,IncludeKeyDown")){
            $increment = Get-Random -Minimum 1 -Maximum $maximumIncrement
            If(($index + $increment) -le $lineLength){
                Write-Host $line.Substring($index,$increment) -NoNewline
                $index = $index + $increment
            }Else{
                $remainder = $lineLength - $index
                Write-Host $line.Substring($index,$remainder) -NoNewline
                $index = $index + $increment
            }
        }
    }While($index -lt $line.length)
    Write-Host "`r"
}