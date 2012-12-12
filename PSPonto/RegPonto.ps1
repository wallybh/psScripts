function RegPonto ([string]$path = $(throw "You must specify a excel file"))
{
	if(!(Test-path $path))
	{
		Write-Error "Arquivo não existe."
		return
	}
	
	$xl=New-Object -ComObject "Excel.Application"
	
	#get-member -inputObject $wb
	#return
	$wb=$xl.Workbooks.Open($path)
	$ws=$wb.ActiveSheet
	
	$cells=$ws.Cells
	
	for ($row=3; $row -le 33; $row++)
	{
		$broke = $False
		
		$text = $cells.item($row,"A").Text
	
		if($text)
		{
			for ($col = 2; $col -le 5; $col++)
			{
				if(!$cells.item($row,$col).Text)
				{
					$cells.item($row,$col) = (Get-Date -format t)
			
					write-Host $cells.item($row,$col).Text
					
					if($col -eq 5)
					{
						$cells.item($row,6) = "=C$row-B$row+E$row-D$row"
					}
					
					$broke = $True
					break
				}
			}
			
			if($broke)
				{ break }
		}
		else
		{
			$cells.item($row,"A") = (Get-Date -format d)
			$cells.item($row,"B") = (Get-Date -format t)
			
			write-Host $cells.item($row,"B").Text
			break
		}
	}
	
	$wb.Save()
	$wb.Close()
	$xl.Quit()
}