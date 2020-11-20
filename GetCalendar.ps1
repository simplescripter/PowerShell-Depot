Function Get-Calendar {  
    [reflection.assembly]::loadwithpartialname("System.Windows.Forms") | Out-Null
    [reflection.assembly]::loadwithpartialname("System.Drawing") | Out-Null

    $form = New-Object Windows.Forms.Form  
    $form.Text = "Select the date ranges from the Calendar and press Enter"  
    $form.Size = New-Object Drawing.Size @(656,639)  

    # Create a "hidden" SelectButton to handle Enter Key 

    $btnSelect = New-Object System.Windows.Forms.Button 
    $btnSelect.Size = "1,1" 
    $btnSelect.add_Click({  
    $form.Close()  
    })  
    $form.Controls.Add($btnSelect )  
    $form.AcceptButton =  $btnSelect 

    # Add Calendar  

    $calendar = New-Object System.Windows.Forms.MonthCalendar  
    $calendar.ShowWeekNumbers = $false  
    $calendar.MaxSelectionCount = 356 
    $calendar.Dock = 'Fill'  
    $form.Controls.Add($calendar)  

    # Display the form 

    $form.Add_Shown({$form.Activate()})   
    [void]$form.Showdialog()  

    # Return Start and End date  

    Return $calendar.SelectionRange

}  