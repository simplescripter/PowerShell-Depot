# This code example is from Jeffrey Hicks at http://mcpmag.com/articles/2010/10/05/switch-way-did-they-go.aspx

$x=Read-host "enter something"
Switch -regex ($x) {
\d+ {
 write-host "You entered one or more numbers: $($matches.item(0))"
 }
\w+ {
 write-host "You entered one or more alpha characters: $($matches.item(0))"
 }
\W+ {
 write-host "You entered one or more non-alphanumeric characters: $($matches.item(0))"
 }
Default {
 write-host "I don't know what you entered: $x"
 }
}