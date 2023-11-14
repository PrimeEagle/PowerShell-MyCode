# -----------------------------------------------------------------------------
# -----------------------------------------------------------------------------


. ($PSScriptRoot + "\mccmn.ps1");

Import-Module -Name SqlServer

$helpSummary = "Execute a SQL query."      
$helpUsage = " [[-q query] | [-f filename]] [-s server] [-db database] [-o outputFile] [-v (verbose)] [-h]"
$helpExample = "-q `"select count(*) from Product`" -s SQL2016 -db Product"

Show-Help $helpSummary $helpUsage $helpExample

Write-Log "Execute: mcdbq.ps1 $args"
# -----------------------------------------------------------------------------

if ($args.count -lt 1) {
	WriteError "A query is required."
	Show-Help "" $helpUsage $helpExample $true
    exit 2
}

$verbose = $false

if($args.count -gt 1)
{
	for($i=0; $i -le $args.length-1; $i++)
	{
		if($args[$i] -eq "-q") { $query = $args[$i + 1] }
		if($args[$i] -eq "-f") { $file = $args[$i + 1] }
		if($args[$i] -eq "-s") { $server = $args[$i + 1] }
		if($args[$i] -eq "-db") { $database = $args[$i + 1] }
		if($args[$i] -eq "-o") { $output = $args[$i + 1] }
		if($args[$i] -eq "-v") { $verbose = $true }
	}
}

if(($query.length -gt 0) -and ($file.length -gt 0))
{
	WriteError "A query and a file cannot both be specified."
	Show-Help "" $helpUsage $helpExample $true
    exit 2
}

$strQuery = ""
if($query.length -gt 0)
{
	$strQuery = " -Query `"$query`""
}

$strFile = ""
if($file.length -gt 0)
{
	$strFile = " -InputFile `"$file`""
}

$strServer = " -ServerInstance `"$dbServerPrivate`""
if($server.length -gt 0)
{
	$strServer = " -ServerInstance `"$server`""
}

$strDatabase = " -Database `"$defaultDatabase`""
if($database.length -gt 0)
{
	$strDatabase = " -Database `"$database`""
}

$strOutput = ""
if($output.length -gt 0)
{
	$strOutput = " | Out-File -FilePath `"$output`""
}

$strVerbose = ""
if($verbose -eq $true)
{
	"Verbose"
	$strVerbose = " -Verbose"
}

$cmd = "Invoke-Sqlcmd $strQuery $strFile $strVerbose $strServer $strDatabase $strOutput"

if($query.length -gt 0)
{
	Write-Host "Exceuting query `"$query`"..." -ForegroundColor Cyan
}
elseif($file.length -gt 0)
{
	Write-Host "Exceuting query file `"$file`"..." -ForegroundColor Cyan
}

Invoke-Expression $cmd

#Write-Host $t -ForegroundColor DarkCyan

Write-Host "Done." -ForegroundColor Cyan
# -----------------------------------------------------------------------------
