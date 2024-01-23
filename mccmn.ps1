# ---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
$localConfigFile = join-path $PSScriptRoot "mcconf.ps1"
if(Test-Path $localConfigFile) 
{
	. $localConfigFile
} else 
{
    Write-Error "Could not find required file $localConfigFile."
	exit 1
}

$rootCommonFile = join-path $codeScriptsRootDir "cmn.ps1"
if(Test-Path $rootCommonFile) 
{
	. $rootCommonFile
} else 
{
    Write-Error "Could not find required file $rootCommonFile."
	exit 1
}
# ---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
function IsValid-Directory($path) {
	return (Test-Path -Path "$path\*.csproj" -PathType leaf) -or (Test-Path -Path "$path\*.sln" -PathType leaf)
}

function IsValid-SolutionDirectory($path) {
	return (Test-Path -Path "$path\*.sln" -PathType leaf)
}

function IsValid-ProjectDirectory($path) {
	return (Test-Path -Path "$path\*.csproj" -PathType leaf)
}

function IsValid-TestDirectory($path) {
	return (Test-Path -Path "$path\*Test*.csproj" -PathType leaf)
}

function IsValid-ScriptDirectory($path) {
	return ((Test-Path -Path "$path\version.txt" -PathType leaf) -and (Test-Path -Path "$path\*.ps1" -PathType leaf))
}
# ---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
Verify-Path $codeRootDir
# ---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------