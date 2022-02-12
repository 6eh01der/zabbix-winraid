$OutputEncoding = [Console]::OutputEncoding
[Reflection.Assembly]::LoadWithPartialName("Microsoft.Storage.Vds") | Out-Null 
$VdsServiceLoader = New-Object Microsoft.Storage.Vds.ServiceLoader 
$VdsService = $VdsServiceLoader.LoadService($null) 
$VdsService.WaitForServiceReady() 

# Получим коллекцию томов присутствующих в системе
$volumes = $VdsService.Providers  | foreach {$_.packs} | foreach {$_.volumes}

$vol=@()

foreach ( $row in $volumes | where -Property Type -match "Mirror|Stripe|Spanned|RAID-5" ) {
switch -Wildcard ( $volumes.Health )
{
'Healthy' { $vol += "0" }
'*Risk*' { $vol += "2" }
'Rebuild' { $vol += "1" }
'Failed*' { $vol += "3" }
}
}
if ($vol -notcontains 3 -AND $vol -notcontains 2 -AND $vol -notcontains 1) { echo "0"}
if ($vol -notcontains 3 -AND $vol -notcontains 2 -AND $vol -contains 1) { echo "1"}
if ($vol -notcontains 3 -AND $vol -contains 2) { echo "2"}
if ($vol -contains 3) { echo "3" }