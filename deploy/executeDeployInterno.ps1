#!/bin/bash

if($args.Length -eq 0)
{
	"Faltam argumentos"
	write-host
	return
}

if(! (Test-Path $args[0]))
{
	Write-Output "Caminho de origem não existe."
	return
}

if(! (Test-Path $args[1]))
{
	Write-Output "Caminho de destino não existe."
	return
}
	
Get-ChildItem $args[1] -recurse -exclude *.config | Remove-Item -recurse -Confirm

$from = $args[0] + "\*"

Copy-Item $from $args[1] -exclude *.config -recurse




