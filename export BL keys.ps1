$keys = Get-ADObject -LDAPFilter "(&objectcategory=CN=ms-FVE-RecoveryInformation,CN=Schema,CN=Configuration,DC=contoso,DC=com)"
#$keys | ft DistinguishedName -AutoSize #> out2.txt
$EncryptedComputers = @{}
foreach($key in $keys)
{
    $extractedcomp=$key.distinguishedname.substring($key.DistinguishedName.LastIndexOf("CN=")) #$key.DistinguishedName.TrimStart("CN=" + $key.Name).substring(4)
    #if ($extractedcomp.Contains(":00")){break}
    if ($EncryptedComputers.ContainsKey($extractedcomp))
    {
        $encryptedcomputers.set_item($extractedcomp,[int]($encryptedcomputers.get_item($extractedcomp) + 1))
        #echo "true"
    } 
    else
    {
        $encryptedcomputers.add($extractedcomp,[int](1))
        #echo "false"
    }
}
$EncryptedComputers.GetEnumerator()| Sort-Object Value -Descending |select-object -Property name, value  | Export-Csv -Delimiter (";") -NoTypeInformation -Path "c:\scripts\bitlocker Keys.csv"

#there is a known issue where the $keys.name does not match up with $keys.distingueshedname if the distingueshed name has a "\" which is important for line 6