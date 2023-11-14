# -----------------------------------------------------------------------------
# -----------------------------------------------------------------------------


. ($PSScriptRoot + "\mccmn.ps1");

$helpSummary = "Remove the project folder."
$helpUsage = "[-h]"
$helpExample = ""

Show-Help $helpSummary $helpUsage $helpExample

Write-Log "Execute: mcrm.ps1 $args"

$curDir = Get-Location
if(-not (IsValidDirectory($curDir)))
{
	WriteError "Not a valid project directory."
	
	exit 2
}
# -----------------------------------------------------------------------------


function Remove-Project {
	Write-Host "Removing project directory $curDir..." -ForegroundColor Cyan
	Set-Location(Get-SrcDir)
	Remove-Item -recurse -force $curDir 
}
# -----------------------------------------------------------------------------


Write-Host "Remove this project directory? [y|N]" -NoNewline -ForegroundColor Yellow
$readHost = Read-Host
switch ($readHost) {
	Y { Remove-Project  }
	Default {Write-Host "Remove cancelled." -ForegroundColor Cyan}
}

Write-Host "Done." -ForegroundColor Cyan
# -----------------------------------------------------------------------------