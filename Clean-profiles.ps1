# Cleanup profiles. Run at server startup
# 20220114 Scott Knights
# Will clean any .BAK registry keys from the profile list, remove profiles then cleanup any leftover junk in c:\Users

# Remove any .BAK keys from the ProfileList registry key
$profkey="HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion\ProfileList"
$keys=get-childitem -path $profkey|where{$_.name -like "*.BAK"}
$keys|remove-item -force

# Get the domain primary SID
# Use this method to get the domain SID if the AD Posh module is available
#$domainsid=((get-addomain).domainsid).value

# Use this method to get the domain SID if the AD Posh module is not available
$domain = Get-WmiObject Win32_ComputerSystem | Select -Expand Domain
$krbtgtSID = (New-Object Security.Principal.NTAccount $domain\krbtgt).Translate([Security.Principal.SecurityIdentifier]).Value
$domainsid = $krbtgtSID.SubString(0, $krbtgtSID.LastIndexOf('-'))

# Get user profiles (only get domain users)
$profiles=Get-CimInstance -ClassName Win32_UserProfile -ComputerName localhost|where{$_.SID -like "$domainsid*"}

# Attempt to remove profiles
$profiles | Remove-CimInstance

# Delete any folders left in C:\Users that shouldn't be there
$folders=get-childitem C:\Users -directory -force|where{$_.Name -notlike "All Users" -and $_.Name -notlike "Default*" -and $_.Name -notlike "Public"}
$folders|remove-item -recurse -force
