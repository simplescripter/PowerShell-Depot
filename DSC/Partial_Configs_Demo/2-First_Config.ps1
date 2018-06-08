Configuration AdatumEnvVars
{
    Import-DscResource -ModuleName 'PSDesiredStateConfiguration'

    Environment AdatumEnvVar1
    {
        Ensure = 'Present'
        Name = 'AdatumEnvVar1'
        Value = '1'
    }
}

AdatumEnvVars
