
params
(
	[String]
	$Path = $(throw "Parametro -Path não pode ser nulo"),
	[String]
	$Output = $(throw "Parametro -Output não pode ser nulo"),
	[Int32]
	$Level = 1
)

write-zip $Path -OutPutPath $Output -Level $Level