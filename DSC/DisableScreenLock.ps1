Configuration "Screen"
{
   Import-DscResource -ModuleName PSDesiredStateConfiguration
Node localhost
  {
    Registry 'ACSettingIndex'
    {
      Ensure = 'Present'
      Key = 'HKEY_LOCAL_MACHINE\Software\Policies\Microsoft\Power\PowerSettings\3C0BC021-C8A8-4E07-A973-6B14CBCB2B7E'
      ValueName = 'ACSettingIndex'
      ValueType = 'DWord'
      ValueData = '0'
    }
  }
}
Screen