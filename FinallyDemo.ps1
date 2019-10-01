Try{
    Get-Service NONE -ErrorAction Stop
}
Catch{

}
"This code runs"

Try{
    Get-Service NONE -ErrorAction Stop
}
Catch{

}Finally{
    "This code runs"
}

Try{
    Get-Service NONE -ErrorAction Stop
}
Catch{
    Return # or Exit
}
"This code does NOT run"

Try{
    Get-Service NONE -ErrorAction Stop
}
Catch{
    Return #or Exit
}Finally{
    "This code runs"
}