Do {
import-module activedirectory

function Get-GroupHierarchy ($searchGroup)
{
$dcserver = Get-ADDomainController -Discover -Domain $domain
$groupName = $searchGroup
$groupMember = get-adgroupmember $searchGroup -Server $dcserver | sort-object objectClass -descending
   foreach ($member in $groupMember)
    {
    if ($member.ObjectClass -eq "group") {
        $groupName = $member.name
        Get-GroupHierarchy $member.name
        $groupName = $searchGroup
        }
          Else {
          [pscustomobject]@{
              "SAMAccountName" = $member.SAMAccountName
              "User Name" = $member.name
              "Object Class" = $member.objectclass
              "Group Name" = $groupName;
           }
          }
    }
}

$domain = Read-Host -Prompt 'Enter the name of the domain you want group members from'
$searchGrp = Read-Host -Prompt 'Enter the name of the AD group you want the users from'
$outputpath = "C:\Users\$env:UserName\Downloads\ADGroupMembers-$domain-$searchGrp-$([DateTime]::Now.ToString("yyyyMMdd-HHmmss")).csv"
$msg = "Getting all group members for $searchGrp from the $domain domain."
Write-Output $msg
Get-GroupHierarchy ($searchGrp) | Export-Csv $outputpath
Write-Output "Results written to: $outputpath"
$response = read-host "Would you like to search for another group (Y/N)?"
}
while ($response -like "Y*")
