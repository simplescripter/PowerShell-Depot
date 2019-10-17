$certParams = @{
    Type = 'Custom'
    KeySpec = 'Signature'
    KeyExportPolicy = 'Exportable'
    HashAlgorithm = 'sha256'
    KeyLength = 2048
    CertStoreLocation = "Cert:\CurrentUser\My"
}
$cert = New-SelfSignedCertificate @certParams -Subject 'CN=P2SRootCert' -KeyUsage 'CertSign' -KeyUsageProperty 'Sign'

New-SelfSignedCertificate @certParams -DnsName 'P2SChildCert' -Subject 'CN=P2SChildCert' `
    -Signer $cert -TextExtension @("2.5.29.37={text}1.3.6.1.5.5.7.3.2")
