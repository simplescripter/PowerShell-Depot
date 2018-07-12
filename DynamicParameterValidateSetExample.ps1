# the dynamic function is borrowed from Martin Schvartzman at
# http://blogs.technet.com/b/pstips/archive/2014/06/10/dynamic-validateset-in-a-dynamic-parameter.aspx
Function Get-Uptime {
    [CmdletBinding()]
    Param(
        [switch]$friendlyDate
    )
    DynamicParam {
            # Set the dynamic parameters' name
            $ParameterName = 'ComputerName'
            
            # Create the dictionary 
            $RuntimeParameterDictionary = New-Object System.Management.Automation.RuntimeDefinedParameterDictionary

            # Create the collection of attributes
            $AttributeCollection = New-Object System.Collections.ObjectModel.Collection[System.Attribute]
            
            # Create and set the parameters' attributes
            $ParameterAttribute = New-Object System.Management.Automation.ParameterAttribute
            $ParameterAttribute.Mandatory = $true
            $ParameterAttribute.Position = 1
            # Add the attributes to the attributes collection
            $AttributeCollection.Add($ParameterAttribute)

            # Generate and set the ValidateSet 
            $arrSet = Get-ADComputer -Filter * | Select-Object -ExpandProperty Name
            $ValidateSetAttribute = New-Object System.Management.Automation.ValidateSetAttribute($arrSet)

            # Add the ValidateSet to the attributes collection
            $AttributeCollection.Add($ValidateSetAttribute)

            # Create and return the dynamic parameter
            $RuntimeParameter = New-Object System.Management.Automation.RuntimeDefinedParameter($ParameterName, [string[]], $AttributeCollection)
            $RuntimeParameterDictionary.Add($ParameterName, $RuntimeParameter)
            return $RuntimeParameterDictionary
    }
    Begin{
        # Bind the parameter to a friendly variable
        $ComputerName = $PsBoundParameters[$ParameterName]
    }
    Process{
        ForEach($computer in $computerName){
            If($friendlyDate){
                Get-WMIObject -Class Win32_OperatingSystem -ComputerName $computer | 
                    Select @{Label="Uptime";Expression={$_.ConvertToDateTime($_.LastBootupTime)}}
            }else{
                Get-WMIObject -Class Win32_OperatingSystem -ComputerName $computer | Select LastBootupTime
            }
        }
    }
}