<#
	.SYNOPSIS
	Installs prerequisites for scripts.
	
	.DESCRIPTION
	Installs prerequisites for scripts.

	.INPUTS
	None.

	.OUTPUTS
	None.

	.EXAMPLE
	PS> .\Install-Scripts
#>
# ----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
#Requires -Version 5.0
[CmdletBinding(SupportsShouldProcess, ConfirmImpact = 'Medium')]
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
	Add-PathToProfile -PathVariable 'Path' -Path (Get-Location).Path
	Add-PathToProfile -PathVariable 'PSModulePath' -Path $ModulesPath
	
	if ($PSCmdlet.ShouldProcess($'Invoke-SqlCmd2', 'Install module.')) 
	{
		Install-Module -Name Invoke-SqlCmd2
	}
	
	Add-AliasToProfile -Script 'Get-CodeHelp' -Alias 'mchelp'
	Add-AliasToProfile -Script 'Get-CodeHelp' -Alias 'gch'
	Add-AliasToProfile -Script 'Build-Code' -Alias 'bc'
	Add-AliasToProfile -Script 'Build-Code' -Alias 'mcbld'
	Add-AliasToProfile -Script 'Build-EntityFrameworkContext' -Alias 'befc'
	Add-AliasToProfile -Script 'Build-EntityFrameworkContext' -Alias 'mcbef'
	Add-AliasToProfile -Script 'Build-SharedLibrary' -Alias 'bsl'
	Add-AliasToProfile -Script 'Build-SharedLibrary' -Alias 'mcbsl'
	Add-AliasToProfile -Script 'Get-CodeScriptVersion' -Alias 'gcsv'
	Add-AliasToProfile -Script 'Get-CodeScriptVersion' -Alias 'mcver'
	Add-AliasToProfile -Script 'Invoke-SqlQuery' -Alias 'isq'
	Add-AliasToProfile -Script 'Invoke-SqlQuery' -Alias 'mcsql'
	Add-AliasToProfile -Script 'Invoke-Tests' -Alias 'it'
	Add-AliasToProfile -Script 'Invoke-Tests' -Alias 'mctst'
	Add-AliasToProfile -Script 'Remove-ProjectDirectory' -Alias 'rpd'
	Add-AliasToProfile -Script 'Remove-ProjectDirectory' -Alias 'mcrem'
	Add-AliasToProfile -Script 'Set-DirectoryCodeRoot' -Alias 'sdcr'
	Add-AliasToProfile -Script 'Set-DirectoryCodeRoot' -Alias 'mccdr'
	Add-AliasToProfile -Script 'Start-SqlServerManagementStudio' -Alias 'sssms'
	Add-AliasToProfile -Script 'Start-SqlServerManagementStudio' -Alias 'mcssms'
	Add-AliasToProfile -Script 'Start-VisualStudio' -Alias 'svs'
	Add-AliasToProfile -Script 'Start-VisualStudio' -Alias 'mcvs'
	Add-AliasToProfile -Script 'Start-VisualStudioCode' -Alias 'svsc'
	Add-AliasToProfile -Script 'Start-VisualStudioCode' -Alias 'mcvsc'
}
End
{
	Format-Profile
	Complete-Install
}