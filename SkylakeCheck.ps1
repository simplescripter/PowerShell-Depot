$processor = ((Get-WMIObject win32_Processor).name) -replace '.*(\w{0,1}\d{4}\w{0,1}).*','$1'
$skylakeList = Invoke-WebRequest 'http://ark.intel.com/products/codename/37572/Skylake#@All'
$skylakeList -match $processor