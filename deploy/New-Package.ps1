
params
(
	[String]
	$Path = $(throw "Parametro -Path n�o pode ser nulo"),
	[String]
	$Output = $(throw "Parametro -Output n�o pode ser nulo"),
	[Int32]
	$Level = 1
)

write-zip $Path -OutPutPath $Output -Level $Level