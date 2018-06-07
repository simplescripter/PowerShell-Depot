Configuration UserResource {
    Param (
        $password
    )
    Import-DscResource -ModuleName 'PSDesiredStateConfiguration'
    Node StudentServer2 {
        User UserResourceExample {
            Ensure = 'Present'
            UserName = 'Bob'
            Password = $password
            #DependsOn = "[Group]GroupExample"
        }
    }
}

$configData = @{
    AllNodes = @(
        @{
            NodeName = 'StudentServer2' # cannot be an asterisk unless 1 or more additional NodeName hash tables for specific nodes are added
            PSDscAllowPlainTextPassword = $true
        }
    )
}

UserResource -OutputPath 'C:\DSC Resources\MOF\User\' -ConfigurationData $configData -password `
    (Get-Credential -UserName "Bob" -Message "Enter the password for the new user")
Start-DscConfiguration -Path 'C:\DSC Resources\MOF\User\' -Wait -Verbose -Force
