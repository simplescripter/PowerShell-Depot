$lat = 39.624532
$long = -105.013504
$uri = "https://api.weather.gov/points/$lat,$long"
$results = Invoke-RestMethod $uri

