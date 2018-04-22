$filter = @"
<QueryList>
  <Query Id="0">
    <Select Path="Security">
    *[System[(EventID=4634)]] and
    *[EventData[Data[@Name='TargetUserName'] and (Data="Shawn")]]
    </Select>
  </Query>
</QueryList>
"@
 
Get-WinEvent -FilterXml $filter
