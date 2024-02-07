<#
	.SYNOPSIS
	Adds a NuGet package source.
	
	.DESCRIPTION
	Adds a NuGet package source.

	.PARAMETER Url
	URL of the package source.
	
	.PARAMETER Name
	The name to use for the source.
	
	.PARAMETER Username
	Username for the source.
	
	.PARAMETER Password
	Password of the source.
		
	.INPUTS
	Package source URL, Name, username, and password.

	.OUTPUTS
	None.

	.EXAMPLE
	PS> .\Add-NuGetSource.ps1 -Url https://nuget.pkg.github.com/USER/index.json -Name githubsource -Username USER -Password PASSWORD
#>
using module Varan.PowerShell.Validation
# ----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
#Requires -Version 5.0
#Requires -Modules Varan.PowerShell.Validation
[CmdletBinding(SupportsShouldProcess, ConfirmImpact = 'Low')]
param (	
		[Parameter(Mandatory = $true)]	[string]$Url,
		[Parameter(Mandatory = $true)]	[string]$Name,
		[Parameter(Mandatory = $true)]	[string]$Username,
		[Parameter(Mandatory = $true)]	[string]$Password
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
		
	
		$cmd = "dotnet nuget add source ""$Url"" --name ""$Name"" --username ""$Username"" --password ""$Password"""

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