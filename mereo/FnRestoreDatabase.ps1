function RestoreDatabase ($dbName, $bkpFile)
{
	$script = "sqlcmd -S lan-dev-mereo -U desenvolvimento -P mereo.001 -v dbN=" + $dbName + " -v bkpFileName=" + $bkpFile + " -i .\restoreDatabase.sql"
& $script	
}