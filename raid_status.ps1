$OutputEncoding = [Console]::OutputEncoding
[Reflection.Assembly]::LoadWithPartialName("Microsoft.Storage.Vds") | Out-Null 
$VdsServiceLoader = New-Object Microsoft.Storage.Vds.ServiceLoader 
$VdsService = $VdsServiceLoader.LoadService($null) 
$VdsService.WaitForServiceReady() 

$volumes = $VdsService.Providers  | foreach {$_.packs} | foreach {$_.volumes}

$states=@()

foreach ( $volume in $volumes | where -Property Type -match "Mirror|Stripe|Spanned|RAID-5" ) {
  switch -Wildcard ( $volume.Health )
    {
      'Healthy' { $states += "0" }
      '*Risk*' { $states += "2" }
      'Rebuild' { $states += "1" }
      'Failed*' { $states += "3" }
    }
}
if ($states -notcontains 3 -AND $states -notcontains 2 -AND $states -notcontains 1) { echo "0"}
elseif ($states -notcontains 3 -AND $states -notcontains 2) { echo "1"}
elseif ($states -notcontains 3) { echo "2"}
else { echo "3" }
