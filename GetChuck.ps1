Function Get-Chuck {
    $headers=@{}
    $headers.Add("x-rapidapi-host", "matchilling-chuck-norris-jokes-v1.p.rapidapi.com")
    $headers.Add("x-rapidapi-key", "ab827a7c18msh69957d2992bc00ap1fa16ejsnbc26c13c911e")
    $headers.Add("accept", "application/json")
    $response = Invoke-RestMethod -Uri 'https://matchilling-chuck-norris-jokes-v1.p.rapidapi.com/jokes/random' -Method GET -Headers $headers
    $response.value
}
