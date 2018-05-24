Param([string[]]$computers)

Function A{
    Param([string[]]$computers)
    foreach($computer in $computers){
        Try{
            gwmi Win32_BIOS -ComputerName $computer -ErrorAction Stop -ErrorVariable FunctionA_Error | FT SerialNumber,__SERVER
        }Catch{
            Write-Warning "Error on $computer in FunctionA"
            Write-Host "********************************************************************************"
            Write-Warning $_.Exception.GetType().FullName
            Write-Warning $_.Exception.Message
            Write-Host "********************************************************************************"
            Write-Warning "FunctionA_Error variable contains $FunctionA_Error"
            Write-Host "********************************************************************************"
            Write-Warning "Error variable contains $($error[0])"
        }
    }
}

Function B{
    Param([string[]]$computers)
    foreach($computer in $computers){
        Try{
            gwmi Win32_ComputerSystem -ComputerName $computer -ErrorAction Stop | FT Manufacturer,__SERVER
        }Catch{
            Write-Warning "Error on $computer in FunctionB"
            Write-Warning $_.Exception
            Write-Warning $_.Exception.Message
        }
    }
}

A -computers Slasher,Dasher,Slasher
#B -computers Slasher,Dasher,Slasher