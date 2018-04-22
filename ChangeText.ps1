Function Change-Text {
    Param(
        [string]$oldString,
        [string]$newString
    )
    ForEach ($file in $input){
        Write-Host -Fore green "Changing $file"
        $filestream = Get-Content $file
        Clear-Content $file
        ForEach($line in $filestream){
            $result = $result + ($line.Replace($oldString, $newString)) + "`n"
        }
        Set-Content $file $result
        $line = $NULL
        $result = $NULL
    }
}
