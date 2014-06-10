$searcher = new-object System.DirectoryServices.DirectorySearcher
$searcher.filter=”(&(ObjectClass=computer)(Name=$env:computername))”
$find = $searcher.FindOne()
$thispc = $find.GetDirectoryEntry()

$searcher.filter=”(&(ObjectClass=user)(samAccountName=$env:username))”
$find = $searcher.FindOne()
$me = $find.GetDirectoryEntry()

$thispc.InvokeSet(“ManagedBy”,$($me.DistinguishedName))
$thispc.SetInfo()