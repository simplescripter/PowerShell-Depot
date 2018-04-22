# FindShares.ps1; 3/14/07

# BEGIN CALLOUT A
# BEGIN COMMENT
# Define parameter to pass computer name when calling script file
# Use the local computer if no name is specified
# END COMMENT
param ($computer = ".")
# END CALLOUT A

# BEGIN CALLOUT B
# BEGIN COMMENT
# Create a WMI object to access the win32_share class
# Pass data down pipeline to filter to remove default shares
# Then pass data down pipeline to short the results by name
# END COMMENT
$shares = get-wmiobject -class "Win32_share" `
  -namespace "root\CIMV2" -computername $computer |
  where-object `
  {
    ($_.caption -ne "default share") `
    -and ($_.caption -notlike "remote*") `
    -and ($_.caption -notlike "logon*") `
  } |
  sort-object name
# END CALLOUT B

# BEGIN CALLOUT C
# BEGIN COMMENT
# Run if statement if user-defined shares exist
# END COMMENT
if ($shares -ne $null)
{  
  # BEGIN COMMENT
  # Add blank line before results
  # Then create foreach loop to iterate through shares
  # END COMMENT
  write-host 
  foreach ($share in $shares) 
  {
    # BEGIN COMMENT
    # For each share, provide name and path
    # END COMMENT
    write-host "Share name: " $share.name
    write-host "File path: " $share.path
    write-host 
  }
}
# END CALLOUT C

# BEGIN CALLOUT D
# BEGIN COMMENT
# Run else statement if user-defined shares do not exist
# END COMMENT
else
{
  if ($computer -eq ".")
  {
    # BEGIN COMMENT
    # Return message that names the local computer
    # END COMMENT
    write-host 
    write-host "The computer $env:computerName contains only the default shares."
    write-host 
  }

  else
  {
    # BEGIN COMMENT
    # Return message that names the specified computer
    # END COMMENT
    write-host 
    write-host "The computer $computer contains only the default shares."
    write-host 
  }
}
# END CALLOUT D
