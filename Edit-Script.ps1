<#
	.SYNOPSIS
	Edits a script file.
	
	.DESCRIPTION
	Edits a script file.

	.PARAMETER Names
	Comma delimited list of file names or aliases to edit.
	
	.PARAMETER VisualStudio
	Edit in Visual Studio instead of the default script editor.
	
	.INPUTS
	File names to edit, and switch for choosing editor.

	.OUTPUTS
	None.

	.EXAMPLE
	PS> .\Edit-MusicScript.ps1 file1.txt,file2.txt
#>
using module Varan.PowerShell.Validation
# ----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
#Requires -Version 5.0
#Requires -Modules Varan.PowerShell.Validation
[CmdletBinding(SupportsShouldProcess, ConfirmImpact = 'None')]
param (	[Parameter(Position = 0, Mandatory = $true)]  [string[]]$Names,
	    [Parameter()]								  [switch]$VisualStudio
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
		$editor = $scriptEditorExe
		$vs = $visualStudioExe
		$paths = $env:Path -split ';'
		
		foreach($name in $Names)
		{
			$found = $false
			
			if(-Not $name.EndsWith(".ps1"))
			{
				$name += ".ps1"
			}
			
			foreach ($path in $paths) 
			{
				$fullPath = Join-Path $path $name
				if (Test-Path $fullPath) 
				{
					$found = $true
					break
				}
			}

			if(-Not $found)
			{
				$aliasName = $name.Substring(0, $name.Length - 4)

				$alias = Get-Alias $aliasName  -ErrorAction SilentlyContinue
				
				if($alias)
				{
					$commandName = $alias.Definition + ".ps1"

					foreach ($path in $paths) 
					{
						$fullPath = Join-Path $path $commandName
						if (Test-Path $fullPath) 
						{
							$found = $true
							break
						}
					}
				}
			}
			
			if($VisualStudio)
			{
				$joinedArgs = @()
				
				foreach($f in $Files)
				{
					if($f.IndexOf(".ps1") -lt 0) { $f += ".ps1" }
					$f = "$codeScriptsRootDir$f"
					
					$joinedArgs += $f
				}
				
				& $vsPath /nosplash $joinedArgs
			}
			else
			{
				foreach($f in $Files)
				{
					if($f.IndexOf(".ps1") -lt 0) { $f += ".ps1" }
					$f = "$codeScriptsRootDir$f"
					
					& $editor $f
				}
			}	
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