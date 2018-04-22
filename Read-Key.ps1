Function Read-Key{
	$rawui = $Host.UI.RawUI
	$rk = $rawui.ReadKey()
	$rk
}