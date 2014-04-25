Set-Location "C:\Users\wallison.santos\Documents\GitHub\psScripts"

Import-Module PowerTab

Import-Module Pscx

function Import-VS10Vars
{
    $vcargs = ?: {$Pscx:Is64BitProcess} {'amd64'} {'x86'}
    Push-EnvironmentBlock -Description "Before importing VS 2010 $vcargs vars"
    Invoke-BatchFile "${env:VS100COMNTOOLS}..\..\VC\vcvarsall.bat" $vcargs
}

Import-VS10Vars