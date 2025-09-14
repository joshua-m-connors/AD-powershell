Import-Module ActiveDirectory
Do{
$outputloc = Read-Host -Prompt 'Output to screen or to file (s or f)?'
$userFile = Read-Host -Prompt 'Enter the name of the text file containing a list of usernames (one username per line) saved in your local Documents folder'
$filepath = "C:\Users\$env:UserName\Documents\"
$outputpath = "C:\Users\$env:UserName\Downloads\"
$fileName = "ADUserPropertiesFromTextList-$domain-$([DateTime]::Now.ToString("yyyyMMdd-HHmmss")).csv"
$data = Get-Content $filepath$userFile
If ($outputloc -like "s*") {
    $output = foreach ($user in $data){
        $upn = $user
        $check = $(try {get-aduser -filter "samaccountname -eq '$upn'"} catch {$null})
        if ($check -ne $null) { get-aduser -filter "samaccountname -eq '$upn'" -Properties samaccountname,Name,Company,Enabled,Title,Department,LastLogonDate,Manager `
            | Select samaccountname,Name,Company,Enabled,Title,Department,LastLogonDate,@{Name='Manager';Expression={(Get-ADUser $_.Manager).Name}},@{Name='ManagerTitle';Expression={(Get-ADUser -Properties * -Identity $_.Manager).Title}}
        }
        else { "$upn Doesn't Exist" }
    } 
    $output | Format-Table -AutoSize samaccountname,Name,Company,Enabled,Title,Department,LastLogonDate,Manager,ManagerTitle
}
else {
    $output = foreach ($user in $data){
        $upn = $user
        $check = $(try {get-aduser -filter "samaccountname -eq '$upn'"} catch {$null})
        if ($check -ne $null) { get-aduser -filter "samaccountname -eq '$upn'" -Properties samaccountname,Name,Company,Enabled,Title,Department,LastLogonDate,Manager `
            | Select samaccountname,Name,Company,Enabled,Title,Department,LastLogonDate,Manager
        }
    }
    $output | Export-Csv $outputpath$fileName
    Write-Output "Results written to: $outputpath$fileName"
}
$response = read-host "Would you like to search for another list of users (Y/N)?"
}
while ($response -like "Y*")
