Do{
$output = Read-Host -Prompt 'Output to screen or to file (s or f)?'
$domain = Read-Host -Prompt 'What domain do you want recently disabled accounts from?'
$user = Read-Host -Prompt 'What is the username of the individual?'
import-module activedirectory
$outputpath = "C:\Users\$env:UserName\Downloads\ADUserDisabled-uacDate-$domain-$user-$([DateTime]::Now.ToString("yyyyMMdd-HHmmss")).txt"
$DomainController = Get-ADDomainController -Discover -Domain $domain
$Target = Get-ADUser -Server $DomainController -Identity $user
If ($output -like "s*") {
    Get-ADReplicationAttributeMetadata -Server $DomainController -Object $Target -Properties userAccountControl
    }
    else {
        Get-ADReplicationAttributeMetadata -Server $DomainController -Object $Target -Properties userAccountControl | Out-File -filepath $outputpath
        Write-Output "Results written to: $outputpath"
        }
$response = read-host "Would you like to search for another user (Y/N)?"
}
while ($response -like "Y*")
