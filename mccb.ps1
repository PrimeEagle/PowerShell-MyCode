# -----------------------------------------------------------------------------
# -----------------------------------------------------------------------------


. ($PSScriptRoot + "\mccmn.ps1");

$helpSummary = "Commit a build to Subversion (increments build number and tags the build)"    
$helpUsage = "LogMessage [-maj] (increments major version) [-min] (increments minor version) [-h]"
$helpExample = "`"Bug fix release`""

Show-Help $helpSummary $helpUsage $helpExample

Write-Log "Execute: mccb.ps1 $args"

$curDir = Get-Location
if((-not (IsValidDirectory($curDir))) -and (-not (IsValid-ScriptDirectory($curDir))))
{
	WriteError "Not a valid project directory."
	
	exit 2
}

# -----------------------------------------------------------------------------

$versionToTag = ""

function IncrementVersionXml($folder)
{
	$files = Get-ChildItem -Path $folder *.csproj
	$filePath = $files[0]

	$xml = [xml](Get-Content "$filePath")
	$fullVersion = $xml.Project.PropertyGroup.AssemblyVersion
	
	if($fullVersion -eq $null)
	{
		$fullVersion = "1.0.0.-1"
		$newElement = $xml.CreateElement("AssemblyVersion")
		$newChild = $xml.Project.PropertyGroup.AppendChild($newElement)
		$new = $newChild.AppendChild($xml.CreateTextNode($fullVersion))
	}

	$verArray = $fullVersion.Split(".")
	$v1 = [int]$verArray[0]
	$v2 = [int]$verArray[1]
	$v3 = [int]$verArray[2]
	$v4 = [int]$verArray[3]
	
	if($incMaj) 
	{ 
		$v1++ 
		$v2 = 0
		$v3 = 0
		$v4 = 0
	}
	if($incMin)
	{ 
		$v2++ 
		$v3 = 0
		$v4 = 0
	}
	
	if((-not($incMaj)) -and (-not($incMin)))
	{
		if($v4 -lt 9999)
		{
			$v4++
		}
		else 
		{
			if($v3 -lt 999)
			{
				$v3++
				$v4 = 0
			}
			else
			{
				WriteError "Major or Minor version needs to be manually increased. Current version is $fullVersion"
				Show-Help "" $helpUsage $helpExample $true
			}
		}
	}
	
	$newVersion = "$v1.$v2.$v3.$v4"
	
	$xml.Project.PropertyGroup.AssemblyVersion = $newVersion
	
	$xml.Save($filePath)
	
	return $newVersion
}

function IncrementVersionTxt($folder)
{
	$fullVersion = Get-Content $file
	
	if($fullVersion -eq $null)
	{
		$fullVersion = "0.0.0.-1"
	}

	$verArray = $fullVersion.Split(".")
	$v1 = [int]$verArray[0]
	$v2 = [int]$verArray[1]
	$v3 = [int]$verArray[2]
	$v4 = [int]$verArray[3]
	
		if($incMaj) 
	{ 
		$v1++ 
		$v2 = 0
		$v3 = 0
		$v4 = 0
	}
	if($incMin)
	{ 
		$v2++ 
		$v3 = 0
		$v4 = 0
	}
	
	if((-not($incMaj)) -and (-not($incMin)))
	{
		if($v4 -lt 9999)
		{
			$v4++
		}
		else 
		{
			if($v3 -lt 999)
			{
				$v3++
				$v4 = 0
			}
			else
			{
				WriteError "Major or Minor version needs to be manually increased. Current version is $fullVersion"
				Show-Help "" $helpUsage $helpExample $true
			}
		}
	}
	
	$newVersion = "$v1.$v2.$v3.$v4"
	
	Set-Content -Path $file -Value $newVersion
	
	return $newVersion
}

function Build($file)
{
	& $msbuildPrivate /property:Configuration=Release /verbosity:quiet "$file"
}

function FilesToCommit($dir)
{
	$rv = ''
	$filestatus = svn st -q $dir
	foreach($f in  $filestatus)
	{
		if(IgnoreFile($f)) {  continue;  }
		$rv += "    " + $f.substring(8, $f.length-8) + "  ```n";
	}
	return $rv
}


