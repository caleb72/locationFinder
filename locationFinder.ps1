$workingDir = "C:\Users\Caleb\Documents\Development\Paula\"

Function getLocation($address) {
    $address = $address.split(" ") -join "+"
    $url = "https://maps.googleapis.com/maps/api/geocode/json?address=$($address)&sensor=false&key=AIzaSyDn-oMS5Wjbaz0GcJ633LMkQEvrQJ6xqqE"
    $request = [System.Net.WebRequest]::Create($url)
    $response = $request.GetResponse()
    $stream = $response.GetResponseStream()
    $reader = New-Object System.IO.StreamReader $stream
    $result = $reader.ReadToEnd()  
    $serializer = New-Object System.Web.Script.Serialization.JavaScriptSerializer
    $object = $serializer.DeserializeObject($result)
    $object
}

Function readInput() {
    $path = $workingDir + "input.csv"
    Write-Host $path
    Import-Csv $path    
}

[System.Reflection.Assembly]::LoadWithPartialName("System.Web.Extensions")

$addresses = readInput
Write-Host "Input Read!"

foreach($address in $addresses) {
    Write-Host "Getting: $($address.Address)"
    $data = getLocation $address.Address
    $output = "$($address.Site)|$($address.Address)|$($data.results[0].formatted_address)|$($data.results[0].geometry.location.lat)|$($data.results[0].geometry.location.lng)|$($data.results[0].partial_match)"
    Out-File -filepath ($workingDir + "output.csv") -width 1000 -inputobject $output -append
    Write-Host "$output"
}
