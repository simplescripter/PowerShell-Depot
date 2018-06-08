Configuration AdatumRegistry
{
    Import-DscResource -ModuleName 'PSDesiredStateConfiguration'

    Registry AdatumReg1
    {
        Ensure = 'Present'
        Key = 'HKEY_LOCAL_MACHINE\SOFTWARE\AdatumRegKey1'
        ValueName = 'AdatumRegVal1'
        ValueData = '1'
    }
}

AdatumRegistry