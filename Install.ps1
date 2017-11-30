Param (
    # skip the prompt and just install/upgrade any packages
    [switch]$Force
    ,
    # in the case that the same version is already installed, still overwrite it. Useful in Development environments.
    [switch]$OverwriteExisting
)

[string]$scriptPath = $PSScriptRoot;

# set the SQL Operations Studio Extensions path
$sqlopsExtDir = '~\.sqlops\extensions';

# set the array of any exlusions when copying to the installation path
$excludeFromCopy = @('*.md')

$packageFiles = Get-ChildItem -Path $scriptPath -Recurse -Filter 'package.json'

if ($packageFiles.Count -eq 0)
{
    Write-Error -Message 'No SQL Operations Studio packages found to install'
    Exit
}

# process each package found
foreach ($package in $packageFiles)
{
    Write-Verbose -Message "Processing $($package.fullname)";

    # get the folder name
    $packageFolderName = Split-Path -Path $package.DirectoryName -Leaf;
    $packageJson = (Get-Content $package.FullName) | ConvertFrom-Json;

    # check if we need to upgrade a preinstalled package
    [bool]$performUpgrade = $false;
    [string]$existingPackageFile = Join-Path -Path (Join-Path -Path $sqlopsExtDir -ChildPath $packageJson.name) -ChildPath 'package.json';
    if (Test-Path -Path $existingPackageFile -PathType Leaf)
    {
        Write-Verbose -Message 'Existing package found, getting details'
        [pscustomobject]$existingPackageJson = (Get-Content $existingPackageFile) | ConvertFrom-Json;
        $performUpgrade = $true;
    }
    else {
        [pscustomobject]$existingPackageJson = $null;
    }
        

    [bool]$proceed = $false;
    
    # in the event that we will proceed without prompt
    $proceed = $Force

    # check if we need to prompt for authority
    if (!($Force))
    {
        [string]$message = $null;
        if ($performUpgrade)
        {
            # check if we actually need to do anything
            if ($existingPackageJson.version -ne $packageJson.version)
            {
                [string]$message = 'Do you want to upgrade {0} from version {2} to version {1}? (Y/N)' -f $packageJson.name, $packageJson.version, $existingPackageJson.version;
            }
            else {
                # because we are doing an upgrade use the OverWriteExisting switch to determine if we proceed
                $proceed = $OverwriteExisting;
            }
        }
        else {
            [string]$message = 'Do you want to install {0} of version {1}? (Y/N)' -f $packageJson.name, $packageJson.version;
        }
        
        if ($null -ne $message -and $message.Length -gt 0 -and ((Read-Host -Prompt $message) -eq 'y'))
        {
            $proceed = $true
        }
    }

    # if we are allowed then proceed with install
    if ($proceed)
    {
        $packageDest = Join-Path -Path $sqlopsExtDir -ChildPath $packageJson.name;

        # are we upgrading
        if ($performUpgrade)
        {
            if ($existingPackageJson.version -ne $packageJson.version)
            {
                Write-Verbose -Message ('Upgrading package {0}' -f $packageJson.name);
                # to keep the install clean and in case we rename files remove the existing and copy new
                Remove-Item -Path $packageDest -Force -Recurse;
                Copy-Item -Path $package.DirectoryName -Destination $sqlopsExtDir -Container -Recurse -Exclude $excludeFromCopy;
            }
            elseif ($OverwriteExisting) {
                # the user chose to overwrite the existing 
                Write-Verbose -Message ('Overwriting existing package {0}' -f $packageJson.name);
                # to keep the install clean and in case we rename files remove the existing and copy new
                Remove-Item -Path $packageDest -Force -Recurse;
                Copy-Item -Path $package.DirectoryName -Destination $sqlopsExtDir -Container -Recurse -Exclude $excludeFromCopy;
            }
            else {
                Write-Verbose -Message ('Nothing to do for existing package {0}' -f $packageJson.name);
            }
        }
        else {
            # fresh install
            Write-Verbose -Message ('Installing package {0}' -f $packageJson.name);
            Copy-Item -Path $package.DirectoryName -Destination $sqlopsExtDir -Container -Recurse -Exclude $excludeFromCopy;
        }
    }
    else {
        Write-Verbose -Message ('Package {0} already installed, use -OverwriteExisting to upgrade anyway' -f $packageJson.name);
    }

    Write-Verbose -Message ('Finished processing package {0}' -f $packageJson.name);

}

Write-Verbose -Message 'Install/Upgrade Complete';