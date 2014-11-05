<#
.Synopsis
   Cria um objeto PSCredential a partir de uma secure string armazenada em arquivo.
.DESCRIPTION
   Cria um objeto PSCredential a partir de uma secure string armazenada em arquivo.
.EXAMPLE
   Create-Credential -UserName Administrator -SecureStringPath .\secureString
#>
function Create-Credential
{
    [CmdletBinding()]
    [OutputType([System.Management.Automation.PSCredential])]
    Param
    (
        # Nome do usu�rio
        [Parameter(Mandatory=$true,
                   ValueFromPipelineByPropertyName=$true,
                   Position=0)]
        [String]
        $UserName,

        # Arquivo contendo a secure string
        [Parameter(Mandatory=$true,
                   ValueFromPipelineByPropertyName=$true,
                   Position=1)]
        [String]
        $SecureStringPath
    )

    Begin
    {
    }
    Process
    {
        if(! (Test-Path $SecureStringPath))
        {
            throw "Arquivo $SecureStringPath n�o existe."
        }
        
        $secureStringValue = cat $SecureStringPath | ConvertTo-SecureString
        return New-Object -TypeName System.Management.Automation.PSCredential -ArgumentList $UserName, $secureStringValue
    }
    End
    {
    }
}