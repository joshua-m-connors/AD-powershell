<########################################################################### 
    The purpose of this PowerShell script is to collect the last logon  
    for user accounts on each DC in the domain, evaluate, and return the 
    most recent logon value. 
 
        Author:      Jeremy Reeves
        Modified by: Josh Connors 
        Modified:    01/16/2019 
        Notes:       Must have RSAT Tools if running on a workstation 
 
###########################################################################> 

Do{
Import-Module ActiveDirectory 
#****If you only want details returned for one account replace * with a username**** 
function Get-ADUsersLastLogon() { 
    
    
    $domain = Read-Host -Prompt 'Enter the name of the domain you want all users last logon from'
    #****Enter the name of the user your wish to search for****
    $Username = Read-Host -Prompt 'Enter the username(s) you want last logons for (specific username or * (for all users))'
    ################################################################################################################################

    $msg = "Checking all domain controllers. If you chose all (*) domain users this may take a while."
    Write-Output $msg
    #Defines the path to the directory where the files will be saved
    $FilePath_Prefix = "C:\Users\$env:UserName\Downloads\" 
 
    function Msg ($Txt="") { 
        Write-Host "$([DateTime]::Now)    $Txt" 
    } 
    
    #Cycle each DC and gather user account lastlogon attributes 
    $List = @() #Define Array 
    (Get-ADDomain -Identity $domain).ReplicaDirectoryServers | Sort | % { 
 
        $DC = $_ 
        Msg "Reading $DC" 
        $List += Get-ADUser -Server $_ -Filter "samaccountname -like '$Username'" -Properties Name,GivenName,Surname,samaccountname,Company,createTimeStamp,Description,Enabled,AccountExpirationDate,Manager,modifyTimeStamp,PasswordNeverExpires,PasswordNotRequired,lastlogonDate,lastLogonTimestamp,lastlogon,DC | Select Name,GivenName,Surname,samaccountname,Company,createTimeStamp,Description,Enabled,AccountExpirationDate,Manager,modifyTimeStamp,PasswordNeverExpires,PasswordNotRequired,lastlogonDate,lastLogonTimestamp,lastlogon,@{n='lastlogondatetime';e={[datetime]::FromFileTime($_.lastlogon)}},@{n='DC';e={$DC}} 
 
    }  
    
    if ($Username -eq "*") { $uname = "All" } else { $uname = $Username }
    $List | Export-CSV -Path "$FilePath_Prefix$domain-AllDomainUsersLastLogon-$uname-FullData-$([DateTime]::Now.ToString("yyyyMMdd-HHmmss")).csv" -NoTypeInformation -Force
 
    Msg "Sorting for most recent lastlogon" 
     
    $LatestLogOn = @() #Define Array 
    $List | Group-Object -Property samaccountname | % { 
 
        $LatestLogOn += ($_.Group | Sort -prop lastlogon -Descending)[0] 
 
    } 
    
    $LatestLogOn | ForEach-Object -Process {if ($_.lastLogonTimestamp -gt $_.lastLogon) {$_.lastLogon = $_.lastLogonTimestamp}}
         
    $List.Clear() 
 
    if ($Username -eq "*") { #$Username variable was not set. Running against all user accounts and exporting to a file. 
 
        $FileName = "$FilePath_Prefix$domain-AllDomainUsersLastLogon-All-$([DateTime]::Now.ToString("yyyyMMdd-HHmmss")).csv" 
         
        try { 
 
            $LatestLogOn | Select Name,GivenName,Surname,samaccountname,Company,createTimeStamp,Description,Enabled,AccountExpirationDate,Manager,modifyTimeStamp,PasswordNeverExpires,PasswordNotRequired,lastlogonDate,lastlogon,@{n='lastlogondatetime';e={[datetime]::FromFileTime($_.lastlogon)}},DC | Export-CSV -Path $FileName -NoTypeInformation -Force 
            Msg "Exported results. $FileName" 
 
        } catch { 
 
            Msg "Export Failed. $FileName" 
 
        } 
 
    } else { #$Username variable was set, and may refer to a single user account.
    
        $FileName = "$FilePath_Prefix$domain-AllDomainUsersLastLogon-$Username-$([DateTime]::Now.ToString("yyyyMMdd-HHmmss")).csv" 
 
        if ($LatestLogOn) { $LatestLogOn | Select Name,GivenName,Surname,samaccountname,lastlogonDate,lastlogon,@{n='lastlogondatetime';e={[datetime]::FromFileTime($_.lastlogon)}},DC | Export-CSV -Path $FileName -NoTypeInformation -Force  
        Msg "Exported results. $FileName"

        } else { Msg "$Username not found." } 
        
    } 
 
    $LatestLogon.Clear() 
}

Get-ADUsersLastLogon
$response = read-host "Would you like to get the users from another domain (Y/N)?"
}
while ($response -like "Y*")
