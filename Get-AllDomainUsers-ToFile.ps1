Do{
import-module activedirectory
$domain = Read-Host -Prompt 'Enter the name of the domain you want the full list of users for'
$msg = "Getting details of all users in the $domain domain. This may take a minute."
Write-Output $msg
$outputpath = "C:\Users\$env:UserName\Downloads\"
$fileName = "AllDomainUsers-$domain-$([DateTime]::Now.ToString("yyyyMMdd-HHmmss")).csv"
Get-ADUser -Filter * -Properties Samaccountname,Surname,GivenName,Enabled,LastLogonDate,DistinguishedName,employeeType,AccountExpirationDate `
   | select Samaccountname,Surname,GivenName,Enabled,LastLogonDate,DistinguishedName,employeeType,AccountExpirationDate `
   | Export-Csv $outputpath$fileName
Write-Output "Results written to: $outputpath$fileName"
$response = read-host "Would you like to get the users from another domain (Y/N)?"
}
while ($response -like "Y*")
