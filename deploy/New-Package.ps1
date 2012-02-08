#require MODULE Pscx
param
(
	[String]
	$Path = $(throw "-Path é obrigatório."),
	[String]
	$Output = $(throw "-Output é obrigatório."),
	[Int32]
	$Level = 1
)

if(-not $Output.EndsWith(".zip"))
{
	$Output += ".zip"
}


if($Path -eq $Output)
{
	write "Parâmetros -Path e -Output não podem ser iguais."
	return
}

write-zip $Path -OutPutPath $Output -Level $Level