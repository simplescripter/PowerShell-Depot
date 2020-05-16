$net = "162.168.205."
131..157 | %{
    Do{
        If($name = Resolve-DnsName "$net$_" -Type PTR -ErrorAction SilentlyContinue){
            break
        }
        Sleep 10
    }Until($name)
    "$net$_" + " . . . . " + $name.NameHost
}