<############### Start of PowerTab Initialization Code ########################
    Added to profile by PowerTab setup for loading of custom tab expansion.
    Import other modules after this, they may contain PowerTab integration.
#>

#Import-Module "PowerTab" -ArgumentList "C:\Users\wallison.santos\Documents\WindowsPowerShell\PowerTabConfig.xml"

################ End of PowerTab Initialization Code ##########################
# Load posh-git example profile
. 'D:\Repos\PoshGit\profile.example.ps1'
. 'D:\Repos\HeatMap\profile.ps1'

#import modules
Import-Module Microsoft.PowerShell.Host

$SCRIPTPATH = "C:\Users\wallison.santos\Documents\@Work\psScripts"
$VIMPATH = "C:\Program Files (x86)\Vim\vim74\vim.exe"

Set-Location $SCRIPTPATH

#configurar vim

if(Test-path $VIMPATH)
{
    Set-Alias vi $VIMPATH
    Set-Alias vim $VIMPATH
}

if(Test-Path "C:\Program Files (x86)\Notepad++\notepad++.exe")
{
    Set-Alias np "C:\Program Files (x86)\Notepad++\notepad++.exe"
}

Import-Module Pscx

function Import-VS10Vars
{
    $vcargs = ?: {$Pscx:Is64BitProcess} {'amd64'} {'x86'}
    Push-EnvironmentBlock -Description "Before importing VS 2010 $vcargs vars"
    Invoke-BatchFile "${env:VS100COMNTOOLS}..\..\VC\vcvarsall.bat" $vcargs
}

Import-VS10Vars

##Import custom functions
$toImport = @("C:\Users\wallison.santos\Documents\@Work\psScripts\gitAlias\git-aliases.ps1",
"D:\Repos\Mereo_Utils\ps-utils\Download-File.ps1",
"C:\Users\wallison.santos\Documents\@Work\psScripts\Get-MD5.ps1",
"C:\Users\wallison.santos\Documents\@Work\psScripts\PSPonto\RegPonto.ps1",
"C:\Users\wallison.santos\Documents\@Work\psScripts\Create-Credential.ps1"

)

$toImport | ForEach {
	. $_
}

#ReposList
$reposRoot = new-object "System.Collections.Generic.Dictionary``2[[System.String, mscorlib, Version=2.0.0.0, Culture=neutral, PublicKeyToken=b77a5c561934e089],[System.String, mscorlib, Version=2.0.0.0, Culture=neutral, PublicKeyToken=b77a5c561934e089]]"

$reposRoot.Add("psscripts","C:\Users\wallison.santos\Documents\@Work\psScripts")
$reposRoot.Add("mereogr","D:\Repos\MereoGR")
$reposRoot.Add("mereoadn","D:\Repos\MereoADN")
$reposRoot.Add("imp","D:\Repos\Mereo_Utils\implantacao")

Function ChangeRepo
{
    param (
        [ValidateSet('psscripts','mereogr','mereoadn','imp')]
        $repoName
    )

	if($reposRoot[$repoName.ToLower()] -ne $null -and (Test-Path $reposRoot[$repoName.ToLower()]))
	{
		Set-Location $reposRoot[$repoName.ToLower()]
	}
}

Function PrepareEnvironment($clientName = "Magnesita", $ambiente = "local")
{
	if(test-path .\Core\MereoGR.Web\App_Data\MereoGRCache_empty.db)
	{
		write "Criando arquivo MereoGRCache.db"
		copy-item .\Core\MereoGR.Web\App_Data\MereoGRCache_empty.db .\Core\MereoGR.Web\App_Data\MereoGRCache.db
	}
	
	if(test-path .\Core\MereoGR.Web\Web.config)
	{
		write "Alterando BaseUploadPath"
		
		$xml = NEW-OBJECT XML
		$xml.Load((Resolve-path .\Core\MereoGR.Web\Web.config))
		
		if(!(test-path .\Core\MereoGR.Web\temp))
		{		
			ni .\Core\MereoGR.Web\temp -type directory
		}
			
		$baseUploadPath = (Resolve-path .\Core\MereoGR.Web\temp)
		
		$xml.configuration.appSettings.add | Where-Object { $_.key -eq 'BaseUploadPath'} | ForEach-Object { $_.Value = $baseUploadPath.ToString()}
		
		write "Alterando connection string para $clientName"
		
		$server = "lan-dev-mereo"
		$user = "desenvolvimento"
		$psw = "mereo.001"
		$userDW = "desenvolvimento"
		$pswDW = "mereo.001"
		
		if($ambiente -eq "teste")
		{
			write "Apontando connection string para $ambiente"
			$server = "199.217.117.163"
			$user = "kmjnhb"
			$psw = "#108.Ruei"
			$userDW = "user_ass"
			$pswDW = "!@@#@%vcQ**"
		}
		
		$coreConnection = "Data Source=$server;Initial Catalog=MereoGR-$clientName;User ID=$user;Password=$psw;Max Pool Size=100"
		$olapConnection = "Provider=SQLNCLI10.1;Data Source=http://$server/olap/msmdpump.dll;Persist Security Info=True;Initial Catalog=DW$clientName;User ID=$userDW;Password=$pswDW;"
		
		$xml.configuration.connectionStrings.add | Where-Object { $_.name -eq 'CoreConnection'} | ForEach-Object { $_.connectionString = $coreConnection.ToString()}
		
		$xml.configuration.connectionStrings.add | Where-Object { $_.name -eq 'OLAPConnection'} | ForEach-Object { $_.connectionString = $olapConnection.ToString()}
		
		$xml.save((Resolve-path .\Core\MereoGR.Web\Web.config))
	}
}

function downloadFile($url, $targetFile)
{ 
    "Downloading $url" 
    $uri = New-Object "System.Uri" "$url" 
    $request = [System.Net.HttpWebRequest]::Create($uri) 
    $request.set_Timeout(15000) #15 second timeout 
    $response = $request.GetResponse() 
    $totalLength = [System.Math]::Floor($response.get_ContentLength()/1024) 
    $responseStream = $response.GetResponseStream() 
    $targetStream = New-Object -TypeName System.IO.FileStream -ArgumentList $targetFile, Create 
    $buffer = new-object byte[] 10KB 
    $count = $responseStream.Read($buffer,0,$buffer.length) 
    $downloadedBytes = $count 
    while ($count -gt 0) 
    { 
        [System.Console]::CursorLeft = 0 
        [System.Console]::Write("Downloaded {0}K of {1}K", [System.Math]::Floor($downloadedBytes/1024), $totalLength) 
        $targetStream.Write($buffer, 0, $count) 
        $count = $responseStream.Read($buffer,0,$buffer.length) 
        $downloadedBytes = $downloadedBytes + $count 
    } 
    "`nFinished Download" 
    $targetStream.Flush()
    $targetStream.Close() 
    $targetStream.Dispose() 
    $responseStream.Dispose() 
}

function Find-Files
{
	param(
    [Parameter(Mandatory=$true,ValueFromPipelineByPropertyName=$true)]
    [string]$pattern
    )

	Get-ChildItem -recurse | Select-String -pattern "$pattern" | group path | select name
}


##remote session

#$rs1 =  New-PSSession -ComputerName 199.217.117.163 -Credential $cred -ConfigurationName WithProfile


$pathf = "C:\Users\wallison.santos\Google Drive\Projects\1 - MereoGR\2 - AcompanhamentoResultados\Permissoes de Criacao e Edicao de Acoes.xlsx"

