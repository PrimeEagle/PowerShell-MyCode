# -----------------------------------------------------------------------------
# -----------------------------------------------------------------------------


. ($PSScriptRoot + "\mccmn.ps1");

$helpSummary = "Start Visual Studio and load the solution or project in the current directory."
$helpUsage = "[-h]"
$helpExample = ""

Show-Help $helpSummary $helpUsage $helpExample

Write-Log "Execute: mcvs.ps1 $args"

$curDir = Get-Location
if(-not (IsValidDirectory($curDir)))
{
	WriteError "Not a valid project directory."
	
	exit 2
}

# -----------------------------------------------------------------------------


$slnFiles = Get-ChildItem *.sln

if($slnFiles.count -gt 0)
{
	$file = $slnFiles[0]
}

if($file.length -eq 0)
{
	$projFiles = Get-ChildItem *.csproj
	
	if($projFiles.count -gt 0)
	{
		$file = $projFiles[0]
	}
}

if($file.length -eq 0)
{
	WriteError("No solution or project file found.")
	exit 2
}

$vsPath = Get-VisualStudioPath
Start-Process $vsPath /nosplash, `"$file`"
# -----------------------------------------------------------------------------