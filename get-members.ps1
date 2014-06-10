<#
.synopsis
script will output to screen and csv file in the same path as script the members of this group and the attributes requested

.description
if using the -attributes switch it will only take a array of strings (1 or many) of attributes. 
prerequisite includes AD module for powershell and powershell 2.

.example
.\get-members.ps1 identity

.example
.\get-members.ps1 -groupname identity

.example
$customattributes="givenname","sn","mail","employeeid"
.\get-members.ps1 identity -attributes $customattributes

#>
[cmdletbinding()]
param(
    [parameter(mandatory=$true,position=1)]
    [string]$groupname,

    [parameter(mandatory=$false)]
    [string[]]$attributes=("sn","GivenName","mail")
)
$filepath = split-path -parent $MyInvocation.MyCommand.Definition
if ($filename.Substring($filename.Length-1) -eq "\")
{
    $filename = $filepath + $groupname + ".csv"
}
else
{
    $filename = $filepath + "\" + $groupname + ".csv"
}
$members=$null
$members = Get-ADGroupMember $groupname -Recursive
$admembers=@()
$params=@{'properties'=$attributes}
foreach ($member in $members)
{
    $admembers += get-aduser $member -Properties $attributes
}
if ($admembers -ne $null)
{
    [string]$message=($admembers | ft -Property $attributes -AutoSize)
    Write-Verbose $message
    $admembers | select-object $attributes | Export-Csv -Delimiter "," -NoTypeInformation -Path $filename
    $message="file " + $filename + " Created."
    Write-Verbose $message
    Wait-Event -Timeout 30
}


#old query
#$members = Get-ADGroupMember $groupname -Recursive | % {
#	$group=$_
#	get-aduser $_ -Properties GivenName,surname,mail | select @{n="Group";e={$group}},GivenName,surname,mail 
#}

#function Load_Module
#{
#    param (
#        [parameter(Mandatory = $true)][string] $name
#    )
#
#    $retVal = $true
#
#    if (!(Get-Module -Name $name))
#    {
#        $retVal = Get-Module -ListAvailable | where { $_.Name -eq $name }
#
#        if ($retVal)
#        {
#            try
#            {
#                Import-Module $name -ErrorAction SilentlyContinue
#            }
#
#            catch
#            {
#                $retVal = $false
#            }
#        }
#    }
#
#    return $retVal
#}
#
#$moduleName = "ActiveDirectory"
#
#try 
#{
#    if (load_module $moduleName)
#    {
#        Write-Host "Loaded $moduleName"
#    }
#    else
#    {
#        Write-Host "Failed to load $moduleName"
#    }
#}
#catch 
#{
#    Write-Host "Exception caught: $_" 
#}