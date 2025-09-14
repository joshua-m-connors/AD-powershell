Do{
$output = Read-Host -Prompt 'Output to screen or to file (s or f)?'
$domain = Read-Host -Prompt 'What domain do you want recently disabled accounts from?'
$No = Read-Host -Prompt 'How many days back would you like to look?'
$Since = (Get-Date).AddDays(-$No)
$outputpath = "C:\Users\$env:UserName\Downloads\"
$fileName = "ADUserDisabledInLastNumberOfDays-$domain-$No"+"Days-$([DateTime]::Now.ToString("yyyyMMdd-HHmmss")).csv"
$DomainController = Get-ADDomainController -Discover -Domain $domain
$PotentialTargets = Get-ADUser -Server $DomainController -Filter {Enabled -eq $false -and whenChanged -ge $Since} -Properties *
$DisabledWithin7Days = $PotentialTargets | Where-Object -FilterScript {(Get-ADReplicationAttributeMetadata -Server $DomainController -Object $PSItem -Properties userAccountControl).LastOriginatingChangeTime -ge $Since} 
$DisabledWithin7DaysUAC = $DisabledWithin7Days | Select samAccountName,Name,Title,Company,employeeType,@{Name='UAC_LastModified';Expression={(Get-ADReplicationAttributeMetadata -Server $DomainController -Object $PSItem -Properties userAccountControl).LastOriginatingChangeTime}},@{Name='UAC_Value';Expression={(Get-ADReplicationAttributeMetadata -Server $DomainController -Object $PSItem -Properties userAccountControl).AttributeValue}}
If ($output -like "s*") {
    $DisabledWithin7DaysUAC | Format-Table samAccountName,Name,Title,Company,employeeType,UAC_LastModified,UAC_Value
    }
    else {
        $DisabledWithin7DaysUAC | Export-Csv $outputpath$fileName
        Write-Output "Results written to: $outputpath$fileName"
        }
$response = read-host "Would you like to search for another group (Y/N)?"
}
while ($response -like "Y*")
