# -----------------------------------------------------------------------------
# -----------------------------------------------------------------------------


. ($PSScriptRoot + "\mccmn.ps1");

$helpSummary = "Start SQL Server Management Studio."
$helpUsage = "[-s server\instance] [-d database] [-f sql file] [-h]"
$helpExample = "-s localhost\SQL2017 -d ProductDB -f test.sql"

Show-Help $helpSummary $helpUsage $helpExample

Write-Log "Execute: mcssms.ps1 $args"

$curDir = Get-Location
if((-not (IsValidDirectory($curDir))) -and (-not (IsValid-ScriptDirectory($curDir))))
{
	WriteError "Not a valid project directory."
	
	exit 2
}

$args = $script:MyInvocation.UnboundArguments

$server = ""
$database = ""
$queryFile = ""

$i = 0
foreach($a in $args)
{
	if($a -eq "-s") { $server = $args[$i+1]}
	if($a -eq "-d") { $database = $args[$i + 1]}
	if($a -eq "-f") { $queryFile = $args[$i + 1]}
	
	$i++
}

if(($queryFile.length -gt 0) -and (-not(Test-Path $queryFile)))
{
	WriteError "Query file '$queryFile' is invalid."
	exit 1
}

$ssmsPath = Get-SsmsPath;

$parameters = @()
if($server.length -gt 0) 
{ 
	$parameters += "-S" 
	$parameters += $server
}

if($database.length -gt 0) 
{ 
	$parameters += "-d" 
	$parameters += "$database" 
}

if($queryFile.length -gt 0) 
{
	$parameters += "$queryFile" 
}

& $ssmsPath -nosplash @parameters

# -----------------------------------------------------------------------------