Param(
[string]$PathXml = $(throw "Parâmetro -PathXml deve ser informado"),
[string]$PathOutPut = $(throw "Parâmetro -PathOutPut deve ser informado")
)

if(!(Test-Path $PathXml))
{
	throw "Arquivo Não Existe"
}

if(!$PathXml.EndsWith(".config"))
{
	throw "Arquivo não tem extensão .config."
}


$xml = [xml] (get-content $PathXml)
$services = $xml.SelectNodes("/configuration/system.serviceModel/services/service")

foreach($service in $services)
{
		"<%@ ServiceHost Service=`"" + $service.name.ToString() + "`" %>" > ("$PathOutPut\" + $service.name.ToString() + ".svc")
}

