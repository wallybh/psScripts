param($path)

if($path -eq $null)
{
    $path = "D:\Downloads"
}

$arquivos = Get-ChildItem $path | sort LastWriteTime

$objectCount = 0;
$totalArquivos = $arquivos.Length
$hoje = Get-Date


foreach ($arquivo in $arquivos)
{
    if($arquivo.LastAccessTime -le ($hoje.AddDays(-3)))
    {
        "{0:dd/MM/yyyy}" -f  $arquivo.LastWriteTime
        $objectCount++
    }
}
Write-Host "Total arquivos $totalArquivos"
Write-Host "Total Arquivos Antigos $objectCount"
