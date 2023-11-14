# -----------------------------------------------------------------------------
# -----------------------------------------------------------------------------


. ($PSScriptRoot + "\mccmn.ps1");

$helpSummary = "Execute the SVN update command."   
$helpUsage = "[-h]"
$helpExample = ""

Show-Help $helpSummary $helpUsage $helpExample

Write-Log "Execute: mcup.ps1 $args"

$curDir = Get-Location
if((-not (IsValidDirectory($curDir))) -and (-not (IsValid-ScriptDirectory($curDir))))
{
	WriteError "Not a valid project directory."
	
	exit 2
}

# -----------------------------------------------------------------------------

$dir = Get-Location
& svn up $dir
# -----------------------------------------------------------------------------

Write-Host "Done." -ForegroundColor Cyan