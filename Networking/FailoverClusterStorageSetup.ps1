# For MOC course 20740, run this code on LON-DC1 to prepare the storage environment for failover clustering

# Setup LON-DC1 as an iSCSI Target server with 3 disks for LON-SVR2 and LON-SVR3:
Install-WindowsFeature FS-iSCSITarget-Server
New-IscsiServerTarget -TargetName "Cluster01" -InitiatorIDs @("IPAddress:172.16.0.22","IPAddress:172.16.0.23")
For ($i = 1; $i -le 3; $i++){
  New-IscsiVirtualDisk -Path "C:\iSCSIDisk$i.vhdx" -SizeBytes 5GB
  Add-IscsiVirtualDiskTargetMapping -TargetName "Cluster01" -path "C:\iSCSIDisk$i.vhdx"
}

# On LON-SVR2 and LON-SVR3:
#    + Install the Failover Clustering and File Server roles
#    + Enable the iSCSI initiator service
#    + Use the iSCSI initiator to connect to LON-DC1 and connect all available storage
Invoke-Command LON-SVR2,LON-SVR3 {
    Install-WindowsFeature Failover-Clustering,FS-FileServer -IncludeManagementTools
    Set-Service -Name msiscsi -StartupType Automatic
    Start-Service msiscsi
    New-IscsiTargetPortal -TargetPortalAddress 172.16.0.10
    Get-IscsiTarget | Connect-IscsiTarget
}

# In the lab environment, the 3 disks attached to LON-SVR2 will be numbered 4, 5, and 6. Initialize
# each disk and create a new volume, starting at F:
Invoke-Command LON-SVR2 {
    Initialize-Disk -Number @(4,5,6)
    4..6 | ForEach {
        Get-Disk $_ | New-Volume -FriendlyName "Disk$_" -AccessPath "$([char](66+$_)):"
    }
}

# Bring the shared disks online for LON-SVR3
Invoke-Command LON-SVR3 {
    3..5 | ForEach {
        Set-Disk -Number $_ -IsOffline $false
    }
}