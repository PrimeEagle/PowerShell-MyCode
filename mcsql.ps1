# -----------------------------------------------------------------------------
# -----------------------------------------------------------------------------


. ($PSScriptRoot + "\mccmn.ps1");

$helpSummary = "Start the SQL Server Management Studio application." 
$helpUsage = "[query.sql] [-db DatabaseName] [-h]"
$helpExample = "myquery.sql -db ProductDB"

Show-Help $helpSummary $helpUsage $helpExample

Write-Log "Execute: mcsql.ps1 $args"

$curDir = Get-Location
if(-not (IsValidDirectory($curDir)))
{
	WriteError "Not a valid project directory."
	exit 2
}

# -----------------------------------------------------------------------------


$ssmsPath = Get-SsmsPath;
if(-not (Test-Path($ssmsPath))) {
    WriteError "could not find SSMS executable; file: ${ssmspath}"
    exit 5
}


if ($args.Count -ge 1) {
    $queryFile = $args[0]
}

if (($args.Count -eq 3) -and ($args[1] -eq "-db"))
{
	$dbName = $args[2]
}

$serverName = Get-DbServer 

if($args.count -eq 0) 
{ 
	& $ssmsPath 
}
else
{
	if(Test-Path $queryFile) {
		if($args.count -eq 1) { & $ssmsPath $queryFile }
		elseif($args.count -eq 3) { & $ssmsPath  -S $serverName -d $dbName $queryFile }
		else
		{
			WriteError "Invalid arguments."
			Show-Help "", $helpUsage, $helpExample, $true
			exit 2
		}
	}
	else {
		WriteError "No query file found. File: ${queryFile}"
	}
}
# -----------------------------------------------------------------------------