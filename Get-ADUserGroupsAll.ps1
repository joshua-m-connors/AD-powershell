Do{
function Get-NestedGroupMember
{
param
(
[Parameter(Mandatory,ValueFromPipeline)]
[string]
$Identity
)

process
{
$user = Get-ADUser -Server $dcserver -Identity $Identity
$userdn = $user.DistinguishedName
$strFilter = "(member:1.2.840.113556.1.4.1941:=$userdn)"
Get-ADGroup  -Server $dcserver -LDAPFilter $strFilter -ResultPageSize 1000
}
}
$output = Read-Host -Prompt 'Output to screen or to file (s or f)?'
$domain = Read-Host -Prompt 'What domain is the user in?'
$dcserver = Get-ADDomainController -Discover -Domain $domain
$usr = Read-Host -Prompt 'Enter the username of the individual you want group membership details for'
$outputpath = "C:\Users\$env:UserName\Downloads\ADUserAllGroups-$domain-$usr-$([DateTime]::Now.ToString("yyyyMMdd-HHmmss")).txt"
$result = Get-NestedGroupMember -Identity $usr | Select-Object -Property Name, GroupCategory
If ($output -like "s*") {
    $result | Format-Table -AutoSize Name, GroupCategory
    }
    else {
        $result | Out-File -filepath $outputpath
        Write-Output "Results written to: $outputpath"
        }
$response = read-host "Would you like to search for another user (Y/N)?"
}
while ($response -like "Y*")
