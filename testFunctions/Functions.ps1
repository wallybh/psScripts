function F1([string]$Teste) 
{
	write-host $Teste;
}

function F2 ($a) {Write-Host -foregroundcolor yellow “Here it is: $a”;}


function F3 ([int]$a)
{
	$aux = $a * $a
	write-host $aux
}