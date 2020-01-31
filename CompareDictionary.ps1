Param(
    [switch]$includeEqual
)
$table1 = @{
    ServerA = '1.1.1.1'
    ServerB = '1.1.1.2'
    ServerD = '1.1.1.4'
}

$table2 = @{
    ServerA = '1.1.1.1'
    ServerB = '1.1.1.23'
    ServerC = '1.1.1.3'
}

$results = @()
# Initialize an Arraylist to hold the $table2 entries:
$unmatchedTable2Keys = [System.Collections.ArrayList]::new()
ForEach ($table2Entry in $table2.GetEnumerator().Name){
    $unmatchedTable2Keys.Add($table2Entry) | Out-Null
}

ForEach($entry in $table1.GetEnumerator()){
    $propList = [ordered]@{
        Table_1_Key = $entry.Name
        Table_1_Value = $entry.Value
    }
    # Does the key in the first table exist in the second table?

    If($entry.Name -in $table2.Keys){
        
        # If it does, remove it from $unmatchedTable2Items:
        $unmatchedTable2Keys.Remove($entry.Name)

        # Is the value the same or different between the two tables?

        If($entry.Value -eq $table2.($entry.Name)){
            If($includeEqual){
                $propList.Add('Equality','==')
                $propList.Add('Table_2_Key',"$($entry.Name)")
                $propList.Add('Table_2_Value',"$($table2.($entry.Key))")
                $results += New-Object -TypeName PSObject -Property $propList
            }
        }Else{
            # mismatch - record the difference
            $propList.Add('Equality','<>')
            $propList.Add('Table_2_Key',"$($entry.Name)")
            $propList.Add('Table_2_Value',"$($table2.($entry.Key))")
            $results += New-Object -TypeName PSObject -Property $propList
            #"$($entry.Name) $($entry.Value) <> $($entry.Name) $($table2.($entry.Key))" 
        }
    }Else{
        # mismatch - There's a new entry in the first table
        $propList.Add('Equality','<=')
        $propList.Add('Table_2_Key','-')
        $propList.Add('Table_2_Value','-')
        $results += New-Object -TypeName PSObject -Property $propList
        #"$($entry.Name) = $($entry.Value) <= NEW"
    }
}

# Check if there are any entries remaining in the second table:
If($unmatchedTable2Keys.Count -gt 0){
    ForEach($key in $unmatchedTable2Keys){
        $propList = [ordered]@{
            Table_1_Key = '-'
            Table_1_Value = '-'
            Equality = '=>'
            Table_2_Key = $key
            Table_2_Value = $table2.$key
        }
        $results += New-Object -TypeName PSObject -Property $propList
        #"NEW => $key = $($table2.$key)"
    }
} 

$results