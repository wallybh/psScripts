 $total = 0
 
 ls ..\Desktop\word\media | ForEach-Object {if($_ -match "[0-9]{1,3}") { "Nome: $_ Numero: " + $matches[0]; $novoNome = "image" + ("{0:D8}" -f $matches[0]) + ".png";  $novoNome;  $total += 1}}
 
  #Rename-Item $_
 $total