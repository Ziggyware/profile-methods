Microsoft.PowerShell_profile.ps1
```ps1
function clippatch-cli{
    c:\dev\apply\target\release\clippatch.exe $args    
}
SetAlias clippatch clippatch-cli

function lsx-cli {
    c:\dev\lsx-cli\target\release\lsx.exe $args    
}
Set-Alias lsx lsx-cli

function bash-cli {
    & "C:\Program Files\Git\bin\bash.exe" $args
}
Set-Alias bash bash-cli


function termed {
    c:\dev\term-ed\target\release\termed.exe $args
}

function view-doc {
    deno run --allow-env --allow-read --allow-net --allow-sys --allow-run "C:\dev\docview\color_type.ts" $args
}
Set-Alias view view-doc

function omnictl {
    C:\dev\omnictl\target\release\omnictl.exe $args
}
Set-Alias omcli omnictl

function clipout-cli {
    C:\users\ziggy\source\repos\clipout-cli\target\release\clipout.exe $args
}
Set-Alias clipout clipout-cli

function clipin-cli {
    C:\users\ziggy\source\repos\clipin-cli\target\release\clipin.exe $args
}
Set-Alias clipin clipin-cli

function query-cli {
    deno run --allow-env --allow-read --allow-net --allow-sys --allow-run "C:\users\ziggy\source\repos\query-cli\dist\index.js" $args

}
Set-Alias query query-cli

function clipzip {
     C:\dev\clipzip\target\release\clipzip.exe $args
}

function clipunzip {
     C:\dev\clipzip\target\release\clipunzip.exe $args
}

# Return all files Git considers visible (tracked + untracked, excluding ignored)
function Get-GitFiles {
    $root = (Get-Location).Path
    git ls-files --cached --others --exclude-standard |
        ForEach-Object {
            $full = Join-Path $root $_
            if (Test-Path $full) { Resolve-Path $full }
        }
}

# Load ignore patterns from .gitignore
function Get-GitIgnorePatterns {
    param([string]$Path = ".gitignore")
    if (Test-Path $Path) {
        Get-Content $Path | Where-Object {
            $_ -and ($_ -notmatch '^\s*#') # skip comments/empty
        }
    } else {
        @()
    }
}

# Check if a path matches any ignore pattern
function Test-GitIgnored {
    param(
        [string]$File,
        [string[]]$Patterns
    )
    foreach ($pat in $Patterns) {
        # Convert .gitignore style to PowerShell wildcard
        $wild = $pat -replace '\*','*' -replace '\?','?'
        if ($File -like $wild) { return $true }
    }
    return $false
}



function ls-r {
<#
.SYNOPSIS
Recursive ls (like Bash ls **/*), respecting .gitignore.
#>
    param([string]$Pattern = "*")
    $files = Get-GitFiles
    if ($Pattern -ne "*") { $files = $files | Where-Object { $_ -like $Pattern } }
    $files | ForEach-Object { Get-Item $_ }
}
Set-Alias lsr ls-r


function ls-h {
<#
.SYNOPSIS
Show hidden files only, respecting .gitignore.
#>
    $files = Get-GitFiles
    $files | ForEach-Object { Get-Item $_ } | Where-Object { $_.Attributes -match 'Hidden' }
}
Set-Alias lsh ls-h

function ls-d {
<#
.SYNOPSIS
Directories only, respecting .gitignore.
#>
    $files = Get-GitFiles
    $files | ForEach-Object { Get-Item $_ } | Where-Object { $_.PSIsContainer }
}
Set-Alias lsd ls-d

function ls-ext {
<#
.SYNOPSIS
Filter by extension, respecting .gitignore.
#>
    param([Parameter(Mandatory=$true)][string]$Ext)
    $files = Get-GitFiles | Where-Object { $_ -like "*.$Ext" }
    $files | ForEach-Object { Get-Item $_ }
}
Set-Alias lse ls-ext

function find-name {
<#
.SYNOPSIS
Find by name anywhere, respecting .gitignore.
#>
    param([Parameter(Mandatory=$true)][string]$Name)
    $files = Get-GitFiles | Where-Object { $_ -like "*$Name*" }
    $files | ForEach-Object { Get-Item $_ }
}
Set-Alias fn find-name

function find-content {
<#
.SYNOPSIS
Search inside files (grep -R), respecting .gitignore.
#>
    param([Parameter(Mandatory=$true)][string]$Text)
    $files = Get-GitFiles
    Select-String -Path $files -Pattern $Text
}
Set-Alias fcont find-content   # safer alias than fc


# Master help aggregator
function ls-help {
    Write-Host "=== LS Utility Suite ===`n"
    $cmds = 'ls-r','ls-h','ls-d','ls-ext','find-name','find-content'
    foreach ($c in $cmds) {
        $synopsis = (Get-Help $c).Synopsis
        Write-Host ("{0,-12} : {1}" -f $c, $synopsis)
    }
    Write-Host "`nUse Get-Help <function> -Detailed for full docs."
}

Set-Alias lshelp ls-help
```