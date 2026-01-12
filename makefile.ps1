param(
    [Parameter(Mandatory=$true)]
    [string]$Target
)

function Gen {
    flutter pub run build_runner build --delete-conflicting-outputs
}

function Hello {
    Write-Host "Hi!"
    Write-Host "I'm makefile"
    Write-Host "^_^"
}

function Icon {
    flutter pub run flutter_launcher_icons:main
}

function InitRes {
    dart pub global activate flutter_asset_generator
}

function Format {
    dart format . --line-length 100
}

$Fgen = "$env:LOCALAPPDATA\Pub\Cache\bin\fgen.bat"

function Res {
    & $Fgen --output lib/components/resources.g.dart --no-watch --no-preview
    Format
}

function Loc {
    flutter gen-l10n
    Format
}

switch ($Target) {
    "gen"      { Gen }
    "hello"    { Hello }
    "icon"     { Icon }
    "init_res" { InitRes }
    "format"   { Format }
    "res"      { Res }
    "loc"      { Loc }
    default {
        Write-Host "Unknown target: $Target"
        Write-Host "Available targets: gen, hello, icon, init_res, format, res, loc"
        exit 1
    }
}
