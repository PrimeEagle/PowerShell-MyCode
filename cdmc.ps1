# -----------------------------------------------------------------------------
# -----------------------------------------------------------------------------


. ($PSScriptRoot + "\mccmn.ps1");

$helpSummary = "Change the directory to a Factorio mod directory."
$helpExample = "cdmod"
$modRoot = "D:\AppDataFactorio\mods"

Show-Help $helpSummary $helpUsage $helpExample

Write-Log "Execute: cdmod.ps1 $args"
# -----------------------------------------------------------------------------

function Get-ModDirectories()
{
	$directories = @()
	$dirs = @(Get-ChildItem -Path $modRoot -Force -Directory | 
			Sort-Object Name | 
			Select-Object -ExpandProperty FullName)
	
	$dirs | ForEach-Object { 
		$directories += $_.FullName
	}
	
	return $directories
}

$dirs = @()
$dirs = Get-ModDirectories

$c = 0
$slnPath = ""

foreach($fullPath in $dirs) { 
	$c++
	$displayPath = ($fullPath | Split-Path -Leaf)
	$slnPath = $displayPath
	$entry = "  {0:d2}" -f [int32]$c
	Write-Host $entry -NoNewLine -ForegroundColor DarkYellow
	$entry = "     $displayPath [Solution]"
	Write-Host $entry -ForegroundColor Cyan
}

$selected = Read-Host 'Directory'

$ss = -1;
if([int]::TryParse($selected, [ref] $ss) -and $ss -ge 0 -and $ss -le $c) {
	Set-Location($dirs[$ss - 1])
}
# -----------------------------------------------------------------------------