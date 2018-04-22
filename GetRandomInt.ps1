# From student Tim Evans

Function Get-RandomInt {
    [cmdletbinding()]
    Param(
        [uint32]$max=[UInt32]::MaxValue,
        [uint32]$min=[UInt32]::MinValue
    )
    if ($min -lt $max) {
        #initialize everything
        $diff=$max-$min
        [Byte[]] $bytes = 1..4  #4 byte array for int32/uint32
        $rng = New-Object System.Security.Cryptography.RNGCryptoServiceProvider
        #generate the number
        $rng.getbytes($bytes)
        $number = [System.BitConverter]::ToUInt32(($bytes),0)
        $number = $number % $diff + $min
        return $number   
    } else {
        Write-Warning 'Min must be less than Max'
        return -1
    }
}