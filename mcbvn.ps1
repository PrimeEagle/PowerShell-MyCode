# -----------------------------------------------------------------------------
# -----------------------------------------------------------------------------

. ($PSScriptRoot + "\mccmn.ps1");

$helpSummary = "Build all VNet projects."
$helpUsage = "[-h]"
$helpExample = ""

Show-Help $helpSummary $helpUsage $helpExample

Write-Log "Execute: mcbvn.ps1 $args"
# -----------------------------------------------------------------------------

#$curDir = Get-Location
#if(-not (IsValidDirectory($curDir)))
#{
#	Write-Error "Not a valid project directory."
#	
#	exit 2
#}

$mcPath = $PSScriptRoot

Get-ChildItem $PSScriptRoot -Filter "VNet.*" | Foreach-Object -Process {
	"$($_.FullName)"
} 

exit 0

$files = @(Get-ChildItem -filter "*.sln")
if($files.count -gt 0) 
{ 
	$file = $files[0] 
}
else 
{
	$files = @(Get-ChildItem -filter "*.csproj")
	
	if($files.count -gt 0) 
	{ 
		$file = $files[0] 
	}
	else
	{
		WriteError "No solution or project file found."
		
		exit 2
	}
}

Write-Host "Building..." -ForegroundColor Cyan

& $msbuildExe /property:Configuration=Debug /verbosity:quiet "$file"
& $msbuildExe /property:Configuration=Release /verbosity:quiet "$file"

Write-Host "Done." -ForegroundColor Cyan
# -----------------------------------------------------------------------------