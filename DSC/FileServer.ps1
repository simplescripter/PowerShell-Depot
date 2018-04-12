Configuration FileServer {
    Import-DscResource -ModuleName 'PSDesiredStateConfiguration'
    Node 'ServerA' {
        WindowsFeature FS {
            Name = 'FS-FileServer'
            Ensure = 'Present'
        }

        WindowsFeature Dedup {
            Name = 'FS-Data-Deduplication'
            Ensure = 'Present'
        }
    }
}