#Get-DscResource -Name Package -Syntax
# Download the 7-Zip .MSI package
# Use InstEd to extract the Name and ProductID from the MSI.  Use Tables -> Properties in the InstEd software
# Run as admin

Configuration PackageResource {

    Import-DscResource -ModuleName 'PSDesiredStateConfiguration'
    Node StudentServer {
        Package 7Zip {   
            Name = '7-Zip 17.00 (x64 edition)'
            Path = 'C:\Users\Student\Downloads\7z1700-x64.msi'
            ProductID = '23170F69-40C1-2702-1700-000001000000'
            Ensure = "Present"
        }
    }
}

PackageResource -OutputPath C:\PackageTest

Start-DscConfiguration -Path C:\PackageTest -Verbose -Wait