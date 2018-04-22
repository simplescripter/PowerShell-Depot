# From Daniel Schroeder at http://blog.danskingdom.com/powershell-ise-multiline-comment-and-uncomment-done-right-and-other-ise-gui-must-haves/

# Define our constant variables.
[string]$NEW_LINE_STRING = "`r`n"
[string]$COMMENT_STRING = "#"

function Select-EntireLinesInIseSelectedTextAndReturnFirstAndLastSelectedLineNumbers([bool]$DoNothingWhenNotCertainOfWhichLinesToSelect = $false)
{
<#
    .SYNOPSIS
    Exands the selected text to make sure the entire lines are selected.
    Returns $null if we can't determine with certainty which lines to select and the 

    .DESCRIPTION
    Exands the selected text to make sure the entire lines are selected.

    .PARAMETER DoNothingWhenNotCertainOfWhichLinesToSelect
    Under the following edge case we can't determine for sure which lines in the file are selected.
    If this switch is not provided and the edge case is encountered, we will guess and attempt to select the entire selected lines, but we may guess wrong and select the lines above/below the selected lines.
    If this switch is provided and the edge case is encountered, no lines will be selected.

    Edge Case:
    - When the selected text occurs multiple times in the document, directly above or below the selected text.

    Example:
    abc
    abc
    abc

    - If only the first two lines are selected, when you run this command it may comment out the 1st and 2nd lines correctly, or it may comment out the 2nd and 3rd lines, depending on
    if the caret is on the 1st line or 2nd line when selecting the text (i.e. the text is selected bottom-to-top vs. top-to-bottom).
    - Since the lines are typically identical for this edge case to occur, you likely won't really care which 2 of the 3 lines get selected, so it shouldn't be a big deal.
    But if it bugs you, you can provide this switch.

    .OUTPUT
    PSObject. Returns a PSObject with the properties FirstLineNumber and LastLineNumber, which correspond to the first and last line numbers of the selected text.
#>

    # Backup all of the original info before we modify it.
    [int]$originalCaretLine = $psISE.CurrentFile.Editor.CaretLine
    [string]$originalSelectedText = $psISE.CurrentFile.Editor.SelectedText
    [string]$originalCaretLineText = $psISE.CurrentFile.Editor.CaretLineText

    # Assume only one line is selected.
    [int]$textToSelectFirstLine = $originalCaretLine
    [int]$textToSelectLastLine = $originalCaretLine

    #------------------------
    # Before we process the selected text, we need to make sure all selected lines are fully selected (i.e. the entire line is selected).
    #------------------------

    # If no text is selected, OR only part of one line is selected (and it doesn't include the start of the line), select the entire line that the caret is currently on.
    if (($psISE.CurrentFile.Editor.SelectedText.Length -le 0) -or !$psISE.CurrentFile.Editor.SelectedText.Contains($NEW_LINE_STRING))
    {
        $psISE.CurrentFile.Editor.SelectCaretLine()
    }
    # Else the first part of one line (or the entire line), or multiple lines are selected.
    else
    {
        # Get the number of lines in the originally selected text.
        [string[]] $originalSelectedTextArray = $originalSelectedText.Split([string[]]$NEW_LINE_STRING, [StringSplitOptions]::None)
        [int]$numberOfLinesInSelectedText = $originalSelectedTextArray.Length

        # If only one line is selected, make sure it is fully selected.
        if ($numberOfLinesInSelectedText -le 1)
        {
            $psISE.CurrentFile.Editor.SelectCaretLine()
        }
        # Else there are multiple lines selected, so make sure the first character of the top line is selected (so that we put the comment character at the start of the top line, not in the middle).
        # The first character of the bottom line will always be selected when multiple lines are selected, so we don't have to worry about making sure it is selected; only the top line.
        else
        {
            # Determine if the caret is on the first or last line of the selected text.
            [bool]$isCaretOnFirstLineOfSelectedText = $false
            [string]$firstLineOfOriginalSelectedText = $originalSelectedTextArray[0]
            [string]$lastLineOfOriginalSelectedText = $originalSelectedTextArray[$originalSelectedTextArray.Length - 1]

            # If the caret is definitely on the first line.
            if ($originalCaretLineText.EndsWith($firstLineOfOriginalSelectedText) -and !$originalCaretLineText.StartsWith($lastLineOfOriginalSelectedText))
            {
                $isCaretOnFirstLineOfSelectedText = $true
            }
            # Else if the caret is definitely on the last line.
            elseif ($originalCaretLineText.StartsWith($lastLineOfOriginalSelectedText) -and !$originalCaretLineText.EndsWith($firstLineOfOriginalSelectedText))
            {
                $isCaretOnFirstLineOfSelectedText = $false
            }
            # Else we need to do further analysis to determine if the caret is on the first or last line of the selected text.
            else
            {
                [int]$numberOfLinesInFile = $psISE.CurrentFile.Editor.LineCount

                [string]$caretOnFirstLineText = [string]::Empty
                [int]$caretOnFirstLineArrayStartIndex = ($originalCaretLine - 1) # -1 because array starts at 0 and file lines start at 1.
                [int]$caretOnFirstLineArrayStopIndex = $caretOnFirstLineArrayStartIndex + ($numberOfLinesInSelectedText - 1) # -1 because the starting line is inclusive (i.e. if we want 1 line the start and stop lines should be the same).

                [string]$caretOnLastLineText = [string]::Empty
                [int]$caretOnLastLineArrayStopIndex = ($originalCaretLine - 1)  # -1 because array starts at 0 and file lines start at 1.
                [int]$caretOnLastLineArrayStartIndex = $caretOnLastLineArrayStopIndex - ($numberOfLinesInSelectedText - 1) # -1 because the stopping line is inclusive (i.e. if we want 1 line the start and stop lines should be the same).

                # If the caret being on the first line would cause us to go "off the file", then we know the caret is on the last line.
                if (($caretOnFirstLineArrayStartIndex -lt 0) -or ($caretOnFirstLineArrayStopIndex -ge $numberOfLinesInFile))
                {
                    $isCaretOnFirstLineOfSelectedText = $false
                }
                # If the caret being on the last line would cause us to go "off the file", then we know the caret is on the first line.
                elseif (($caretOnLastLineArrayStartIndex -lt 0) -or ($caretOnLastLineArrayStopIndex -ge $numberOfLinesInFile))
                {
                    $isCaretOnFirstLineOfSelectedText = $true
                }
                # Else we still don't know where the caret is.
                else
                {
                    [string[]]$filesTextArray = $psISE.CurrentFile.Editor.Text.Split([string[]]$NEW_LINE_STRING, [StringSplitOptions]::None)

                    # Get the text of the lines where the caret is on the first line of the selected text.
                    [string[]]$caretOnFirstLineTextArray = @([string]::Empty) * $numberOfLinesInSelectedText # Declare an array with the number of elements required.
                    [System.Array]::Copy($filesTextArray, $caretOnFirstLineArrayStartIndex, $caretOnFirstLineTextArray, 0, $numberOfLinesInSelectedText)
                    $caretOnFirstLineText = $caretOnFirstLineTextArray -join $NEW_LINE_STRING

                    # Get the text of the lines where the caret is on the last line of the selected text.
                    [string[]]$caretOnLastLineTextArray = @([string]::Empty) * $numberOfLinesInSelectedText # Declare an array with the number of elements required.
                    [System.Array]::Copy($filesTextArray, $caretOnLastLineArrayStartIndex, $caretOnLastLineTextArray, 0, $numberOfLinesInSelectedText)
                    $caretOnLastLineText = $caretOnLastLineTextArray -join $NEW_LINE_STRING

                    [bool]$caretOnFirstLineTextContainsOriginalSelectedText = $caretOnFirstLineText.Contains($originalSelectedText)
                    [bool]$caretOnLastLineTextContainsOriginalSelectedText = $caretOnLastLineText.Contains($originalSelectedText)

                    # If the selected text is only within the text of when the caret is on the first line, then we know for sure the caret is on the first line.
                    if ($caretOnFirstLineTextContainsOriginalSelectedText -and !$caretOnLastLineTextContainsOriginalSelectedText)
                    {
                        $isCaretOnFirstLineOfSelectedText = $true
                    }
                    # Else if the selected text is only within the text of when the caret is on the last line, then we know for sure the caret is on the last line.
                    elseif ($caretOnLastLineTextContainsOriginalSelectedText -and !$caretOnFirstLineTextContainsOriginalSelectedText)
                    {
                        $isCaretOnFirstLineOfSelectedText = $false
                    }
                    # Else if the selected text is in both sets of text, then we don't know for sure if the caret is on the first or last line.
                    elseif ($caretOnFirstLineTextContainsOriginalSelectedText -and $caretOnLastLineTextContainsOriginalSelectedText)
                    {
                        # If we shouldn't do anything since we might comment out text that is not selected by the user, just exit this function and return null.
                        if ($DoNothingWhenNotCertainOfWhichLinesToSelect)
                        {
                            return $null
                        }
                    }
                    # Else something went wrong and there is a flaw in this logic, since the selected text should be in one of our two strings, so let's just guess!
                    else
                    {
                        Write-Error "WHAT HAPPENED?!?! This line should never be reached. There is a flaw in our logic!"
                        return $null
                    }
                }
            }

            # Assume the caret is on the first line of the selected text, so we want to select text from the caret's line downward.
            $textToSelectFirstLine = $originalCaretLine
            $textToSelectLastLine = $originalCaretLine + ($numberOfLinesInSelectedText - 1) # -1 because the starting line is inclusive (i.e. if we want 1 line the start and stop lines should be the same).

            # If the caret is actually on the last line of the selected text, we want to select text from the caret's line upward.
            if (!$isCaretOnFirstLineOfSelectedText)
            {
                $textToSelectFirstLine = $originalCaretLine - ($numberOfLinesInSelectedText - 1) # -1 because the stopping line is inclusive (i.e. if we want 1 line the start and stop lines should be the same).
                $textToSelectLastLine = $originalCaretLine
            }

            # Re-select the text, making sure the entire first and last lines are selected. +1 on EndLineWidth because column starts at 1, not 0.
            $psISE.CurrentFile.Editor.Select($textToSelectFirstLine, 1, $textToSelectLastLine, $psISE.CurrentFile.Editor.GetLineLength($textToSelectLastLine) + 1)
        }
    }

    # Return the first and last line numbers selected.
    $selectedTextFirstAndLastLineNumbers = New-Object PSObject -Property @{
        FirstLineNumber = $textToSelectFirstLine
        LastLineNumber = $textToSelectLastLine
    }
    return $selectedTextFirstAndLastLineNumbers
}

