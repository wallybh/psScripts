Param([string] $Sln = "-noSplash")
write-warning $Sln
Start-Process devenv -ArgumentList $Sln
