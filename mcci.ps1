# -----------------------------------------------------------------------------
# -----------------------------------------------------------------------------

. ($PSScriptRoot + "\mccmn.ps1");

$helpSummary = "Commit project to SVN."
$helpUsage = "[comment] [-h]"
$helpExample = "`"fixed bugs`""

Show-Help $helpSummary $helpUsage $helpExample

Write-Log "Execute: mcci.ps1 $args"
# -----------------------------------------------------------------------------

function FilesToCommit($dir)
{
	$rv = ''
	$filestatus = svn st -q $dir
	foreach($f in  $filestatus)
	{
		if(IgnoreFile($f)) {  continue;  }
		$rv += "    " + $f.substring(8, $f.length-8) + "  `n";
	}
	return $rv
}
# -----------------------------------------------------------------------------

function CommitFiles($srcdir, $message)
{
	if($message.length -eq 0)
	{
		$message = ""
	}

	&svn ci $srcDir -m `"$message`"
} 

$curDir = Get-Location
if((-not (IsValidDirectory($curDir))) -and (-not (IsValid-ScriptDirectory($curDir))))
{
	WriteError "Not a valid project directory."
	
	exit 2
}

$filesToCommit = @(svn st -q $curDir)

if($filesToCommit.length -eq 0)
{
	Write-Host "Nothing to commit." -ForegroundColor Cyan
	exit 0
}

$args = $script:MyInvocation.UnboundArguments

if($args[0].length -eq 0)
{
	Write-Host "Are you sure you want to commit without a comment? [y|N]" -NoNewline -ForegroundColor Yellow
	
	$readHost = Read-Host
	
	switch ($readHost) {
		Y {  }
		Default 
		{
			Write-Host "Commit cancelled." -ForegroundColor Cyan
			exit 0
		}
	}
}

$comment = $args[0]

Write-Host "    Log: $comment" -ForegroundColor Cyan
Write-Host

FilesToCommit $curDir $comment

Write-Host "Are you sure you want to commit these files? [y|N]" -NoNewline -ForegroundColor Yellow

$readHost = Read-Host

switch ($readHost) {
	Y { CommitFiles $curDir $comment }
	Default 
	{
		Write-Host "Commit cancelled." -ForegroundColor Cyan
		exit 0
	}
}

Write-Host "Done." -ForegroundColor Cyan

exit 0