param
(
	[String]
	$path,
	[String]
	$server
)

tf workspaces /server:$server

tf get $path  /recursive