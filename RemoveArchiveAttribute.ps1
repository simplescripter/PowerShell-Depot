$path = 'E:\Mod01\Democode'
$files = Get-ChildItem -Path $path -Recurse
$archiveAttribute = [System.IO.FileAttributes]::Archive

Foreach($file in $files){
    If((Get-ItemProperty -Path $file.FullName).Attributes -band $archiveAttribute){
        Write-Host "$($file.Name) archive bit set" -ForegroundColor Red
        $archiveRemoved = (Get-ItemProperty $file.fullname).attributes -bxor $archiveAttribute
        Set-ItemProperty -Path $file.FullName -Name Attributes -Value $archiveRemoved
    }
}