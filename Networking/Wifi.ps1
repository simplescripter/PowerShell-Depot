$networks_raw = netsh wlan show networks mode=bssid | Select -Skip 4
#$networks_raw = Get-Content C:\Users\Shawn.ELYSIUM\Desktop\wifi_short.txt | Select -Skip 4 #"netsh wlan show" uses header info for the first 4 lines
$networkLines = @()
$results = @()
ForEach($line in $networks_raw){
    If($line -ne ""){
        $networkLines += $line
    }Else{
        $network_segment = $networkLines
        $property_table = @{}
        $go_to_next_network = $false
        ForEach ($network_line in $network_segment){ # After BSSID processing, we shouldn't start back here....
            If($go_to_next_network){Continue} # ....so we just continue and until we've exited the ForEach loop 
            If($network_line -cnotlike "*BSSID*:*"){ # we'll implement a specialized routine to handle BSSIDs
                $split_line = $network_line -split ' :' # using a space and colon (" :") for the pattern so that MAC addresses aren't split into pieces
                If($split_line[0] -like "*SSID *"){
                    If($split_line[1] -match '^\s+$'){ # find SSIDS with empty strings so we can label them as <HIDDEN>
                        $SSID_name = "<HIDDEN>"
                        $property_table.Add("SSID",$SSID_name)
                    }Else{
                        $SSID_name = $split_line[1].Trim()
                        $property_table.Add("SSID",$SSID_name)
                    }
                }Else{
                     $property_table.Add($split_line[0].Trim(),$split_line[1].Trim())   
                }
            }Else{
                $BSSID_collection = @()
                $BSSIDs = $network_segment | Select-String -SimpleMatch "BSSID" -Context 0,5
                $BSSID_number = 0
                ForEach($BSSID in $BSSIDs){
                    $BSSID_number++
                    $BSSID = $BSSID -split "`n" # the context object produced by Select-String is a single string.  We need to split it up.
                    $BSSID_props = @{}
                    $BSSID_props.Add("SSID",$SSID_name)
                    ForEach($BSSID_line in $BSSID){
                        $split_line = $BSSID_line -split ' :'
                        If($split_line[0] -match '>\s+BSSID'){$split_line[0] = "BSSID"} 
                        $BSSID_props.Add($split_line[0].Trim(),$split_line[1].Trim())
                    }
                    $BSSID_obj = New-Object -TypeName PSObject -Property $BSSID_props
                    $BSSID_collection += $BSSID_obj
                }
                $property_table.Add("BSSIDs",$BSSID_Collection)
                $netObj = New-Object -TypeName PSObject -Property $property_table
                $results += Write-Output $netObj
                Write-Output $netObj #| Select SSID,'Network Type',Encryption,Authentication,BSSID* # It's preferrable not to do selection or formatting here.  Just a shortcut for now :)
                $network_segment = @()
                $property_table = @{}
                $go_to_next_network = $true # so we can exit the ForEach and continue to the next network
            }
        }
        $networkLines = @()
    }
}

# Examples:
#
# $results = .\wifi.ps1
# $results.bssids | Format-Table -groupby SSID
#
#$results
#TODO
# When formatting the output, only the BSSID 1 displays....
# Convert to Function
# Document with help
# Is there a way to get netsh to update the list of wireless networks on its own?  In Windows 10, at least, I have to 
#     click the Networks icon, which refreshes the list of nets, before netsh sees the networks
#
#
#
#

