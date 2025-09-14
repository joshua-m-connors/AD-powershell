Do{
import-module activedirectory
$output = Read-Host -Prompt 'Output to screen or to file (s or f)?'
$domain = Read-Host -Prompt 'What domain is the user in?'
$dcserver = Get-ADDomainController -Discover -Domain $domain
$user = Read-Host -Prompt 'Enter the username of the individual you want account details for'
$outputpath = "C:\Users\$env:UserName\Downloads\ADUserAllProperties-$domain-$user-$([DateTime]::Now.ToString("yyyyMMdd-HHmmss")).txt"
If ($output -like "s*") {
    Get-ADUser -Server $dcserver -Identity $user -Properties *
    }
    else {
        Get-ADUser -Server $dcserver -Identity $user -Properties *  | Out-File -filepath $outputpath
        Write-Output "Results written to: $outputpath"
        }
$response = read-host "Would you like to search for another user (Y/N)?"
}
while ($response -like "Y*")
