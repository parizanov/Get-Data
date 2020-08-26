function Get-Data{

    Param(
    [Parameter(Mandatory=$true,
    ValueFromPipeline=$true)]
    [String[]]
    $DataSource,
    [Parameter(Mandatory=$true)]
    #[String[]]
    $ObjectProperty,
    [Parameter(Mandatory=$true)]
    [string[]]$Regex
    )

    
    $DataSource = $DataSource -split '\n'
    
    $matched=@();$i=0
    if($ObjectProperty.Count -gt 1){

        foreach($pattern in $Regex){
            $matched += [pscustomobject][ordered]@{
            ObjectProperty = $ObjectProperty[$i++]
            PropertyValue = $DataSource | Select-String -Pattern $pattern | ForEach-Object{$_.Matches} | ForEach-Object{$_.Value}}
        }

    }
    
    else{
    
        $matched = [pscustomobject][ordered]@{
        ObjectProperty = $ObjectProperty
        PropertyValue = $DataSource | Select-String -Pattern $Regex | ForEach-Object{$_.Matches} | ForEach-Object{$_.Value}}
    }

    
    $endcount = ($matched| select -First 1).propertyvalue.count
    for($i=0; $i -le $endcount; $i++){
    $obj = [pscustomobject]@{}
        foreach($item in $matched){
        
            $obj | Add-Member -NotePropertyName $item.ObjectProperty -NotePropertyValue $item.PropertyValue[$i]

        }

    
    Write-Output $obj
    }
    
}

