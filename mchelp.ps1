# -----------------------------------------------------------------------------
# -----------------------------------------------------------------------------

. ($PSScriptRoot + "\mccmn.ps1");

if($args.count -gt 0)
{
	$helpSummary = "Show command summary."
	$helpUsage = "[-h]"
	$helpExample = ""

	Show-Help $helpSummary $helpUsage $helpExample
}

Write-Log "Execute: mchelp.ps1 $args"
# -----------------------------------------------------------------------------

$mcPath = $PSScriptRoot
$mcver = $mcPath + "\version.txt"
if(Test-Path $mcver) {
	$ver = Get-Content $mcver
}

$verStr = ""
if($ver.length -gt 0)
{
	$verStr = "(version $ver)"
}

Write-Host "Commands $verStr" -ForegroundColor Yellow

Get-ChildItem $PSScriptRoot -Filter "*.ps1" | Sort-Object Name | Foreach-Object -Process {
	if($_.Name -eq "mccmn.ps1") { return }
	if($_.Name -eq "mcconf.ps1") { return }

	& $_.FullName -hh
} 
# -----------------------------------------------------------------------------