<#
	.SYNOPSIS
	Start SQL Server Management Studio.
	
	.DESCRIPTION
	Start SQL Server Management Studio.

	.PARAMETER QueryFile
	The query file to load.
	
	.PARAMETER Server
	The SQL Server instance to use.
	
	.PARAMETER Database
	The database to use.
	
	.INPUTS
	None.

	.OUTPUTS
	None.

	.EXAMPLE
	PS> .\Start-SqlServerManagementStudio.ps1 -QueryFile query.sql -Server SQL2022 -Database SampleDB
#>
using module Varan.PowerShell.Validation
# ----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
#Requires -Version 5.0
#Requires -Modules Varan.PowerShell.Validation
[CmdletBinding(SupportsShouldProcess, ConfirmImpact = 'Low')]
param (	
		[Parameter()]		[string]$QueryFile,
		[Parameter()]		[string]$Server,
		[Parameter()]		[string]$Database
	  )
DynamicParam { Build-BaseParameters }

Begin
{	
	Write-LogTrace "Execute: $(Get-RootScriptName)"
	$minParams = Get-MinimumRequiredParameterCount -CommandInfo (Get-Command $MyInvocation.MyCommand.Name)
	$cmd = @{}

	if(Get-BaseParamHelpFull) { $cmd.HelpFull = $true }
	if((Get-BaseParamHelpDetail) -Or ($PSBoundParameters.Count -lt $minParams)) { $cmd.HelpDetail = $true }
	if(Get-BaseParamHelpSynopsis) { $cmd.HelpSynopsis = $true }
	
	if($cmd.Count -gt 1) { Write-DisplayHelp -Name "$(Get-RootScriptPath)" -HelpDetail }
	if($cmd.Count -eq 1) { Write-DisplayHelp -Name "$(Get-RootScriptPath)" @cmd }
}
Process
{
	try
	{
		$isDebug = Assert-Debug
		
		$curDir = Get-Location
		if((-not (IsValidDirectory($curDir))) -and (-not (IsValid-ScriptDirectory($curDir))))
		{
			WriteError "Not a valid project directory."
			
			exit 2
		}
		
		if($QueryFile -And (-Not(Test-Path $QueryFile)))
		{
			WriteError "Query file '$QueryFile' is invalid."
			exit 1
		}

		$ssmsPath = Get-SsmsPath;

		$parameters = @()
		if($Server) 
		{ 
			$parameters += "-S" 
			$parameters += $Server
		}

		if($Database) 
		{ 
			$parameters += "-d" 
			$parameters += "$Database" 
		}

		if($QueryFile)
		{
			$parameters += "$QueryFile" 
		}

		if ($PSCmdlet.ShouldProcess($ssmsPath, 'Execute program.')) 
		{
			& $ssmsPath -nosplash @parameters
		}
	}
	catch [System.Exception]
	{
		Write-DisplayError $PSItem.ToString() -Exit
	}
}
End
{
	Write-DisplayHost "Done." -Style Done
}
# ----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------