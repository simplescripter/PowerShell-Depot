# EnumColors.ps1
[Enum]::GetValues([System.ConsoleColor]) | select-object `
  @{"Name" = "Name"; "Expression" = {$_}},
  @{"Name" = "Dec"; "Expression" = {[Int] $_}},
  @{"Name" = "Hex"; "Expression" = {"0x{0:X1}" -f [Int] $_}} |
  format-table -auto
