. .\LoadConfig

if(!$appSettings) 
{ 
	write-debug "carregando configura��es"
	LoadConfig .\app.config
}

write-debug "carregando comandos visual studio"
Invoke-BatchFile $appSettings['PATHVSCOMMANDLINE'] $appSettings['VAR1VSCOMMANDLINE'] 

$LASTEXITCODE = 0;

write-warning "Recuperando o source do TFS"
.\TFGetWorkSpace

if($LASTEXITCODE -ne 0)
{
	write-error "Ocorreu um erro ao recuperar os arquivos do TFS (TFGetWorkSpace.ps1)"
	return
}

