[CmdLetBinding()]
Param (
    [Parameter()]
    [string]$BuildDir
)

[string]$scriptPath = $PSScriptRoot;

# set the location history 
Push-Location;

# make sure the releases folder exists
if ($null -eq $BuildDir -or $BuildDir.Length -eq 0)
{
    $BuildDir = Join-Path -Path $scriptPath -ChildPath 'Build';
}
if (-not(Test-Path -Path $BuildDir))
{
    New-Item -Path $BuildDir -ItemType Directory -Force | Out-Null;
}

# Get the packages to build in this repo
$packageFiles = Get-ChildItem -Path $scriptPath -Recurse -Filter 'package.json'

if ($packageFiles.Count -eq 0)
{
    Write-Error -Message 'No Extensions found to package'
    Exit
}

# set our working location to the build folder
Set-Location -Path $BuildDir;

# process each package found
foreach ($package in $packageFiles)
{
    Write-Verbose -Message "Processing $($package.fullname)";

    # try
    # {
        Set-Location -Path $package.DirectoryName;
        vsce.cmd package;
        Get-ChildItem -Path $package.DirectoryName -Filter '*.vsix' | Move-Item -Destination $BuildDir -Force;
    # }
    # catch 
    # {
        
    # }

    Write-Verbose -Message ('Finished processing package {0}' -f $packageJson.name);

}

# return to the previous user location
Pop-Location;

Write-Verbose -Message 'Extension Packaging Complete';