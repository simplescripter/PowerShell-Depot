$systems = Get-Content C:\script\systems.txt
$skylakeList = Invoke-WebRequest 'http://ark.intel.com/products/codename/37572/Skylake#@All'
ForEach ($system in $systems){
    $processor = ((Get-WMIObject win32_Processor -ComputerName $system).name) `
        -replace '.*(\w{0,1}\d{4}\w{0,1}).*','$1'
    $properties = @{
        ComputerName = $system
        Skylake = $skylakeList -match $processor
    }
    New-Object -TypeName PSObject -Property $properties
}