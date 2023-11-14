# -----------------------------------------------------------------------------
# -----------------------------------------------------------------------------


. ($PSScriptRoot + "\mccmn.ps1");

$helpSummary = "Rebuild shared libraries."   
$helpUsage = "[-h]"
$helpExample = ""

Show-Help $helpSummary $helpUsage $helpExample

Write-Log "Execute: mcbsl.ps1 $args"
# -----------------------------------------------------------------------------

Write-Host "Finding shared library projects..." -ForegroundColor Cyan
$srcDir = $basepathPrivate
[System.Collections.ArrayList]$tempDirectories = get-childItem -path $srcDir -Recurse -Depth 1 -Exclude *.Test,*.Tests -filter "VNet.*" -attributes directory | 
		Sort-Object Name | 
		Select-Object -expandProperty FullName  

[System.Collections.ArrayList]$directories = New-Object System.Collections.ArrayList($null);

$tempDirectories | ForEach-Object { 
	$path = $_;

	if(IsValid-ProjectDirectory($path)) {
		$directories.Add($path) > $null
		$paths
	}
}

$directories | ForEach-Object { 
		$path = $_.substring($srcDir.length);
		$projects = Get-ChildItem "$srcDir$path\*.csproj"
		$project = $projects[0].FullName
		
		Write-Host "Building $project..." -ForegroundColor Cyan
		& $msbuildPrivate /property:Configuration=Release "$project"
}

Write-Host "Done." -ForegroundColor Cyan