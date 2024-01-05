# Some elements taken from: https://github.com/ChrisTitusTech/powershell-profile/blob/main/Microsoft.PowerShell_profile.ps1

# Using Oh-my-posh and Terminal-Icons to make shell pretty

if ($Env:WT_SESSION) {
    oh-my-posh --init --shell pwsh --config 'C:\Users\fourm\Documents\PowerShell\antonharris.omp.json' | Invoke-Expression
    Import-Module -Name Terminal-Icons
} elseif ($Env:MOBAEXTRACTONTHEFLY) {
    # Maybe another Oh-my-posh file? The colours really not good with WT file in MobaXTerm
    Import-Module -Name Terminal-Icons
# } else {
#     # Just an ordinary PowerShell session
#     # Something else, maybe nothing ??
}

# Useful shortcuts for traversing directories
function cd... { Set-Location ..\.. }
function cd.... { Set-Location ..\..\.. }

# Compute file hashes - useful for checking successful downloads
function md5 { Get-FileHash -Algorithm MD5 $args }
function sha1 { Get-FileHash -Algorithm SHA1 $args }
function sha256 { Get-FileHash -Algorithm SHA256 $args }

# Quick shortcut to start notepad++
function npp { & 'C:\Program Files\Notepad++\notepad++.exe' $args }

# Useful functions
# Does the the rough equivalent of dir /s /b. For example, dirs *.png is dir /s /b *.png
function dirs {
    if ($args.Count -gt 0) {
        Get-ChildItem -Recurse -Include "$args" | Foreach-Object FullName
    } else {
        Get-ChildItem -Recurse | Foreach-Object FullName
    }
}

function find-file($name) {
    Get-ChildItem -recurse -filter "*${name}*" -ErrorAction SilentlyContinue | ForEach-Object {
        $place_path = $_.directory
        Write-Output "${place_path}\${_}"
    }
}

function grep($regex, $dir) {
    if ( $dir ) {
        Get-ChildItem $dir | select-string $regex
        return
    }
    $input | select-string $regex
}

function sed($file, $find, $replace) {
    (Get-Content $file).replace("$find", $replace) | Set-Content $file
}

function pgrep($name) {
    Get-Process $name
}

function pkill($name) {
    Get-Process $name -ErrorAction SilentlyContinue | Stop-Process
}

# terraform and git functions
# function tffmt {
#     terraform fmt -recursive
# }

function gcom {
    # tffmt
    git add .
    git commit -m "$args"
}

function gcomp {
    # tffmt
    $curr_branch = git branch --show-current
    git add .
    git commit -m "$args"
    git push origin $curr_branch
    Remove-Variable curr_branch
}
