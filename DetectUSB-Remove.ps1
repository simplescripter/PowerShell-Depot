Get-WMIObject -Namespace root\Subscription -Class __EventFilter -Filter "Name='USBFilter'" | 
    Remove-WmiObject -Verbose
 
Get-WMIObject -Namespace root\Subscription -Class LogFileEventConsumer -Filter "Name='USBConsumer'" | 
    Remove-WmiObject -Verbose
 
Get-WMIObject -Namespace root\Subscription -Class __FilterToConsumerBinding -Filter "__Path LIKE '%USBFilter%'"  | 
    Remove-WmiObject -Verbose