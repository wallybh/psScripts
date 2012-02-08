#require MODULE Pscx
param
(
	[String]
	$Path = $(throw "-Path � obrigat�rio."),
	[String]
	$Output = $(throw "-Output � obrigat�rio."),
	[Int32]
	$Level = 1
)

if(-not $Output.EndsWith(".zip"))
{
	$Output += ".zip"
}


if($Path -eq $Output)
{
	write "Par�metros -Path e -Output n�o podem ser iguais."
	return
}

write-zip $Path -OutPutPath $Output -Level $Level