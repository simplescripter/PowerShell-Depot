Function global:ReadHost-Color
 (
  [string]$prompt = "Next time, provide your own prompt",
  [string]$color = "yellow"
  )
  {
  [Console]::ForeGroundColor = $color
  Read-Host $prompt
  [Console]::ResetColor()
  }