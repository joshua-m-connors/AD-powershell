Do{
import-module activedirectory
$output = Read-Host -Prompt 'Output to screen or to file (s or f)?'
$domain = Read-Host -Prompt 'Enter the name of the domain you want the group members from'
$searchGroup = Read-Host -Prompt 'Enter the name of the AD group you want the users from'
$msg = "Getting all group members for $searchGroup from the $domain domain."
$outputpath = "C:\Users\$env:UserName\Downloads\"
$fileName = "ADGroupMembers-AllMembers-$domain-$searchGroup-$([DateTime]::Now.ToString("yyyyMMdd-HHmmss")).csv"
Write-Output $msg
$dcserver = Get-ADDomainController -Discover -Domain $domain
If ($output -like "s*") {
    Get-AdGroupMember -Recursive -Identity $searchGroup -Server $dcserver | Format-Table -AutoSize samAccountName,Name,ObjectClass
    }
    else {
    Get-AdGroupMember -Recursive -Identity $searchGroup -Server $dcserver | select samAccountName,Name,ObjectClass | Export-Csv $outputpath$fileName
    Write-Output "Results written to: $outputpath$fileName"
    }
$response = read-host "Would you like to search for another group (Y/N)?"
}
while ($response -like "Y*")
