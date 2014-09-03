function downloadFile ($url,$targetPath)
{
	$psw = "mereo!813"

	if($url)
	{
		$link = $url
	}
	else
	{
		$link = "https://mereoconsulting.mereogr.com.br/temp/x.rar"
	}
	
	if($targetPath)
	{
		$tp = $targetPath
	}
	else
	{
		$tp = "C:\BKP"
	}
	
&	aria2c -c --max-connection-per-server=10 --min-split-size=1M -s 10 -j 10 "${link}"

	$fileName = $link.Substring($link.LastIndexOf("/")+1)

	if(Test-Path $fileName)
	{
&		unrar x $fileName -p"${psw}"
		Move-Item *.bak $tp -Force
	}
}