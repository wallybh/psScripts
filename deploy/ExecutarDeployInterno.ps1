Param([string]$Sistema = "")

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
$sistemaPathDeploy = "TEMPDEPLOYPATH"
$sistemaWebProj = $Sistema + "-WEBPROJ"

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

$pathWebProj = $appSettings[$sistemaWebProj]
$pathDeploy = $appSettings[$sistemaPathDeploy] + "$Sistema\"
$pathServerDSV = $appSettings[$sistemaAppDsv]
$pathServerHML = $appSettings[$sistemaAppHml]

if(Test-Path $pathDeploy)
{
	write-warning "Removendo arquivos do caminho de deploy"
	Remove-Item "$pathDeploy*" -Recurse
}

write-warning "Compilando aplica��o"
.\Invoke-MsBuildPublish $pathWebProj $pathDeploy

write-warning "Copiando Arquivos para o servidor de desenvolvimento"
.\copyFiles $pathDeploy $pathServerDSV

write-warning "Copiando Arquivos para o servidor de homologa��o"
.\copyFiles $pathDeploy $pathServerHML



