Do{
import-module activedirectory
Write-Output "This script will run against all domains in the ADS forest"
$allDomains = (Get-ADForest).Domains | %{ Get-ADDomainController -Discover -Domain $_ }
$user = Read-Host -Prompt 'Enter the username or last name of the individual you want account details for'
$allDomains | % { 
$domain = $_.Domain
Write-Output "Checking for user in $domain domain"
If (Get-ADUser -Server $_ -Filter ("SamAccountName -like '*$user*' -or Surname -like '*$user*' -or Name -like '*$user*'") ) {
     Get-ADUser -Server $_ -Filter ("SamAccountName -like '*$user*' -or Surname -like '*$user*' -or Name -like '*$user*'") -Properties * | Select Name,GivenName,Surname,SamAccountName,Enabled,Company,Title,Manager,ObjectClass,ObjectGUID,SID,UserPrincipalName,DistinguishedName }
     Else { Write-Output "User NOT found in $domain domain" }
}
$response = read-host "Would you like to search for another user (Y/N)?"
}
while ($response -like "Y*")