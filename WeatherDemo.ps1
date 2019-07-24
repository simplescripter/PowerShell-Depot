#Weather demo
#Your API key at openweathermap.org is fe5c2a60e7255b20b113c52187629653
#The free api key only permits querying once every 10 minutes...
#Can download city ID codes here: http://bulk.openweathermap.org/sample/
#To convert Kelvin to Fahrenheit:
#  TempKelvin * 9/5 - 459.67
$littletonCityID = 5429032
$apiKey = 'fe5c2a60e7255b20b113c52187629653'
# By city name:
#$uri = "api.openweathermap.org/data/2.5/weather?q=Denver,us&mode=json&APPID=$apiKey"

# By city ID:
$uri = "api.openweathermap.org/data/2.5/weather?id=$littletonCityID&mode=json&APPID=$apiKey"

# Forecast by city ID:
$forecastURI = "api.openweathermap.org/data/2.5/forecast?id=$littletonCityID&mode=json&APPID=$apiKey"
$results = Invoke-WebRequest $uri
       # or
#$results = Invoke-WebRequest $forecastURI

Function ConvertFrom-Kelvin {
    Param(
        [double]$temp
    )
    ($temp -273.15) * 9/5 + 32 
}