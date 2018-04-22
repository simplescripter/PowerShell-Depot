# Set-Color.ps1
# Written by Bill Stewart (bill.stewart@frenchmortuary.com)

param([String] $Color = $(throw "Please specify a color."))

# Trap the error and exit the script if the user
# specified an invalid parameter.
trap [System.Management.Automation.RuntimeException] {
  write-error -errorrecord $ERROR[0]
  exit
}

# Assume -color specifies a hex value and it cast to a [Byte].
$newcolor = [Byte] ("0x{0}" -f $Color)

# Split the color into background and foreground colors.
# [Math]::Truncate returns a [Double], so cast it to an [Int].
$bg = [Int] [Math]::Truncate($newcolor / 0x10)
$fg = $newcolor -band 0xF

# If the background and foreground match, throw an error;
# otherwise, set the colors.
if ($bg -eq $fg) {
  write-error "The background and foreground colors must not match."
} else {
  $HOST.UI.RawUI.BackgroundColor = $bg
  $HOST.UI.RawUI.ForegroundColor = $fg
}
