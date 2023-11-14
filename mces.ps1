# -----------------------------------------------------------------------------
# -----------------------------------------------------------------------------


. ($PSScriptRoot + "\mccmn.ps1");

$helpSummary = "Edit PowerShell scripts in either Notepad++ or Visual Studio." 
$helpUsage = " [-vs] [script1 script2 script3 ...] [-h]"
$helpExample = "mccb mcci mcconf"

Show-Help $helpSummary $helpUsage $helpExample

Write-Log "Execute: mces.ps1 $args"
# -----------------------------------------------------------------------------

if($args.count -eq 0)
{
	WriteError "Script name is required."
	Show-Help "" $helpUsage $helpExample $true
	exit 2
}

$editor = $scriptEditorProcExe

$useVS = $false
$vsPath = Get-VisualStudioPath

$args | ForEach-Object {
	if($_ -eq "-vs") { $useVs = $true }
}

if($useVs)
{
	$joinedArgs = @()
	
	$args | ForEach-Object { 
		$arg = "$baseScriptsPrivate" + "$_"
		
		if($_ -ne "-vs")
		{
			if($arg.IndexOf(".ps1") -lt 0)
			{
				$arg = "$arg.ps1"
			}

			$joinedArgs += "$arg"
			
			"arg = $arg"
			"joined = $joinedArgs"
			" "
		}
	}
	"$vsPath /nosplash $joinedArgs"
	& $vsPath /nosplash $joinedArgs
}
else
{
	$args | ForEach-Object { 
		$arg = "$baseScriptsPrivate" + "$_"
		
		if($_ -ne "-vs")
		{
			"arg = $arg"
			if($arg.IndexOf(".ps1") -lt 0)
			{
				$arg = "$arg.ps1"
			}

			& $editor $arg
		}
	}
}
# -----------------------------------------------------------------------------