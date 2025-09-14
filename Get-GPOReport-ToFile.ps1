Do{
import-module activedirectory
$domain = Read-Host -Prompt 'Enter the fully qualified domain name of the internal domain you want the GPO report from'
$name = Read-Host -Prompt 'Enter the name of GPO you want a report for'
$type = Read-Host -Prompt 'Enter the type of report you want (HTML or XML)'
$outputpath = "C:\Users\$env:UserName\Downloads\GPOReport-$domain-$name-$([DateTime]::Now.ToString("yyyyMMdd-HHmmss")).$type"
Get-GPOReport -Name $name -Domain $domain -ReportType $type -Path $outputpath
Write-Output "Results written to: $outputpath"
$response = read-host "Would you like to search for another GPO (Y/N)?"
}
while ($response -like "Y*")
