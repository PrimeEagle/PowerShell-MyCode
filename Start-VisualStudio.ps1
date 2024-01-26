<#
	.SYNOPSIS
	Starts Visual Studio and load the solution or project in the current directory.
	
	.DESCRIPTION
	Starts Visual Studio and load the solution or project in the current directory.

	.INPUTS
	None.

	.OUTPUTS
	None.

	.EXAMPLE
	PS> .\Start-VisualStudio.ps1
#>
using module Varan.PowerShell.Validation
# ----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
#Requires -Version 5.0
#Requires -Modules Varan.PowerShell.Validation
[CmdletBinding(SupportsShouldProcess, ConfirmImpact = 'None')]
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
		
		$slnFiles = Get-ChildItem *.sln

		if($slnFiles.count -gt 0)
		{
			$file = $slnFiles[0]
		}

		if($file.length -eq 0)
		{
			$projFiles = Get-ChildItem *.csproj
			
			if($projFiles.count -gt 0)
			{
				$file = $projFiles[0]
			}
		}

		if($file.length -eq 0)
		{
			$vsPath = Get-VisualStudioPath
			Start-Process $vsPath /nosplash
		}

		$vsPath = Get-VisualStudioPath
		
		if ($PSCmdlet.ShouldProcess($vcPath, 'Execute program.')) 
		{
			Start-Process $vsPath /nosplash, `"$file`"
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