Function Get-OctoCatWisdom {
    # ReST Demo

    # Many sites, including GitHub, now require TLS 1.2 or greater, so let's enable it:
    [Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12

    $url = 'https://api.github.com/octocat'
    Invoke-RestMethod $url
}