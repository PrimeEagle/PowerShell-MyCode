# -----------------------------------------------------------------------------
# -----------------------------------------------------------------------------


. ($PSScriptRoot + "\mccmn.ps1");

$helpSummary = "Change the directory to the root project directory."
$helpUsage = "[-h]"
$helpExample = ""

Show-Help $helpSummary $helpUsage $helpExample

Write-Log "Execute: cdmcr.ps1 $args"
# -----------------------------------------------------------------------------


Set-Location($codeRootDir)

# -----------------------------------------------------------------------------