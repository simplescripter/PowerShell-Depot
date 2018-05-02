# An example of adding a custom property to an object in the PowerShell pipeline.
# Rather than using Select-Object to create the property on demand, updating the
# type data for the object itself allows you to create a "permanent" object property.
# The code could be added to your PowerShell profile

Update-TypeData -TypeName Microsoft.ActiveDirectory.Management.ADComputer -Membertype ScriptProperty -MemberName Computername -Value {$this.Name}