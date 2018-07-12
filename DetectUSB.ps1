$computerName = $env:COMPUTERNAME
$nameSpace = 'root\subscription'
$logPath = 'C:\USB\USB.log'
#Filter
$wmiArguments = @{
    Name = 'USBFilter'
    EventNameSpace = 'root\CIMV2'
    QueryLanguage = 'WQL'
    Query = "SELECT * FROM __InstanceModificationEvent WITHIN 5 WHERE TargetInstance ISA 'Win32_LogicalDisk AND TargetInstance.DriveType=2'"
}
$filter = Set-WMIInstance -Class __EventFilter -ComputerName $computerName -Namespace $nameSpace -Arguments $wmiArguments

##Consumer
$wmiArguments = @{
    Name = 'USBConsumer'
    FileName = $logPath
    # The Text parameter of LogFileEventConsumer accepts only literal strings and WMI TargetInstance properties;
    # PowerShell variables or other dynamic sources of information are not "dynamic" in the Text string
    # You could use the CommandLineEventConsumer with a script to write the information instead
    Text = "[USB] Device id %TargetInstance.DeviceID%"
}
$consumer = Set-WmiInstance -Class LogFileEventConsumer -ComputerName $computerName -Namespace $nameSpace -Arguments $wmiArguments

#Binding
$wmiArguments = @{
    Filter = $filter
    Consumer = $consumer
}
$binding = Set-WmiInstance -Class __FilterToConsumerBinding -ComputerName $computerName -Namespace $nameSpace -Arguments $wmiArguments
