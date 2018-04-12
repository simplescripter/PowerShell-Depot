$myData = @{
    AllNodes = @(
        @{
            NodeName = "StudentServer"
            EvaluationSoftware = @{
                Name = "Test Software"
                Version = "1.2.3"
            }
            NewString = "NewString"
        }
    )
}

Configuration DataTest {
    Import-DscResource -ModuleName PSDesiredStateConfiguration
    Node $AllNodes.NodeName {
        File TestFile {
            Ensure = 'Present'
            DestinationPath = "C:\demo\$($Node.EvaluationSoftware.Name)"
            Contents = $Node.EvaluationSoftware.Version
        }
    }
}

DataTest -ConfigurationData $myData -Outputpath C:\Users\Administrator\DataTest