[DSCLocalConfigurationManager()]
configuration AdatumPartialConfig
{
    Node localhost
    {
        Settings
        {
            RefreshMode = 'Push'
            ConfigurationMode = 'ApplyandAutoCorrect'
        }
        PartialConfiguration AdatumEnvVars
        {
            Description = 'Custom Adatum Environment variable'
            RefreshMode = 'Push'
        }
        PartialConfiguration AdatumRegistry
        {
            Description = 'Custom Adatum Registry entry'
            RefreshMode = 'Push'
        }       
    }
} 

AdatumPartialConfig

Set-DscLocalConfigurationManager -Path '.\AdatumPartialConfig'

Get-DscLocalConfigurationManager