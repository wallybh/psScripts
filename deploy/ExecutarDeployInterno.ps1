Param([string]$Sistema = "")

function Get-ScriptDirectory
{
	$Invocation = (Get-Variable MyInvocation -Scope 1).Value
	Split-Path $Invocation.MyCommand.Path
}

$executionPath = get-ScriptDirectory

$LASTEXITCODE = 0;

if(!$appSettings) 
{ 
	write-debug "carregando configura��es"
	.\LoadConfig .\app.config
}

write-warning "Recuperando o source do TFS"
.\TFGetWorkSpace

if($LASTEXITCODE -ne 0)
{
	write-error "Ocorreu um erro ao recuperar os arquivos do TFS (TFGetWorkSpace.ps1)"
}

#TODO aqui deve verificar se o sistema foi informado como parametro se sim ele verifica se o sistema est� na propriedade ALIASESSISTEMAS 
#TODO se n�o ele deve fazer deploy de todos os sistemas dentro de ALIASESSISTEMAS
if($Sistema -eq "")
{
	$Sistema = $appSettings['ALIASESSISTEMAS']
}


$sistemaAppDsv = $Sistema + "-APP-DSV"
$sistemaAppHml = $Sistema + "-APP-HML"
$sistemaSvcDsv = $Sistema + "-SVC-DSV"
$sistemaSvcHml = $Sistema + "-SVC-HML"
$sistemaPathDeploy = "TEMPDEPLOYPATH"
$sistemaWebProj = $Sistema + "-WEBPROJ"
$sistemaServiceProj = $Sistema + "-SERVICEPROJ"

if(!$appSettings[$sistemaAppDsv])
{
	write-error "N�o foram encontrados a configura��o $sistemaAppDsv no app.config."
	return
}

if(!$appSettings[$sistemaAppHml])
{
	write-error "N�o foram encontrados a configura��o $sistemaAppHml no app.config."
	return
}

if(!$appSettings[$sistemaSvcDsv])
{
	write-error "N�o foram encontrados a configura��o $sistemaSvcDsv no app.config."
	return
}

if(!$appSettings[$sistemaSvcHml])
{
	write-error "N�o foram encontrados a configura��o $sistemaSvcHml no app.config."
	return
}

if(!$appSettings[$sistemaPathDeploy])
{
	write-error "N�o foram encontrados a configura��o $sistemaPathDeploy no app.config."
	return
}

if(!$appSettings[$sistemaWebProj])
{
	write-error "N�o foram encontrados a configura��o $sistemaWebProj no app.config."
	return
}

if(!$appSettings[$sistemaServiceProj])
{
	write-error "N�o foram encontrados a configura��o $sistemaServiceProj no app.config."
	return
}

$pathWebProj = $appSettings[$sistemaWebProj]
$pathServiceProj = $appSettings[$sistemaServiceProj]
$pathDeploy = $appSettings[$sistemaPathDeploy] + "$Sistema\"
$pathDeploySVC = $appSettings[$sistemaPathDeploy] + $Sistema +"SERVICE\"
$pathServerDSV = $appSettings[$sistemaAppDsv]
$pathServerHML = $appSettings[$sistemaAppHml]
$pathServerSvcDSV = $appSettings[$sistemaSvcDsv]
$pathServerSvcHML = $appSettings[$sistemaSvcHml]
$arquivoConfigServicos = [System.IO.Path]::GetDirectoryName($pathServiceProj);

if(! (Test-Path "$arquivoConfigServicos\App.config"))
{
	if(!(Test-Path "$arquivoConfigServicos\Web.config"))
	{
		write-error "N�o foi encontrado arquivo de configura��o."
		return
	}
	$arquivoConfigServicos = $arquivoConfigServicos + "\Web.config"
}
else
{
	$arquivoConfigServicos = $arquivoConfigServicos + "\App.config"
}

if(Test-Path $pathDeploy)
{
	write-warning "Removendo arquivos do caminho de deploy"
	Remove-Item "$pathDeploy*" -Recurse
}

if(Test-Path $pathDeploySVC)
{
	write-warning "Removendo arquivos do caminho de deploy"
	Remove-Item "$pathDeploySVC*" -Recurse
}

write-warning "Compilando aplica��o"
.\Invoke-MsBuildPublish $pathWebProj $pathDeploy

write-warning "Compilando servi�os"
.\Invoke-MsBuildPublishWcf $pathServiceProj $pathDeploySVC
.\CriarArquivosSVC $arquivoConfigServicos $pathDeploySVC

write-warning "Copiando Arquivos para o servidor de desenvolvimento"
.\copyFiles $pathDeploy $pathServerDSV
.\copyFiles $pathDeploySVC $pathServerSvcDSV


write-warning "Copiando Arquivos para o servidor de homologa��o"
.\copyFiles $pathDeploy $pathServerHML
.\copyFiles $pathDeploySVC $pathServerSvcHML


