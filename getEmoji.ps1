Function Get-Emoji {
    Param(
        $unicode
    )
    $unicode32 = [System.Convert]::ToInt32($unicode,16)
    [char]::ConvertFromUtf32($unicode32)
}