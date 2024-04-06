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
	
	if (-Not ([Security.Principal.WindowsPrincipal][Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole] "Administrator")) {
		Start-Process -FilePath "pwsh.exe" -ArgumentList "-File `"$PSCommandPath`"", "-ModulesPath `"$ModulesPath`"" -Verb RunAs
		exit
	}
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
	Remove-AliasFromProfile -Script 'Add-NuGetSource' -Alias 'ans'
	Remove-AliasFromProfile -Script 'Add-NuGetSource' -Alias 'mcans'
	Remove-AliasFromProfile -Script 'Build-Code' -Alias 'bc'
	Remove-AliasFromProfile -Script 'Build-Code' -Alias 'mcbld'
	Remove-AliasFromProfile -Script 'Build-EntityFrameworkContext' -Alias 'befc'
	Remove-AliasFromProfile -Script 'Build-EntityFrameworkContext' -Alias 'mcbef'
	Remove-AliasFromProfile -Script 'Build-SharedLibrary' -Alias 'bsl'
	Remove-AliasFromProfile -Script 'Build-SharedLibrary' -Alias 'mcbsl'
	Remove-AliasFromProfile -Script 'Edit-Script' -Alias 'es'
	Remove-AliasFromProfile -Script 'Edit-Script' -Alias 'mces'
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