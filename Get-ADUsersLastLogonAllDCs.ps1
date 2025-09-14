Do{
import-module activedirectory
$output = Read-Host -Prompt 'Output to screen or to file (s or f)?'
$domain = Read-Host -Prompt 'What domain is the user in?'
$aduser = Read-Host -Prompt 'Enter the username of the individual you want last logon details for'
$dcservers = (Get-ADDomain -Identity $domain).ReplicaDirectoryServers
$msg = "Checking all domain controllers. This may take a couple minutes."
Write-Output $msg
$outputpath = "C:\Users\$env:UserName\Downloads\ADUserLastLogonAllDCs-$domain-$aduser-$([DateTime]::Now.ToString("yyyyMMdd-HHmmss")).txt"
If ($output -like "s*") {
    $LastLogons = foreach ($DC in $dcservers){ $user = get-aduser $aduser -properties lastlogon -server $dc | select name,lastlogon ; echo "$DC - $(w32tm /ntte $user.lastlogon)" }
    Write-Output $LastLogons
    }
    else {
        $LastLogons = foreach ($DC in $dcservers){ $user = get-aduser $aduser -properties lastlogon -server $dc | select name,lastlogon ; echo "$DC - $(w32tm /ntte $user.lastlogon)" }
        $LastLogons  | Out-File -filepath $outputpath
        Write-Output "Results written to: $outputpath"
        }
$response = read-host "Would you like to search for another user (Y/N)?"
}
while ($response -like "Y*")