if ($args.count -eq 0) {
	WriteError "Commit message is required."
	Show-Help "" $helpUsage $helpExample $true
    exit 2
}

$incMaj = $false
$incMin = $false

if($args.count -gt 1)
{
	if($args[1] -eq "-maj") { $incMaj = $true }
	if($args[1] -eq "-min") { $incMin = $true }
}

if($args.count -gt 2)
{
	if($args[2] -eq "-maj") { $incMaj = $true }
	if($args[2] -eq "-min") { $incMin = $true }
}

if($args.count -gt 3)
{
	WriteError "Too many arguments."
	Show-Help "" $helpUsage $helpExample $true
    exit 2
}

$message = $args[0]

$slnFiles = @(Get-ChildItem *.sln)
$inSln = $false
$inProj = $false
$inScripts = $false

if($slnFiles.count -gt 0)
{
	$file = $slnFiles[0]
	$inSln = $true
}

if($file.length -eq 0)
{
	$projFiles = @(Get-ChildItem *.csproj)
	
	if($projFiles.count -gt 0)
	{
		$file = $projFiles[0]
		$inProj = $true
	}
}

if($file.length -eq 0)
{
		$scriptFiles = @(Get-ChildItem version.txt)
		
		if($scriptFiles.count -gt 0)
		{
			$file = $scriptFiles[0]
			$inScripts = $true
		}
}

if($file.length -eq 0)
{
	WriteError "No solution or project file found."
	exit 2
}

$currentDir = Get-Location

$toCommit = @(FilesToCommit $currentDir)

if(($toCommit.count -gt 0) -and ($toCommit[0].length -gt 0))
{
	WriteError "There are pending changes. Commit those before creating a build."
	exit 2
}


if($inSln)
{
	[System.Collections.ArrayList]$tempDirectories = Get-ChildItem -filter "*" -attributes directory | 
		Sort-Object Name | 
		Select-Object -expandProperty FullName
	
	[System.Collections.ArrayList]$directories = New-Object System.Collections.ArrayList($null);
	$directories.Add($srcDir)  > $null

	$i = 0
	$tempDirectories | ForEach-Object { 
		$path = $_
		if(($i -gt 0) -and (IsValid-ProjectDirectory($path))) {
			$directories.Add($path) > $null
		}
		$i++
	}
	
	$i = 0
	$directories | ForEach-Object {
		if($i -gt 0)
		{
			$projectFile = $_
			
			Write-Host "Incrementing version and rebuilding $projectFile..." -ForegroundColor Cyan
			$tempVer = IncrementVersionXml $projectFile 
			
			if($versionToTag.length -eq 0)
			{
				$versionToTag = $tempVer
			}
			Build($projectFile)
		}
		$i++
	}
}

if($inProj)
{
	Write-Host "Incrementing version for $file..." -ForegroundColor Cyan
	$versionToTag = IncrementVersionXml $file
	Build($file)
}

if($inScripts)
{
	Write-Host "Incrementing version for $file..." -ForegroundColor Cyan
	$versionToTag = IncrementVersionTxt $file
}



Write-Host "Commiting files..." -ForegroundColor Cyan

$files = svn st -q $currentDir
foreach($f in  $files)
{
	if(IgnoreFile($f)) {  continue;  }
}

if($files.count -gt 0)
{
	& svn ci --message "$message"
}

Write-Host "Tagging build..." -ForegroundColor Cyan
$dir = [string]$currentDir

$idx = $dir.IndexOf("My Code")
$folderPart = $dir.Substring($idx + 8)


$tagUrl = $svnTagsUrlPrivate
$tagUrl = $tagUrl.Replace("\", "/")
SvnCreateDirectory($tagUrl)

$tagUrl = $tagUrl + $folderPart + "/"
SvnCreateDirectory($tagUrl)

$tagUrl = $tagUrl + $versionToTag
SvnCreateDirectory($tagUrl)


$currentUrl = & svn info --show-item url


& svn copy $currentUrl $tagUrl -m "Auto-build, version $versionToTag"

Write-Host "Done." -ForegroundColor Cyan
# -----------------------------------------------------------------------------