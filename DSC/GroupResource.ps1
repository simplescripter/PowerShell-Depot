Configuration GroupResource {
    Import-DscResource -ModuleName 'PSDesiredStateConfiguration'
    Node $AllNodes.NodeName {
        Group GroupExample {
          GroupName = "ExampleGroup"
          Members = "Nicole", "Rocky", "Mark", "BlueBuffalo\Administrator"
          Credential = (Get-Credential)

        }
    }
}

$ConfigurationData = @{
    AllNodes = @(
        @{
            NodeName = "*"
            PSDscAllowPlainTextPassword = $true
        }
        @{
            NodeName = "StudentServer2"
        }
    )
}
Clear-Host
GroupResource -OutputPath 'C:\DSC Resources\MOF\Group' -Verbose -ConfigurationData $ConfigurationData

Start-DscConfiguration -Path 'C:\DSC Resources\MOF\Group\' -Wait -Verbose -Force