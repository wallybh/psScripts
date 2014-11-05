function gs
{
	& git status
}

function grh
{
	Param 
	(
		#[ValidateScript({ return Test-Path $_ -PathType Container })]
		[String]
		$path
	)

	& git reset HEAD $path 
}

function gadd
{
	Param 
	(
		#caminho root do projeto mereogr.
		[String]
		$path = "D:\Repos\MereoGR"
	)

    $webConfigPath = Join-Path $path \Core\MereoGR.Web\Web.config

	& git add .
    grh (Resolve-Path -Path $webConfigPath -Relative)
}
