Function Get-FolderNTFSPermission{
	Param(
        $computerName = ".",
        [Parameter(Mandatory=$True)]$rootPath,
        [switch]$recurse = $false
    )
    $RecordErrorAction = $ErrorActionPreference
	$ErrorActionPreference = "SilentlyContinue"
    $folders = @()
    $rootPath = ($rootPath).Replace("\","\\")
    $directoryObject = Get-WMIObject Win32_Directory -filter "Name='$rootPath'" -ComputerName $computerName
    $folders += $directoryObject | Select-Object -ExpandProperty Name
    If($recurse){
        $folders += $directoryObject.getrelated() | Where {$_.filetype -eq "File Folder"} | select -expandproperty name
    }
	foreach($path in $folders){
		$Objs = @()
        #If($recurse){
        #    $FolderPath = ($path.FullName).Replace("\","\\")
            
        #}else{
            $FolderPath = ($path).Replace("\","\\")
		    
       # }
		$NTFSSecs = Get-WmiObject -Class Win32_LogicalFileSecuritySetting `
			-Filter "Path='$FolderPath'" -ComputerName $ComputerName
		$SecDescriptor = $NTFSSecs.GetSecurityDescriptor()
		foreach($DACL in $SecDescriptor.Descriptor.DACL){  
			$DACLDomain = $DACL.Trustee.Domain
			$DACLName = $DACL.Trustee.Name
			if($DACLDomain -ne $null){
	           	$UserName = "$DACLDomain\$DACLName"
			}
			else{
				$UserName = "$DACLName"
			}
			$Properties = @{
                'ComputerName' = $ComputerName
				'ConnectionStatus' = "Success"
				'FolderName' = $path
				'SecurityPrincipal' = $UserName
				'FileSystemRights' = [Security.AccessControl.FileSystemRights]`
				$($DACL.AccessMask -as [Security.AccessControl.FileSystemRights])
				'AccessControlType' = [Security.AccessControl.AceType]$DACL.AceType
				'AccessControlFlags' = [Security.AccessControl.AceFlags]$DACL.AceFlags
            }		
			$NTFSACL = New-Object -TypeName PSObject -Property $Properties
	        $Objs += $NTFSACL
	    }
		$Objs |Select-Object ComputerName,ConnectionStatus,FolderName,SecurityPrincipal,FileSystemRights, `
		AccessControlType,AccessControlFlags -Unique
	}
$ErrorActionPreference = $RecordErrorAction
}