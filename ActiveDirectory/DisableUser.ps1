# DisableUser.ps1; 3/14/07

# BEGIN CALLOUT A
# BEGIN COMMENT
# Define parameter to pass user account name when calling script file
# END COMMENT
param ($sam = $(throw "You must include the user account name."))
# END CALLOUT A

# BEGIN CALLOUT B
# BEGIN COMMENT
# Create a searcher object to find data in Active Directory
# END COMMENT
$ds = new-object directoryServices.directorySearcher

# BEGIN COMMENT
#Define a filter on the searcher object to retrieve the specified user account
# END COMMENT
$ds.filter = "(&(objectCategory=person)(objectClass=user)(samAccountName=$sam))"

# BEGIN COMMENT
# Retrieve user account and assign to variable
# END COMMENT
$dn = $ds.findOne()
# END CALLOUT B

# BEGIN CALLOUT C
# BEGIN COMMENT
# Retrieve user account description and assign to variable
# END COMMENT
$desc = $dn.properties.description

# BEGIN COMMENT
# Retrieve timestamp and assign to variable
# END COMMENT
$date = get-date
# END CALLOUT C

# BEGIN CALLOUT D
# BEGIN COMMENT
# Run if statement if user account found
# END COMMENT
if ($dn.path.length -gt 0)
{
  # BEGIN COMMENT
  # Create an ADSI object based on the user account path
  # END COMMENT
  $user = [ADSI]$dn.path    

  # BEGIN COMMENT
  # Disable the user account
  # END COMMENT
  $user.psBase.invokeSet("accountDisabled", $true)

  # BEGIN COMMENT
  # Append the user account description
  # END COMMENT
  $user.Put("description", "$desc (disabled $date)")

  # BEGIN COMMENT
  # Commit changes to the user account
  # END COMMENT
  $user.setInfo()

  # BEGIN COMMENT
  # Return message saying that the user account has been disabled
  # END COMMENT
  write-host "User account" $sam "disabled."

  # BEGIN COMMENT
  # Return the user account's distinguished name
  # END COMMENT
  write-host "Distinguished name:" $dn.properties.distinguishedname
}
# END CALLOUT D

# BEGIN CALLOUT E
# BEGIN COMMENT
# Run else statement if user account not found
# END COMMENT
else
  # BEGIN COMMENT
  # Return message saying that user account was not found
  # END COMMENT
 {write-host "User account" $sam "not found."}
# END CALLOUT E
