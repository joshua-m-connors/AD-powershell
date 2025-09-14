import-module activedirectory
$output = Read-Host -Prompt 'Output to screen or to file (s or f)?'
$outputpath = "C:\Users\$env:UserName\Downloads\ADPasswordPolicyAllDomains-$([DateTime]::Now.ToString("yyyyMMdd-HHmmss")).txt"
If ($output -like "s*") {
    (Get-ADForest -Current LoggedOnUser).Domains | %{ Get-ADDefaultDomainPasswordPolicy -Identity $_ }
    }
    else {
    (Get-ADForest -Current LoggedOnUser).Domains | %{ Get-ADDefaultDomainPasswordPolicy -Identity $_ } | Out-File -filepath $outputpath
    Write-Output "Results written to: $outputpath"
    }
Read-Host -Prompt "Press Enter to exit"