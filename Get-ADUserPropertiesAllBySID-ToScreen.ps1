Do{
import-module activedirectory
$domain = Read-Host -Prompt 'What domain is the user in?'
$dcserver = Get-ADDomainController -Discover -Domain $domain
$userSID = Read-Host -Prompt 'Enter the SID of the individual you want account details for'
Get-ADUser -Identity $userSID -Server $dcserver -Properties *
$response = read-host "Would you like to search for another user by SID (Y/N)?"
}
while ($response -like "Y*")
