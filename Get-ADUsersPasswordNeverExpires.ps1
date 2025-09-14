Do{
import-module activedirectory
$output = Read-Host -Prompt 'Output to screen or to file (s or f)?'
$domain = Read-Host -Prompt 'What domain do you want users from?'
$dcserver = Get-ADDomainController -Discover -Domain $domain
$outputpath = "C:\Users\$env:UserName\Downloads\ADUserPasswordNeverExpires-$domain-$([DateTime]::Now.ToString("yyyyMMdd-HHmmss")).csv"
If ($output -like "s*") {
    get-aduser -server $dcserver -filter * -properties Name, Company, Title, PasswordNeverExpires, employeeType | where { $_.passwordNeverExpires -eq "true" -and $_.employeeType -ne $null } | where {$_.enabled -eq "true"} | Format-Table -AutoSize Name,Title,Company,PasswordNeverExpires,employeeType
    }
    else {
        get-aduser -server $dcserver -filter * -properties Name, Company, Title, PasswordNeverExpires, employeeType | where { $_.passwordNeverExpires -eq "true" -and $_.employeeType -ne $null } | where {$_.enabled -eq "true"} | Select Name,Title,Company,PasswordNeverExpires,employeeType | Export-Csv $outputpath
        Write-Output "Results written to: $outputpath"
        }
$response = read-host "Would you like to search another domain (Y/N)?"
}
while ($response -like "Y*")
