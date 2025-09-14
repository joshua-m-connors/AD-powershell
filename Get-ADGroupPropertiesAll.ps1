Do{
import-module activedirectory
$output = Read-Host -Prompt 'Output to screen or to file (s or f)?'
$domain = Read-Host -Prompt 'What domain is the group in?'
$dcserver = Get-ADDomainController -Discover -Domain $domain
$group = Read-Host -Prompt 'Enter the name of the group you want details for'
$outputpath = "C:\Users\$env:UserName\Downloads\ADGroupAllProperties-$domain-$group-$([DateTime]::Now.ToString("yyyyMMdd-HHmmss")).txt"
If ($output -like "s*") {
    Get-ADGroup -Server $dcserver -Identity $group -Properties CanonicalName,CN,createTimeStamp,Deleted,Description,DisplayName,DistinguishedName,dSCorePropagationData,GroupCategory,GroupScope,groupType,HomePage,instanceType,isDeleted,LastKnownParent,ManagedBy,Modified,modifyTimeStamp,Name,nTSecurityDescriptor,ObjectCategory,ObjectClass,ObjectGUID,objectSid,ProtectedFromAccidentalDeletion,SamAccountName,sAMAccountType,sDRightsEffective,SID,SIDHistory,uSNChanged,uSNCreated,whenChanged,whenCreated
    }
    else {
        Get-ADGroup -Server $dcserver -Identity $group -Properties CanonicalName,CN,createTimeStamp,Deleted,Description,DisplayName,DistinguishedName,dSCorePropagationData,GroupCategory,GroupScope,groupType,HomePage,instanceType,isDeleted,LastKnownParent,ManagedBy,Modified,modifyTimeStamp,Name,nTSecurityDescriptor,ObjectCategory,ObjectClass,ObjectGUID,objectSid,ProtectedFromAccidentalDeletion,SamAccountName,sAMAccountType,sDRightsEffective,SID,SIDHistory,uSNChanged,uSNCreated,whenChanged,whenCreated | Out-File -filepath $outputpath
        Write-Output "Results written to: $outputpath"
        }
$response = read-host "Would you like to search for another group (Y/N)?"
}
while ($response -like "Y*")
