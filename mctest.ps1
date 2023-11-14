# -----------------------------------------------------------------------------
# -----------------------------------------------------------------------------

. ($PSScriptRoot + "\mccmn.ps1");

$helpSummary = "Run tests for a project."
$helpUsage = "[-h]"
$helpExample = ""

Show-Help $helpSummary $helpUsage $helpExample

Write-Log "Execute: mctest.ps1 $args"
# -----------------------------------------------------------------------------

$curDir = Get-Location
if(-not (IsValidTestDirectory($curDir)))
{
	WriteError "Not a valid test project directory."
	Show-Help "" $helpUsage $helpExample $true
	
	exit 2
}

[System.Collections.ArrayList]$files = @(Get-ChildItem -filter "*.csproj")

if($files.count -gt 0) 
{ 
	$file = $files[0] 
}
else
{
	WriteError "No solution or project file found."
	
	exit 2
}


Write-Host "Building..." -ForegroundColor Cyan
& $msbuildPrivate /property:Configuration=Release /verbosity:quiet "$file"

Write-Host "Running tests..." -ForegroundColor Cyan
& dotnet test `"$file`"

Write-Host "Done." -ForegroundColor Cyan
# -----------------------------------------------------------------------------