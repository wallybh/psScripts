#function Invoke-MsbuildPublishFN
#{
Param(
$WebProject = $(throw "Par�metro -WebProject deve ser informado"),
$TargetFolder = $(throw "Par�metro -TargetFolder deve ser informado.")
)
Test-Path $WebProject

if(-not(Test-Path $TargetFolder))
{
	ni $TargetFolder -Type directory
}
if(-not(Test-Path $WebProject))
{
	throw "-WebProject n�o existe"
}

#& msbuild /t:Build`;PipelinePreDeployCopyAllFilesToOneFolder /p:Configuration=Debug`;_PackageTempDir=$TargetFolder $WebProject
$teste = (Start-Process "msbuild" -ArgumentList "/t:Build;PipelinePreDeployCopyAllFilesToOneFolder /p:Configuration=Debug;_PackageTempDir=$TargetFolder $WebProject" -Wait -PassThru -WindowStyle Hidden -OutVariable buildResult)
write-warning "compilado"
get-member -inputobject $teste | write-host
#}