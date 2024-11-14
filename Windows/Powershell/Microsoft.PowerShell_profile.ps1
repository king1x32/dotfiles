# Set-ExecutionPolicy Unrestricted -- From Administrator Console

# Shell History Settings
#$MaximumHistoryCount = 2048
$Global:HistFile = "$HOME\.history.csv"
$truncateLogLines = 100

# Custom Variables
$FAPS = $Env:FAPS
$FAPSLP = $Env:FAPSLP
$FAPSCORP = $Env:FAPSCORP
$FAPSMP = $Env:FAPSMP
$FAPSDTA = $Env:FAPSDTA
$MINIO_HOME = "$HOME\minio"
$MINIO_ALIAS = "minio"

# Shell customization settings
$Shell = $Host.UI.RawUI


# Create the Scripts: drive
# http://stackoverflow.com/a/146945
#If ((Test-Path -Path "$HOME\scripts") -and (Test-Path -Path "$HOME\Projects")) {
#    $NULL = New-PSDrive -Name X -PSProvider FileSystem -Root "$HOME\scripts"
#    $NULL = New-PSDrive -Name P -PSProvider FileSystem -Root "$HOME\Projects"
#}

# Create edit Function, based on EDITOR variable
if ($Env:EDITOR -eq $NULL) {
    if ( Get-Command "code" -ErrorAction SilentlyContinue ) {
        function edit($file) {
            code $file
        }
    }
    else {
        function edit($file) {
            notepad $file
        }
    }
}
else {
    function edit($file) {
        Start-Process -FilePath $Env:EDITOR -ArgumentList $file
    }
}
Set-Alias -Name vi -Value edit

# Remove existing aliases from Shell
if ( Get-Command "ls.exe" -ErrorAction SilentlyContinue ) {
    Remove-Item alias:ls
    Function ll($path) {
        ls -l $path
    }
    Function l($path) {
        ls -la $path
    }
}
else {
    Function ls($path) {
        Get-ChildItem -name -force $path
    }
    Function ll($path) {
        Get-ChildItem -force $path
    }
}
# if ( Get-Command "wget.exe" -ErrorAction SilentlyContinue ) {
#     Remove-Item alias:wget
# }
# if ( Get-Command "curl.exe" -ErrorAction SilentlyContinue ) {
#     Remove-Item alias:curl
# }
if (!( Get-Command "grep.exe" -ErrorAction SilentlyContinue )) {
    Set-Alias -Name grep -Value Select-String
    Set-Alias -Name grepr -Value Select-StringRecurse
}
#Remove-Item alias:dir
#Function dir($path) { Get-ChildItem -name $path }

# inline functions, aliases and variables
# https://github.com/scottmuc/poshfiles
Function rmrf($item) {
    Remove-Item $item -Recurse -Force
}

Function touch($file) {
    "" | Out-File $file -Encoding ASCII
}

Function hc {
    Write-Output "$(Get-History).Count lines"
}

function dwn {
    Set-Location -Path ~\Downloads
}

function dev {
    if (Test-Path -Path ~\Development) {
        Set-Location -Path ~\Development
    }
    if (Test-Path -Path ~\Projects) {
        Set-Location -Path ~\Projects
    }
}

function home {
    Set-Location -Path ~\
}

Function Remove-AllPSSessions {
    Get-PSSession |
    Remove-PSSession
}

function lc {
    Get-ChildItem -File |
    Rename-Item -NewName { $_.FullName.ToLower() }
}

function rusc {
    Get-ChildItem -File |
    Rename-Item -NewName { $_.Name -replace ' ', '_' }
}

function rnn($number) {
    Get-ChildItem -File |
    Rename-Item -NewName { $_.BaseName + $number + $_.Extension }
}

function gitreset {
    git fetch --all;
    git reset --hard;
    git pull
}

Remove-Item -Path alias:gp -Force
function gp($dir) {
    Push-Location -Path $dir
    git pull
    Pop-Location
}

function Unblock-Dir($Path) {
    Get-ChildItem -Path '$Path' -Recurse |
    Unblock-File
}

function mc-sync {
    Sync-Minio -Target $MINIO_HOME -Alias $MINIO_ALIAS
}

function ytd($url) {
    youtube-dl.exe $url
}

function cping($Server) {
    ping -t $Server
}

function cping2($Server) {
    while (1) {
        Test-Connection -ComputerName $Server
    }
}

function ssh-copy-id($Server) {
    Get-Content $ENV:UserProfile\.ssh\id_ed25519.pub | `
        ssh $Server "mkdir ~/.ssh; cat >> ~/.ssh/authorized_keys"
}

function cfb {
    nvim "C:\Users\King1x32\Documents\PowerShell\Microsoft.PowerShell_profile.ps1"
}

function cfv {
    nvim "C:\Users\King1x32\AppData\Local\nvim\lua"
}

function cdd {
    cd "C:\Users\King1x32\Documents\PowerShell"
}

function mkcd($name) {
    mkdir $name | cd $name
}

Function which ($command) {
    Get-Command -Name $command -ErrorAction SilentlyContinue I
    Select-Object -ExpandProperty Path -ErrorAction SilentlyContinue
}

Function whereis($name) {
    Get-Command $name |
    Select-Object Definition
}

function gcl($Https) {
    git clone $Https
}

function gr($1, $2) {
    git remote add "$1" "$2"
    git fetch --all
    git merge "$1"/main
}

function gm() {
    git add -A
    git commit -m "update"
    git push
}

function ga() {
    git add -A
    git commit --amend --no-edit
    git push --force
}

function grs($number) {
    git reset --hard HEAD~`$${number}
    git push --force
}

function vf() {
    rg --files --hidden | fzf --preview="bat {}" --bind="ctrl-space:toggle-preview" --preview-window=:hidden
}

