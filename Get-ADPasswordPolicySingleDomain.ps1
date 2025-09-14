Do{
import-module activedirectory
$output = Read-Host -Prompt 'Output to screen or to file (s or f)?'
$domain = Read-Host -Prompt 'Enter the name of the domain you want the password policy for'
$outputpath = "C:\Users\$env:UserName\Downloads\ADPasswordPolicySingleDomain-$domain-$([DateTime]::Now.ToString("yyyyMMdd-HHmmss")).txt"
If ($output -like "s*") {
    Get-ADDefaultDomainPasswordPolicy -Identity $domain
    }
    else {
        Get-ADDefaultDomainPasswordPolicy -Identity $domain  | Out-File -filepath $outputpath
        Write-Output "Results written to: $outputpath"
    }
$response = read-host "Would you like the password policy for another domain (Y/N)?"
}
while ($response -like "Y*")
