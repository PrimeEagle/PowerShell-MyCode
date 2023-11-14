# -----------------------------------------------------------------------------
# -----------------------------------------------------------------------------


. ($PSScriptRoot + "\mccmn.ps1");

$helpSummary = "Show script version."     
$helpUsage = "[-h]"
$helpExample = ""

Show-Help $helpSummary $helpUsage $helpExample

Write-Log "Execute: mcver.ps1 $args"
# -----------------------------------------------------------------------------


$mcPath = $PSScriptRoot
$mcver = $mcPath + "\version.txt"
if(Test-Path $mcver) {
Get-Content $mcver | ForEach { Write-Host "Version $_" -ForegroundColor Yellow }
}
else {
	WriteError "Unable to find version file: ${mcver}"
}
# -----------------------------------------------------------------------------
