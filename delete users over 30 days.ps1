Stop-Transcript
Start-Transcript -path C:\scripts\deltusers.log -Append
get-date
$90Days = (get-date).adddays(-30)
#Get-ADUser -SearchScope OneLevel -SearchBase "ou=disabled users,dc=contoso,dc=com" -filter {(lastlogondate -notlike "*" -OR lastlogondate -le $90days) -AND (passwordlastset -le $90days) -AND (enabled -eq $false)} -Properties lastlogondate, passwordlastset | Select-Object name, lastlogondate, passwordlastset 
Get-ADUser -SearchScope OneLevel -SearchBase "ou=disabled users,dc=contoso,dc=com" -filter {(lastlogondate -notlike "*" -OR lastlogondate -le $90days) -AND (passwordlastset -le $90days) -AND (enabled -eq $false)} -Properties lastlogondate, passwordlastset | foreach-object {"deleting " + $_ ;Remove-ADObject $_ -confirm:$false}
get-date
Stop-Transcript