function CommentOrUncommentIseSelectedLines([bool]$CommentLines = $false, [bool]$DoNothingWhenNotCertainOfWhichLinesToSelect = $false)
{
    $selectedTextFirstAndLastLineNumbers = Select-EntireLinesInIseSelectedTextAndReturnFirstAndLastSelectedLineNumbers $DoNothingWhenNotCertainOfWhichLinesToSelect

    # If we couldn't determine which lines to select, just exit without changing anything.
    if ($selectedTextFirstAndLastLineNumbers -eq $null) { return }

    # Get the text lines selected.
    [int]$selectedTextFirstLineNumber = $selectedTextFirstAndLastLineNumbers.FirstLineNumber
    [int]$selectedTextLastLineNumber = $selectedTextFirstAndLastLineNumbers.LastLineNumber

    # Get the Selected Text and convert it into an array of strings so we can easily process each line.
    [string]$selectedText = $psISE.CurrentFile.Editor.SelectedText
    [string[]] $selectedTextArray = $selectedText.Split([string[]]$NEW_LINE_STRING, [StringSplitOptions]::None)

    # Process each line of the Selected Text, and save the modified lines into a text array.
    [string[]]$newSelectedTextArray = @()
    $selectedTextArray | foreach {
        # If the line is not blank, add a comment character to the start of it.
        [string]$lineText = $_
        if ([string]::IsNullOrWhiteSpace($lineText)) { $newSelectedTextArray += $lineText }
        else 
        {
            # If we should be commenting the lines out, add a comment character to the start of the line.
            if ($CommentLines) 
            { $newSelectedTextArray += "$COMMENT_STRING$lineText" }
            # Else we should be uncommenting, so remove a comment character from the start of the line if it exists.
            else 
            {
                # If the line begins with a comment, remove one (and only one) comment character.
                if ($lineText.StartsWith($COMMENT_STRING))
                {
                    $lineText = $lineText.Substring($COMMENT_STRING.Length)
                } 
                $newSelectedTextArray += $lineText
            }
        }
    }

    # Join the text array back together to get the new Selected Text string.
    [string]$newSelectedText = $newSelectedTextArray -join $NEW_LINE_STRING

    # Overwrite the currently Selected Text with the new Selected Text.
    $psISE.CurrentFile.Editor.InsertText($newSelectedText)

    # Fully select all of the lines that were modified. +1 on End Line's Width because column starts at 1, not 0.
    $psISE.CurrentFile.Editor.Select($selectedTextFirstLineNumber, 1, $selectedTextLastLineNumber, $psISE.CurrentFile.Editor.GetLineLength($selectedTextLastLineNumber) + 1)
}

