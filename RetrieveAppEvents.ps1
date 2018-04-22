# RetrieveAppEvents.ps1; 3/14/07

# BEGIN CALLOUT A
# BEGIN COMMENT
# Calculate datetime for one day earlier than current datetime
# END COMMENT
$date = (get-date).addDays(-1)
# END CALLOUT A

# BEGIN CALLOUT B
# BEGIN COMMENT
# Create a function to format the entry types
# END COMMENT
function FormatEntryType ($file)
{
  # BEGIN COMMENT
  # Retrieve content from AppEvents.txt file
  # Replace the error and warning entry types
  # Output changes to new file
  # END COMMENT
  get-content $file |
  foreach-object { $_ -replace "error", "*** ERROR ***" } |
  foreach-object { $_ -replace "warning", "* Warning *" } |
  out-file -filePath c:\scripts\AppEvents_EntryTypes.txt
}
# END CALLOUT B

# BEGIN CALLOUT C
# BEGIN COMMENT
# Retrieve application events for the last day
# END COMMENT
$events = get-eventlog application | where-object {$_.timeGenerated -gt $date}
# END CALLOUT C

# BEGIN CALLOUT D
# BEGIN COMMENT
# Output the application events to the AppEvents.txt file
# Record only the time of the event, the entry type, the source, and the message
# END COMMENT
$events | foreach-object { out-file -filePath c:\scripts\AppEvents.txt -append `
-inputObject $_.timeGenerated, $_.entryType, $_.source, $_.message }
# END CALLOUT D

# BEGIN CALLOUT E
# BEGIN COMMENT
# Run the FormatEntryType function on the AppEvents.txt file
# END COMMENT
FormatEntryType c:\scripts\AppEvents.txt
# END CALLOUT E
