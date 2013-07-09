if(!$appSettings) 
{ 
	write-debug "carregando configura��es"
	.\LoadConfig .\app.config
}

if($args.Length -eq 0)
{
	"Faltam argumentos"
	write-host
	return
}

if(! (Test-Path $args[0]))
{
	Write-Output "Caminho de origem n�o existe."
	return
}

if(! (Test-Path $args[1]))
{
	Write-Output "Caminho de destino n�o existe."
	return
}

$ignore = $appSettings['DEFAULT-IGNORE']

Get-ChildItem $args[1] -recurse -exclude $ignore | Remove-Item -recurse

$from = $args[0] + "\*"

Copy-Item $from $args[1] -exclude $ignore -recurse




