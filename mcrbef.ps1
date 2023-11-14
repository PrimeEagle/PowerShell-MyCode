# -----------------------------------------------------------------------------
# -----------------------------------------------------------------------------


. ($PSScriptRoot + "\mccmn.ps1");

$helpSummary = "Rebuild an Entity Framework database context."     
$helpUsage = " ContextName (without 'DbContext' suffix) [-h]"
$helpExample = " Product"

Show-Help $helpSummary $helpUsage $helpExample

Write-Log "Execute: mcrbef.ps1 $args"

$curDir = Get-Location
if(-not (IsValidDirectory($curDir)))
{
	WriteError "Not a valid project directory."
	
	exit 2
}

# -----------------------------------------------------------------------------

if ($args.Count -ne 1) {
	Show-Help "" $helpUsage $helpSummary $true
	exit 2
}

if (-not (test-path .\*.csproj)) {
	WriteError "No project file found in current directory. Script must be run from the same directory as a .csproj file"
	Show-Help "" $helpUsage $helpSummary $true
}

$context = $args[0]
$fullContext = $context + "DbContext"

Write-Host "Reverting to initial migration..." -ForegroundColor Cyan
& dotnet ef database update CreateIdentitySchema --context $fullContext

Write-Host "Removing migration..." -ForegroundColor Cyan
& dotnet ef migrations remove --context $fullContext

Write-Host "Adding new migration..." -ForegroundColor Cyan
& dotnet ef migrations add Initialize --context $fullContext

Write-Host "Updating database..." -ForegroundColor Cyan
& dotnet ef database update --context $fullContext

Write-Host "Done." -ForegroundColor Cyan