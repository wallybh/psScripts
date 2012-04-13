param([int]$Hora = 18,[int]$Minuto = 00,[int]$Segundo = 00)

$now = Get-Date
$freeTime = new-object System.DateTime($now.Year,$now.Month,$now.Day,$Hora,$Minuto,$Segundo)
$et = ($freeTime - $now)
"Faltam: {0:00}:{1:00}:{2:00}" -f $et.Hours,$et.Minutes,$et.Seconds | write-output
