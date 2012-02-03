 Param($sistema = $(throw "Parâmetro $($sistema) deve ser informado"),
	$From,
	$To
 )
		If (-not ($From -eq $null)  -and ("DEPLOY","HML","DSV" -NotContains $From)) 
        { 
            Throw "`$From is not a valid param! Please use DEPLOY, HML, DSV" 
        } 
        If (-not ($To -eq $null)  -and ("DEPLOY","HML","DSV" -NotContains $To)) 
        { 
            Throw "`$To is not a valid param! Please use DEPLOY, HML, DSV" 
        } 
        If (-not ($To -eq $null) -and (-not ($From -eq $null)) -and $From -eq $To )
		{
			Throw "Parametros `$From e `$To não pode ser iguais" 
		}
 
 ./LoadConfig app.config
 
 $appServiceKeyFrom = "";
 $appServiceKeyTo = "";
 
 if($From -eq $null -or $To -eq $null)
 {
	 $appServiceKeyFrom = $sistema + "-SERVICE-DEPLOY";
	 $appServiceKeyTo = $sistema + "-SERVICE-HML";
 }
 
if($appSettings[$appServiceKeyTO] -eq $null -or  $appSettings[$appServiceKeyFrom] -eq $null)
{
	Write-Output "Configuração $appServiceKeyTo $appServiceKeyFrom não encontrada ";
}

# ./executeDeployInterno $appServiceKeyFrom $appServiceKeyTo
	