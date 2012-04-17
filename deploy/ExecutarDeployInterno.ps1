Param([string]$Sistema = "")

$LASTEXITCODE = 0;

if(!$appSettings) 
{ 
	write-debug "carregando configurações"
	.\LoadConfig .\app.config
}

write-warning "Recuperando o source do TFS"
.\TFGetWorkSpace

if($LASTEXITCODE -ne 0)
{
	write-error "Ocorreu um erro ao recuperar os arquivos do TFS (TFGetWorkSpace.ps1)"
}

#TODO aqui deve verificar se o sistema foi informado como parametro se sim ele verifica se o sistema está na propriedade ALIASESSISTEMAS 
#TODO se não ele deve fazer deploy de todos os sistemas dentro de ALIASESSISTEMAS
if($Sistema -eq "")
{
	$Sistema = $appSettings['ALIASESSISTEMAS']
}


$sistemaAppDsv = $Sistema + "-APP-DSV"
$sistemaAppHml = $Sistema + "-APP-HML"
$sistemaPathDeploy = "TEMPDEPLOYPATH"
$sistemaWebProj = $Sistema + "-WEBPROJ"

if(!$appSettings[$sistemaAppDsv])
{
	write-error "Não foram encontrados a configuração $sistemaAppDsv no app.config."
	return
}

if(!$appSettings[$sistemaAppHml])
{
	write-error "Não foram encontrados a configuração $sistemaAppHml no app.config."
	return
}

if(!$appSettings[$sistemaPathDeploy])
{
	write-error "Não foram encontrados a configuração $sistemaPathDeploy no app.config."
	return
}

if(!$appSettings[$sistemaWebProj])
{
	write-error "Não foram encontrados a configuração $sistemaWebProj no app.config."
	return
}

$pathWebProj = $appSettings[$sistemaWebProj]
$pathDeploy = $appSettings[$sistemaPathDeploy] + "$Sistema\"
$pathServerDSV = $appSettings[$sistemaAppDsv]
$pathServerHML = $appSettings[$sistemaAppHml]

if(Test-Path $pathDeploy)
{
	write-warning "Removendo arquivos do caminho de deploy"
	Remove-Item "$pathDeploy*" -Recurse
}

write-warning "Compilando aplicação"
.\Invoke-MsBuildPublish $pathWebProj $pathDeploy

write-warning "Copiando Arquivos para o servidor de desenvolvimento"
.\copyFiles $pathDeploy $pathServerDSV

write-warning "Copiando Arquivos para o servidor de homologação"
.\copyFiles $pathDeploy $pathServerHML



