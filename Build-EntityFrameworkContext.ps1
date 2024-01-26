<#
	.SYNOPSIS
	Rebuild an Entity Framework database contex.
	
	.DESCRIPTION
	Rebuild an Entity Framework database contex.

	.PARAMETER Drive
	Pre-defined drive name to use.
	
	.INPUTS
	Drive letter or drive label. You can pipe drive letters or drive labels as System.String.

	.OUTPUTS
	None.

	.EXAMPLE
	PS> .\Build-EntityFrameworkContext.ps1
#>
using module Varan.PowerShell.Validation
# ----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
#Requires -Version 5.0
#Requires -Modules Varan.PowerShell.Validation
[CmdletBinding(SupportsShouldProcess, ConfirmImpact = 'High')]
param (	
		[Parameter(Mandatory = $true)]	[string]$Context
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
		if(-not (IsValidDirectory($curDir)))
		{
			WriteError "Not a valid project directory."
			
			exit 2
		}

		# -----------------------------------------------------------------------------

		if (-not (test-path .\*.csproj)) {
			WriteError "No project file found in current directory. Script must be run from the same directory as a .csproj file"
			Show-Help "" $helpUsage $helpSummary $true
		}

		$fullContext = $Context + "DbContext"
		
		Write-Host "Reverting to initial migration..." -ForegroundColor Cyan
		if ($PSCmdlet.ShouldProcess($fullContext, 'Create identity schema.')) {
			& dotnet ef database update CreateIdentitySchema --context $fullContext
		}

		Write-Host "Removing migration..." -ForegroundColor Cyan
		if ($PSCmdlet.ShouldProcess($fullContext, 'Remove migrations.')) {
			& dotnet ef migrations remove --context $fullContext
		}

		Write-Host "Adding new migration..." -ForegroundColor Cyan
		if ($PSCmdlet.ShouldProcess($fullContext, 'Add migrations.')) {
			& dotnet ef migrations add Initialize --context $fullContext
		}

		Write-Host "Updating database..." -ForegroundColor Cyan
		if ($PSCmdlet.ShouldProcess($fullContext, 'Update database.')) {
			& dotnet ef database update --context $fullContext
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