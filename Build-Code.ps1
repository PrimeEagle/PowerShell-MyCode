<#
	.SYNOPSIS
	Builds the solution or project in the current directory.
	
	.DESCRIPTION
	Builds the solution or project in the current directory.

	.INPUTS
	None.

	.OUTPUTS
	None.

	.EXAMPLE
	PS> .\Build-Code.ps1
#>
using module Varan.PowerShell.Validation
# ----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
#Requires -Version 5.0
#Requires -Modules Varan.PowerShell.Validation
[CmdletBinding(SupportsShouldProcess, ConfirmImpact = 'Low')]
param (	
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
			Write-Error "Not a valid project directory."
			
			exit 2
		}


		$files = @(Get-ChildItem -filter "*.sln")
		if($files.count -gt 0) 
		{ 
			$file = $files[0] 
		}
		else 
		{
			$files = @(Get-ChildItem -filter "*.csproj")
			
			if($files.count -gt 0) 
			{ 
				$file = $files[0] 
			}
			else
			{
				WriteError "No solution or project file found."
				
				exit 2
			}
		}

		Write-Host "Building..." -ForegroundColor Cyan

		if ($PSCmdlet.ShouldProcess($file, "Build for 'Debug'.")) 
		{
			& $msbuildExe /property:Configuration=Debug /verbosity:quiet "$file"
		}
		
		if ($PSCmdlet.ShouldProcess($file, "Build for 'Release'.")) 
		{
			& $msbuildExe /property:Configuration=Release /verbosity:quiet "$file"
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