# -----------------------------------------------------------------------------
# -----------------------------------------------------------------------------


. ($PSScriptRoot + "\mccmn.ps1");

Import-Module -Name SqlServer

$helpSummary = "Installs necessary components for PowerShell scripts."      
$helpUsage = "[-h]"
$helpExample = ""

Show-Help $helpSummary $helpUsage $helpExample

Write-Log "Execute: mcinst.ps1 $args"
# -----------------------------------------------------------------------------

Install-Module sqlserver 