function Comment-IseSelectedLines([switch]$DoNothingWhenNotCertainOfWhichLinesToComment)
{
<#
    .SYNOPSIS
    Places a comment character at the start of each line of the selected text in the current PS ISE file.
    If no text is selected, it will comment out the line that the caret is on.

    .DESCRIPTION
    Places a comment character at the start of each line of the selected text in the current PS ISE file.
    If no text is selected, it will comment out the line that the caret is on.

    .PARAMETER DoNothingWhenNotCertainOfWhichLinesToComment
    Under the following edge case we can't determine for sure which lines in the file are selected.
    If this switch is not provided and the edge case is encountered, we will guess and attempt to comment out the selected lines, but we may guess wrong and comment out the lines above/below the selected lines.
    If this switch is provided and the edge case is encountered, no lines will be commented out.

    Edge Case:
    - When the selected text occurs multiple times in the document, directly above or below the selected text.

    Example:
    abc
    abc
    abc

    - If only the first two lines are selected, when you run this command it may comment out the 1st and 2nd lines correctly, or it may comment out the 2nd and 3rd lines, depending on
    if the caret is on the 1st line or 2nd line when selecting the text (i.e. the text is selected bottom-to-top vs. top-to-bottom).
    - Since the lines are typically identical for this edge case to occur, you likely won't really care which 2 of the 3 lines get commented out, so it shouldn't be a big deal.
    But if it bugs you, you can provide this switch.
#>
    CommentOrUncommentIseSelectedLines -CommentLines $true -DoNothingWhenNotCertainOfWhichLinesToSelect $DoNothingWhenNotCertainOfWhichLinesToComment
}

