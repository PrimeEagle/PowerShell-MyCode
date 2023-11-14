# -----------------------------------------------------------------------------

. ($PSScriptRoot + "\mccmn.ps1");

$helpSummary = "Change the directory to the scripts directory."
$helpUsage = "[-h]"
$helpExample = ""

Show-Help $helpSummary $helpUsage $helpExample

Write-Log "Execute: cdmcs.ps1 $args"
# -----------------------------------------------------------------------------

Set-Location($codeScriptsRootDir)

# -----------------------------------------------------------------------------