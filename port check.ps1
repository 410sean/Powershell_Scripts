#53            TCP UDP Domain Name System (DNS) 
#88            TCP UDP Kerberos—authentication system 
#123               UDP Network Time Protocol (NTP)—used for time synchronization
#135           TCP UDP DCE endpoint resolution (domain controllers-to-domain controller and client to domain controller operations)
#139           TCP UDP NetBIOS NetBIOS Session Service 
#389           TCP UDP Lightweight Directory Access Protocol (LDAP) 
#445           TCP     Microsoft-DS Active Directory, Windows shares & Microsoft-DS SMB file sharing
#464           TCP UDP Kerberos Change/Set password 
#636           TCP UDP Lightweight Directory Access Protocol over TLS/SSL (LDAPS)
#1025-5000     TCP     RPC low port range for server under windows 2008 or client under windows vista
#3268          TCP UDP msft-gc, Microsoft Global Catalog (LDAP service which contains data from Active Directory forests)
#3269          TCP UDP msft-gc-ssl, Microsoft Global Catalog over SSL (similar to port 3268, LDAP over SSL) 
#3389          TCP UDP Microsoft Terminal Server (RDP) officially registered as Windows Based Terminal (WBT) 
#47001         TCP     WinRM - Windows Remote Management Service
#49152-65535   TCP     RPC high port range required for server 2008 server or windows vista client or higher

$ports=53,88,135,139,389,445,464,636,3268,3269,3389,47001,49153
$servers=$null

$ErrorActionPreference="silentlycontinue"
function get-portstatus([string]$ip,[int]$port)
{
    $t = New-Object Net.Sockets.TcpClient $ip, $port
    catch [exception]
    {
    }
    if($t.Connected)
    {
        write-host ($ip + ":" + $port + " is operational") -NoNewline
    }
    else
    {
        write-warning ("can't access Port " + $ip + ":" + $port)
    }
 }
foreach($server in $servers)
{
    foreach($port in $ports)
    {
        get-portstatus -ip $server -port $port
    }
}