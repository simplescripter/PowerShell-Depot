Param(
    $firstFolder,
    $secondFolder
)

$files = Get-ChildItem $firstFolder
#$files2 = Get-ChildItem $secondFolder | Select -ExpandProperty FullName
ForEach($file in $files){
    $File1 = Get-FileHash $file.FullName -Algorithm SHA1 | Select -ExpandProperty Hash
    $File2 = Get-FileHash (Join-Path $secondFolder $file.Name) -Algorithm SHA1 | Select -ExpandProperty Hash
    If($File1 -eq $File2){
        $result = 'SAME'
    }Else{
        $result = 'CHANGED'
    }
    $props = [ordered]@{
        'Name' = $file.Name
        'File1' = $file1
        'File2' = $file2
        'Comparison' = $result
    }
    New-Object -TypeName psobject -Property $props
}