function Uncomment-IseSelectedLines([switch]$DoNothingWhenNotCertainOfWhichLinesToUncomment)
{
<#
    .SYNOPSIS
    Removes the comment character from the start of each line of the selected text in the current PS ISE file (if it is commented out).
    If no text is selected, it will uncomment the line that the caret is on.

    .DESCRIPTION
    Removes the comment character from the start of each line of the selected text in the current PS ISE file (if it is commented out).
    If no text is selected, it will uncomment the line that the caret is on.

    .PARAMETER DoNothingWhenNotCertainOfWhichLinesToUncomment
    Under the following edge case we can't determine for sure which lines in the file are selected.
    If this switch is not provided and the edge case is encountered, we will guess and attempt to uncomment the selected lines, but we may guess wrong and uncomment out the lines above/below the selected lines.
    If this switch is provided and the edge case is encountered, no lines will be uncommentet.

    Edge Case:
    - When the selected text occurs multiple times in the document, directly above or below the selected text.

    Example:
    abc
    abc
    abc

    - If only the first two lines are selected, when you run this command it may uncomment the 1st and 2nd lines correctly, or it may uncomment the 2nd and 3rd lines, depending on
    if the caret is on the 1st line or 2nd line when selecting the text (i.e. the text is selected bottom-to-top vs. top-to-bottom).
    - Since the lines are typically identical for this edge case to occur, you likely won't really care which 2 of the 3 lines get uncommented, so it shouldn't be a big deal.
    But if it bugs you, you can provide this switch.
#>
    CommentOrUncommentIseSelectedLines -CommentLines $false -DoNothingWhenNotCertainOfWhichLinesToSelect $DoNothingWhenNotCertainOfWhichLinesToUncomment
}


#==========================================================
# Add ISE Add-ons.
#==========================================================

# Add a new option in the Add-ons menu to comment all selected lines.
if (!($psISE.CurrentPowerShellTab.AddOnsMenu.Submenus | Where-Object { $_.DisplayName -eq "Comment Selected Lines" }))
{
    $psISE.CurrentPowerShellTab.AddOnsMenu.Submenus.Add("Comment Selected Lines",{Comment-IseSelectedLines},"Ctrl+K")
}

# Add a new option in the Add-ons menu to uncomment all selected lines.
if (!($psISE.CurrentPowerShellTab.AddOnsMenu.Submenus | Where-Object { $_.DisplayName -eq "Uncomment Selected Lines" }))
{
    $psISE.CurrentPowerShellTab.AddOnsMenu.Submenus.Add("Uncomment Selected Lines",{Uncomment-IseSelectedLines},"Ctrl+Shift+K")
}