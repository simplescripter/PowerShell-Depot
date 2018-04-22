$filter = @"
<QueryList>
  <Query Id="0" Path='file://C:\Path\savedlog.evtx">
    <Select>
    *[System[(EventID=4634)]] and
    *[EventData[Data[@Name='TargetUserName'] and (Data="Shawn")]]
    </Select>
  </Query>
</QueryList>
"@
 
Get-WinEvent -FilterXml $filter