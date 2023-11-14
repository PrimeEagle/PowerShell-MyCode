# -----------------------------------------------------------------------------
# -----------------------------------------------------------------------------



. ($PSScriptRoot + "\mccmn.ps1");

$helpSummary = "Upgrade scripts from source control."
$helpUsage = "[-h]"
$helpExample = ""

Show-Help $helpSummary $helpUsage $helpExample

Write-Log "Execute: mcrest.ps1 $args"

# -----------------------------------------------------------------------------


$mcUrl = $(Get-SvnUrl) + $svnScripts	
Remove-Item $(Join-Path $baseScriptsPrivate "*.*")   -exclude mcconf.ps1,mcrest.ps1,mccmn.ps1 
svn export --force $mcUrl $baseScriptsPrivate 
# -----------------------------------------------------------------------------

Write-Host "Done." -ForegroundColor Cyan
