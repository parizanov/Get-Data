function Get-Data{
    <#
    .SYNOPSIS
    Returns extracted data from a data source(file, web page, etc.) in the form of a PS object.
    
    .DESCRIPTION
    The Get-Data function can be used to extract data from a data source (file, web page, etc) and it will return PS object. You must provide the data source,
    parametrers' names and regular expression to pull out the information you want and receive it in the form of PS object. The data then can be used for further processing
    or stored in a database.
    
    .PARAMETER DataSource
    Path to the file from where you will extract the information.
    
    .PARAMETER ObjectProperty
    Name/Names of the object property/properties.
    
    .PARAMETER Regex
    Regular expression for each object property name, so that you have values for 
    the properties.
    
    .EXAMPLE
    Get-Data 
    
    .EXAMPLE
    
    .NOTES
    
    
    #>
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

    #$obj = [pscustomobject]@{}
    $propvaluecount = ($matched | select -First 1).propertyvalue.count
    $objpropcount = $matched.objectproperty.count
    if($propvaluecount -eq 1 -and $objpropcount -eq 1 ){$obj = [pscustomobject]@{}
        $obj | Add-Member -NotePropertyName $matched.ObjectProperty -NotePropertyValue $matched.PropertyValue
        Write-Output $obj
    }
    elseif($propvaluecount -eq 1 -and $objpropcount -gt 1){
       $result = @()
        $obj = [pscustomobject]@{}
            foreach($item in $matched){
               #
               $obj | Add-Member -NotePropertyName $item.ObjectProperty -NotePropertyValue $item.PropertyValue -Force

            }
            $result += $obj
            
        Write-Output $result 
    }
    else{
        $result = @()
        for($i=0; $i -le $propvaluecount; $i++){
        $obj = [pscustomobject]@{}
            foreach($item in $matched){
               #
               $obj | Add-Member -NotePropertyName $item.ObjectProperty -NotePropertyValue $item.PropertyValue[$i] -Force

            }
            $result += $obj
            
        }
        Write-Output $result
    }

    
    
}
