Clear-Host
# ------------------------------------------------------------------------------------------------

'START'

$ou_array = 'OU=Domain Controllers,DC=severotorg,DC=local',
            'OU=Office,OU=Srv,DC=severotorg,DC=local',
            'OU=Shop,OU=Srv,DC=severotorg,DC=local'        

$srv_count = 0

$servise_name = 'Zabbix Agent'
$new_conf = $PSScriptRoot+'\zabbix_agentd.win.conf'

foreach ($array_item in $ou_array)
{
    $pc_list = Get-ADComputer -Filter * -SearchBase $array_item
    
    foreach ($item in $pc_list)
    {
        $srv_count +=1

        $pc_status = Test-Connection -computername $item.Name -quiet

        if ($pc_status -eq $True) 
        {
            $servise = Get-Service -computername $item.Name | Where-Object {$_.Name -like $servise_name}

            if ($servise.Name -ne '')
            {
                $srv_count.ToString() +' '+ $item.Name
                $copy_to = '\\'+$item.Name+'\c$\Zabbix Agent\conf\'
                Copy-Item "$new_conf" -Destination "$copy_to"
                Restart-Service $servise
                '------------------'
            }
        } 
    }
}

'END'
