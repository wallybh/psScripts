Param(
[string]$PathXml = $(throw "Par�metro -PathXml deve ser informado"),
[string]$PathOutPut = $(throw "Par�metro -PathOutPut deve ser informado")
)

if(!(Test-Path $PathXml))
{
	throw "Arquivo N�o Existe"
}

if(!$PathXml.EndsWith(".config"))
{
	throw "Arquivo n�o tem extens�o .config."
}


$xml = [xml] (get-content $PathXml)
$services = $xml.SelectNodes("/configuration/system.serviceModel/services/service")

foreach($service in $services)
{
		"<%@ ServiceHost Service=`"" + $service.name.ToString() + "`" %>" > ("$PathOutPut\" + $service.name.ToString() + ".svc")
}

