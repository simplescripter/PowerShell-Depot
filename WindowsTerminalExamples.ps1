# when we don't require variable replacement, using single quotes
start-process wt 'new-tab -p "Windows PowerShell" ; split-pane -p "PowerShell (Core)" ; split-pane -H wsl.exe'

# requiring variable replacement, using double quotes
$ThirdPane = "wsl.exe"
start-process wt "new-tab -p `"Windows PowerShell`"; split-pane -p `"PowerShell `(Core`)`"; split-pane -H $ThirdPane"

wt -p "Windows PowerShell" `; split-pane -p "PowerShell (Core)" `; split-pane -H wsl.exe

wt --% -p "Windows PowerShell" ; split-pane -p "PowerShell (Core)" ; split-pane -H "Ubuntu"


