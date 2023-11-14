# ---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
$codeRootDir    	           = "D:\My Code\"												# absolute path of code root directory
$codeScriptsRootDir        	   = "$($codeRootDir)PowerShell Scripts\"						# absolute path of code scripts root directory
$codeScriptsDir           	   = "$($codeScriptsRootDir)mc\"								# absolute path of code scripts directory
# ---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
$log						   = $true														# enable logging
$logHost					   = $true														# enable logging for Write-DisplayHost (requires $log to be enabled)
$logDebug					   = $true														# enable logging for Write-DisplayDebug (requires $log to be enabled)
$logStatus					   = $true														# enable logging for Write-DisplayStatus (requires $log to be enabled)
$logError					   = $true														# enable logging for Display-Error (requires $log to be enabled)
$logWarning					   = $true														# enable logging for Write-DisplayWarning (requires $log to be enabled)
$logFile					   = "$($codeScriptsDir)mclog.txt"								# absolute path of log file
# ---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
$rootConfig					   = "$($codeScriptsRootDir)conf.ps1"							# absolute path of root config file
if(Test-Path $rootConfig)
{
	. $rootConfig
}
else
{
	Write-Error "Could not find required file $rootConfig."
	exit 1
}
# ---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
$svnCodeScriptsUrl			   = "$($svnCodeScriptsRootUrl)mc"								# SVN server code scripts URL
# ---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------