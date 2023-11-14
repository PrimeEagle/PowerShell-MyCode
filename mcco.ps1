# -----------------------------------------------------------------------------
# -----------------------------------------------------------------------------

. ($PSScriptRoot + "\mccmn.ps1");

$helpSummary = "Get a new project from SVN."
$helpUsage = "project [-t] [optional tag] [-h]"
$helpExample = "VNet.Utility -t 1.0.2.3"

Show-Help $helpSummary $helpUsage $helpExample

Write-Log "Execute: mcco.ps1 $args"
# -----------------------------------------------------------------------------

$basePath = Get-SrcDir;
$baseSvnUrl = Get-SvnUrl;

$args = $script:MyInvocation.UnboundArguments
if($args[0].length -eq 0)
{
	WriteError "No project was specified."
	Show-Help "" $helpUsage $helpExample $true
	
	exit 2
}

$project = $args[0]

if($args[1] -eq "-t") {  $tag = $args[2]  }

$targetFolder = $basePath + $project
if($tag.length -gt 0)
{
	$targetFolder = $targetFolder + " " + $tag
}

if($tag.length -eq 0)
{
	$sourceUrl = $baseSvnUrl + $project
}
else
{
	$sourceUrl = $baseSvnUrl + "Tags/" + $project + "/" + $tag + "/" + $project
}


if(Test-Path $targetFolder)
{
	WriteError "Target directory already exists. No actions performed."
	
	exit 2
}

Write-Host "Creating folder..." -ForegroundColor Cyan
mkdir $targetFolder  > $null

Write-Host "Getting source..." -ForegroundColor Cyan
& svn co $sourceUrl $targetFolder --depth infinity

Set-Location $targetFolder

[System.Collections.ArrayList]$files = @(Get-ChildItem -filter "*.sln")
if($files.count -gt 0) 
{ 
	$file = $files[0] 
}
else 
{
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
}

Write-Host "Building..." -ForegroundColor Cyan
Set-Location $targetFolder
& $msbuildPrivate /property:Configuration=Debug /verbosity:quiet "$file"
& $msbuildPrivate /property:Configuration=Release /verbosity:quiet "$file"

Write-Host "Done." -ForegroundColor Cyan
# -----------------------------------------------------------------------------