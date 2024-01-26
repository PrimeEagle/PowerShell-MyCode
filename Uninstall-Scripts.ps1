<#
	.SYNOPSIS
	Uninstalls prerequisites for scripts.
	
	.DESCRIPTION
	Uninstalls prerequisites for scripts.

	.INPUTS
	None.

	.OUTPUTS
	None.

	.EXAMPLE
	PS> .\Uninstall-Scripts
#>
# ----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
#Requires -Version 5.0
[CmdletBinding(SupportsShouldProcess)]
param ([Parameter()] [switch] $UpdateHelp,
	   [Parameter(Mandatory = $true)] [string] $ModulesPath)

Begin
{
	$script = $MyInvocation.MyCommand.Name
	if(-Not (Test-Path ".\$script"))
	{
		Write-Host "Installation must be run from the same directory as the installer script."
		exit
	}

	if(-Not (Test-Path $ModulesPath))
	{
		Write-Host "'$ModulesPath' was not found."
		exit
	}

	$Env:PSModulePath += ";$ModulesPath"
	
	Import-LocalModule Varan.PowerShell.SelfElevate
	$boundParams = @{}
	$PSCmdlet.MyInvocation.BoundParameters.GetEnumerator() | ForEach-Object { $boundParams[$_.Key] = $_.Value }
	Open-ElevatedConsole -CallerScriptPath $PSCommandPath -OriginalBoundParameters $boundParams
}

Process
{	
	Remove-PathFromProfile -PathVariable 'Path' -Path (Get-Location).Path
	
	if ($PSCmdlet.ShouldProcess('Invoke-SqlCmd2', 'Uninstall module.')) 
	{
		Uninstall-Module -Name Invoke-SqlCmd2
	}
	
	Remove-AliasFromProfile -Script 'Get-CodeHelp' -Alias 'mchelp'
	Remove-AliasFromProfile -Script 'Get-CodeHelp' -Alias 'gch'
	Remove-AliasFromProfile -Script 'Build-Code' -Alias 'bc'
	Remove-AliasFromProfile -Script 'Build-Code' -Alias 'mcbld'
	Remove-AliasFromProfile -Script 'Build-EntityFrameworkContext' -Alias 'befc'
	Remove-AliasFromProfile -Script 'Build-EntityFrameworkContext' -Alias 'mcbef'
	Remove-AliasFromProfile -Script 'Build-SharedLibrary' -Alias 'bsl'
	Remove-AliasFromProfile -Script 'Build-SharedLibrary' -Alias 'mcbsl'
	Remove-AliasFromProfile -Script 'Get-CodeScriptVersion' -Alias 'gcsv'
	Remove-AliasFromProfile -Script 'Get-CodeScriptVersion' -Alias 'mcver'
	Remove-AliasFromProfile -Script 'Invoke-SqlQuery' -Alias 'isq'
	Remove-AliasFromProfile -Script 'Invoke-SqlQuery' -Alias 'mcsql'
	Remove-AliasFromProfile -Script 'Invoke-Tests' -Alias 'it'
	Remove-AliasFromProfile -Script 'Invoke-Tests' -Alias 'mctst'
	Remove-AliasFromProfile -Script 'Remove-ProjectDirectory' -Alias 'rpd'
	Remove-AliasFromProfile -Script 'Remove-ProjectDirectory' -Alias 'mcrem'
	Remove-AliasFromProfile -Script 'Set-DirectoryCodeRoot' -Alias 'sdcr'
	Remove-AliasFromProfile -Script 'Set-DirectoryCodeRoot' -Alias 'mccdr'
	Remove-AliasFromProfile -Script 'Start-SqlServerManagementStudio' -Alias 'sssms'
	Remove-AliasFromProfile -Script 'Start-SqlServerManagementStudio' -Alias 'mcssms'
	Remove-AliasFromProfile -Script 'Start-VisualStudio' -Alias 'svs'
	Remove-AliasFromProfile -Script 'Start-VisualStudio' -Alias 'mcvs'
	Remove-AliasFromProfile -Script 'Start-VisualStudioCode' -Alias 'svsc'
	Remove-AliasFromProfile -Script 'Start-VisualStudioCode' -Alias 'mcvsc'
}

End
{
	Format-Profile
	Complete-Install
}