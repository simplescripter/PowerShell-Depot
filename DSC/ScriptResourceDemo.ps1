Configuration ScriptDemoShowScript {
    Import-DscResource -ModuleName 'PSDesiredStateConfiguration'
    Node StudentServer2 {
        Script ScriptDemo {
            GetScript = {
                @{
                    GetScript = $GetScript
                    SetScript = $SetScript
                    TestScript = $TestScript
                    Result = "TestScript"
                }
            }
            SetScript = {
                Write-Verbose "Sleeping for 45 Seconds"
                Start-Sleep 45
                Write-Verbose "Script Task Completed"
            }
            TestScript = {
                $False
            }
        }
    }
}

ScriptDemoShowScript -OutputPath 'C:\DSC Resources\ScriptDemo'
Start-DscConfiguration -Path 'C:\DSC Resources\ScriptDemo' -Verbose -Wait 