function aa($Https2) {
    aria2c -x 16 -s 16 -j 16 -k 10M $Https2
}

function Get-ChildItemPretty {
    <#
    .SYNOPSIS
        Runs eza with a specific set of arguments. Plus some line breaks before and after the output.
        Alias: ls, ll, la, l
    #>
    [CmdletBinding()]
    param (
        [Parameter(Mandatory = $false, Position = 0)]
        [string]$Path = $PWD
    )

    Write-Host ""
    eza -Glao --header --icons --hyperlink --time-style relative $Path
    Write-Host ""
}

function Get-ChildItemPretty2 {
    <#
    .SYNOPSIS
        Runs eza with a specific set of arguments. Plus some line breaks before and after the output.
        Alias: ls, ll, la, l
    #>
    [CmdletBinding()]
    param (
        [Parameter(Mandatory = $false, Position = 0)]
        [string]$Path = $PWD
    )

    Write-Host ""
    eza -GlaoTL 2 --header --icons --hyperlink --time-style relative $Path
    Write-Host ""
}

function Update-Software {
    <#
    .SYNOPSIS
        Updates all software installed via Winget & Chocolatey. Alias: us
    #>
    Write-Verbose "Updating software installed via Winget & Chocolatey"
    sudo cache on
    sudo winget upgrade --all --include-unknown --silent --verbose
    sudo choco upgrade all -y
    sudo npm i -g npm
    sudo npm update -g
    sudo -k
    $ENV:SOFTWARE_UPDATE_AVAILABLE = ""
}

function Find-File {
    <#
    .SYNOPSIS
        Finds a file in the current directory and all subdirectories. Alias: ff
    #>
    [CmdletBinding()]
    param (
        [Parameter(ValueFromPipeline, Mandatory = $true, Position = 0)]
        [string]$SearchTerm
    )

    Write-Verbose "Searching for '$SearchTerm' in current directory and subdirectories"
    $result = Get-ChildItem -Recurse -Filter "*$SearchTerm*" -ErrorAction SilentlyContinue

    Write-Verbose "Outputting results to table"
    $result | Format-Table -AutoSize
}

function Find-String {
    <#
    .SYNOPSIS
        Searches for a string in a file or directory. Alias: grep
    #>
    [CmdletBinding()]
    param (
        [Parameter(Mandatory = $true, Position = 0)]
        [string]$SearchTerm,
        [Parameter(ValueFromPipeline, Mandatory = $false, Position = 1)]
        [string]$Directory,
        [Parameter(Mandatory = $false)]
        [switch]$Recurse
    )

    Write-Verbose "Searching for '$SearchTerm' in '$Directory'"
    if ($Directory) {
        if ($Recurse) {
            Write-Verbose "Searching for '$SearchTerm' in '$Directory' and subdirectories"
            Get-ChildItem -Recurse $Directory | Select-String $SearchTerm
            return
        }

        Write-Verbose "Searching for '$SearchTerm' in '$Directory'"
        Get-ChildItem $Directory | Select-String $SearchTerm
        return
    }

    if ($Recurse) {
        Write-Verbose "Searching for '$SearchTerm' in current directory and subdirectories"
        Get-ChildItem -Recurse | Select-String $SearchTerm
        return
    }

    Write-Verbose "Searching for '$SearchTerm' in current directory"
    Get-ChildItem | Select-String $SearchTerm
}

function New-File {
    <#
    .SYNOPSIS
        Creates a new file with the specified name and extension. Alias: touch
    #>
    [CmdletBinding()]
    param (
        [Parameter(Mandatory = $true, Position = 0)]
        [string]$Name
    )

    Write-Verbose "Creating new file '$Name'"
    New-Item -ItemType File -Name $Name -Path $PWD | Out-Null
}

function Remove-ItemExtended {
    <#
    .SYNOPSIS
        Removes an item and (optionally) all its children. Alias: rm
    #>
    [CmdletBinding()]
    param (
        [Parameter(Mandatory = $false)]
        [switch]$rf,
        [Parameter(Mandatory = $true, Position = 0)]
        [string]$Path
    )

    Write-Verbose "Removing item '$Path' $($rf ? 'and all its children' : '')"
    Remove-Item $Path -Recurse:$rf -Force:$rf
}

Set-Alias -Name ff -Value Find-File
Set-Alias -Name grep -Value Find-String
Set-Alias -Name rm -Value Remove-ItemExtended
Set-Alias -Name touch -Value New-File
Set-Alias -Name us -Value Update-Soft
# Alias definitions
Set-Alias -Name hh -Value Get-History
Set-Alias -Name kpss -Value Remove-AllPSSessions
# Set-Alias l ls
Set-Alias l Get-ChildItemPretty
Set-Alias ll Get-ChildItemPretty2
Set-Alias tt tree
Set-Alias g git
Set-Alias gg lazygit
Set-Alias v nvim
Set-Alias vv nvim
Set-Alias f fzf

# Chocolatey profile
$ChocolateyProfile = "$env:ChocolateyInstall\helpers\chocolateyProfile.psm1"
if (Test-Path($ChocolateyProfile)) {
    Import-Module "$ChocolateyProfile"
}

If ( Get-Command -Name "oh-my-posh.exe" ) {
    oh-my-posh init pwsh --config "$env:POSH_THEMES_PATH/clean-detailed.omp.json" | Invoke-Expression
}

#Terminal Icons
Import-Module Terminal-Icons

#PSReadLine
Import-Module PSReadLine
Set-PSReadLineKeyHandler -Key Tab -Function Complete
Set-PSReadLineOption -PredictionSource History
Set-PSReadLineOption -PredictionViewStyle ListView
