Param(
$WebProject = (throw "Parãmetro -WebProject deve ser informado"),
$TargetFolder = (throw "Parâmetro -TargetFolder deve ser informado.")
)
Test-Path $WebProject
Test-Path $TargetFolder
if(-not(Test-Path $WebProject) -or -not(Test-Path $TargetFolder) )
{
	throw "-WebProject ou -TargetFolder não existe"
}

"msbuild /t:Build;PipelinePreDeployCopyAllFilesToOneFolder /p:Configuration=Debug;_PackageTempDir=$TargetFolder $WebProject"
Invoke-Expression "msbuild /t:Build;PipelinePreDeployCopyAllFilesToOneFolder /p:Configuration=Debug;_PackageTempDir=$TargetFolder $WebProject"