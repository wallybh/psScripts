Param(
$WebProject = $(throw "Parâmetro -WebProject deve ser informado"),
$TargetFolder = $(throw "Parâmetro -TargetFolder deve ser informado.")
)
Test-Path $WebProject

if(-not(Test-Path $TargetFolder))
{
	ni $TargetFolder -Type directory
}
if(-not(Test-Path $WebProject))
{
	throw "-WebProject não existe"
}


#& msbuild /t:Build`;ResolveReferences`;Publish /p:DeployOnBuild=true`;DeployTarget=PipelinePreDeployCopyAllFilesToOneFolder`;Configuration=Debug`;_PackageTempDir=$TargetFolder`;WebProjectOutputDir=$TargetFolder`;outdir=$TargetFolder\bin $WebProject
#& msbuild /t:Build /p:DeployOnBuild=true`;DeployTarget=MsDeployPublish`;_MSDeployDestinationWebServerDirectory=C:\testesvc`;CreatePackageOnPublish=True`;Configuration=Debug`;_PackageTempDir=$TargetFolder`;AutoParameterizationWebConfigConnectionStrings=false $WebProject


#quase lá
& msbuild /t:Build /p:DeployOnBuild=true`;DeployTarget=_CopyWebApplication`;Configuration=Debug`;_PackageTempDir=$TargetFolder`;WebProjectOutputDir=$TargetFolder`;outdir=$TargetFolder\bin $WebProject



#/p:DeployTarget=MsDeployPublish /p:CreatePackageOnPublish=True /p:MSDeployPublishMethod=InProc 

#& msbuild /t:Build`;PipelinePreDeployCopyAllFilesToOneFolder /p:Configuration=Debug`;_PackageTempDir=$TargetFolder $WebProject
#& msbuild /t:Build`;OnlyFilesToRunTheApp /p:Configuration=Debug`;OutputPath="$TargetFolder" $WebProject
#Start-Process "msbuild" -ArgumentList "/t:Build;PipelinePreDeployCopyAllFilesToOneFolder /p:Configuration=Debug;_PackageTempDir=$TargetFolder $WebProject" -NoNewWindow