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