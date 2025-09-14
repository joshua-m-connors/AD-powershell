Do{
import-module activedirectory
$domain = Read-Host -Prompt 'What domain is the user in?'
$dcserver = Get-ADDomainController -Discover -Domain $domain
$user = Read-Host -Prompt 'Enter the username or last name of the individual you want basic account details for'
Get-ADUser -Server $dcserver -Filter ("SamAccountName -like '*$user*' -or Surname -like '*$user*' -or Name -like '*$user*'") -Properties * | Select Name,GivenName,Surname,SamAccountName,Enabled,Company,Title,Manager,ObjectClass,ObjectGUID,SID,UserPrincipalName,DistinguishedName
$response = read-host "Would you like to search for another user (Y/N)?"
}
while ($response -like "Y*")
