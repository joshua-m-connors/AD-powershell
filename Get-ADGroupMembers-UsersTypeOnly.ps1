Do{
import-module activedirectory
$output = Read-Host -Prompt 'Output to screen or to file (s or f)?'
$domain = Read-Host -Prompt 'Enter the name of the domain you want the group members from'
$searchGroup = Read-Host -Prompt 'Enter the name of the AD group you want the users from'
$msg = "Getting all group members (of type 'user') for $searchGroup from the $domain domain."
Write-Output $msg
$outputpath = "C:\Users\$env:UserName\Downloads\"
$fileName = "ADGroupMembers-UserType-$domain-$searchGroup-$([DateTime]::Now.ToString("yyyyMMdd-HHmmss")).csv"
$dcserver = Get-ADDomainController -Discover -Domain $domain
If ($output -like "s*") {
    Get-AdGroupMember -Recursive -Identity $searchGroup -Server $dcserver | where {$_.objectclass -eq 'user'} | % {
	    get-aduser $_ -Properties samAccountName,Name,SurName,GivenName,Title,Company,Department,Manager | select samAccountName,Name,SurName,GivenName,Title,Company,Department,@{Name='Manager';Expression={(Get-ADUser $_.Manager).Name}},@{Name='ManagerTitle';Expression={(Get-ADUser -Properties * -Identity $_.Manager).Title}}
    } | Format-Table -AutoSize samAccountName,Name,SurName,GivenName,Title,Company,Department,Manager,ManagerTitle
    }
    else {
    Get-AdGroupMember -Recursive -Identity $searchGroup -Server $dcserver | where {$_.objectclass -eq 'user'} | % {
	get-aduser $_ -Properties samAccountName,Name,SurName,GivenName,Title,Company,Department,Manager | select samAccountName,Name,SurName,GivenName,Title,Company,Department,@{Name='Manager';Expression={(Get-ADUser $_.Manager).Name}},@{Name='ManagerTitle';Expression={(Get-ADUser -Properties * -Identity $_.Manager).Title}}
    } | Export-Csv $outputpath$fileName
    Write-Output "Results written to: $outputpath$fileName"
    }
$response = read-host "Would you like to search for another group (Y/N)?"
}
while ($response -like "Y*")
