<#
	.SYNOPSIS
	Short description.
	
	.DESCRIPTION
	Long description.

	.PARAMETER Query
	The query to execute.
	
	.PARAMETER FileName
	The file name containing the query to execute.
	
	.PARAMETER Server
	Name of the SQL Server instance.
	
	.PARAMETER Database
	Name of the database.
	
	.PARAMETER VerboseOutput
	Whether verbose output should be used or not.
	
	.PARAMETER Output
	The file name for the output.
	
	.PARAMETER Username
	Database username.
	
	.PARAMETER Password
	Database password.
	
	.INPUTS
	Database connection info and query.

	.OUTPUTS
	None.

	.EXAMPLE
	PS> .\Invoke-SqlQuery.ps1 
#>
using module Varan.PowerShell.Validation
# ----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
#Requires -Version 5.0
#Requires -Modules Varan.PowerShell.Validation
[CmdletBinding(SupportsShouldProcess, ConfirmImpact = 'High')]
param (	
		[Parameter(Mandatory = $true, ParameterSetName = "query")]	[string]$Query,
		[Parameter(Mandatory = $true, ParameterSetName = "file")]	[string]$FileName,
		[Parameter(Mandatory = $true)]								[string]$Server,
		[Parameter(Mandatory = $true)]								[string]$Database,
		[Parameter()]												[string]$VerboseOutput,
		[Parameter()]												[string]$Output,
		[Parameter()]												[string]$Username,
		[Parameter()]												[string]$Password
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
		
		$strQuery = ""

		if($Query)
		{
			$strQuery = " -Query `"$Query`""
		}

		if($FileName)
		{
			$strFile = " -InputFile `"$FileName`""
		}

		if($Server)
		{
			$strServer = " -ServerInstance `"$Server`""
		}

		if($Database)
		{
			$strDatabase = " -Database `"$Database`""
		}

		$strOutput = ""
		if($output.length -gt 0)
		{
			$strOutput = " | Out-File -FilePath `"$Output`""
		}

		$strVerbose = ""
		if($VerboseOutput)
		{
			$strVerbose = " -Verbose"
		}

		$strCred = ""
		if($Username -And $Password)
		{
			$user = $Username
			$pw = $Password | ConvertTo-SecureString -AsPlainText -Force
			$Credential = New-Object System.Management.Automation.PSCredential ($user, $pw)
			$strCred = " -Credential $Credential"
		}
		
		$cmd = "Invoke-Sqlcmd2 $strQuery $strFile $strVerbose $strServer $strDatabase $strOutput $strCred"

		if($Query)
		{
			Write-Host "Exceuting query `"$Query`"..."
		}
		elseif($FileName)
		{
			Write-Host "Exceuting query file `"$FileName`"..."
		}

		if ($PSCmdlet.ShouldProcess($cmd, 'Invoke-Expression.')) 
		{
			Invoke-Expression $cmd
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