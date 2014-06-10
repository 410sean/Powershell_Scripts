<#
.SYNOPSIS
will return the number of provisions and deprovisions in AD by the week and also provide a breakdown by opco
.DESCRIPTION
does not require special rights to run
#>
$ErrorActionPreference = "Stop"
([System.Datetime] $date = $(get-date)) > $null
$lastsunday = -($date.DayOfWeek.value__)
$i=$lastsunday
$companycount=@{}
$companystats=@()
do
{
    $checktime = (get-date).adddays($i)
    $endofweek = (get-date).adddays($i+7)
    $users=Get-ADUser -Filter {whencreated -ge $checktime -and whencreated -le $endofweek} -Properties whencreated,extensionattribute3 -SearchBase "OU=User Accounts,OU=Users,OU=Accounts,DC=contoso,DC=com" | where {$_.Enabled -eq “True”} 
    "total active users created the week of " + $checktime.ToShortDateString() + " are " + $users.length
    $companycount=@{}
    foreach ($user in $users)
    {
        if ($user.extensionattribute3 -eq $null)
        {
            $user.extensionattribute3="blank"
        }
        if ($companycount -eq $null)
        {
            $companycount.add($user.extensionattribute3,1)
        }
        else
        {
            if ($companycount.contains($user.extensionattribute3))
            {
                $companycount.($user.extensionattribute3)=($companycount.($user.extensionattribute3) + 1)
            }
            else
            {
                $companycount.add($user.extensionattribute3,1)
            }
        }
    }
    foreach ($key in $companycount.GetEnumerator())
    {
        $companystat=New-Object System.Object
        $companystat | Add-Member -MemberType NoteProperty -Name company -Value $key.Name
        $companystat | Add-Member -MemberType NoteProperty -Name count -Value $key.Value
        $companystat | add-member -MemberType NoteProperty -Name date -Value $checktime.ToShortDateString()
        $companystats+=$companystat
    }
    $i=$i-7
}
while ($i -ge -31)

$companies = $companystats.company | Sort-Object | Get-Unique
$dates     = $companystats.date | Get-Unique
$companytable=@()
foreach ($companyid in $companies)
{
    $tablerow=new-object System.Object
    $tablerow | Add-Member -MemberType NoteProperty -Name companyid -Value $companyid
    foreach ($date in $dates)
    {
        $record=$companystats.Where{$_.company -eq $companyid -and $_.date -eq $date.ToShortDateString()}
        if ($record -ne $null)
        {
            $tablerow | Add-Member -MemberType NoteProperty -Name $date.ToShortDateString() -Value $record[0].count
        }
        else
        {
            $tablerow | Add-Member -MemberType NoteProperty -Name $date.ToShortDateString() -Value 0
        }
    }
    $companytable+=$tablerow
}



#$users=Get-ADUser -Filter {whencreated -le $checktime} -Properties whencreated -SearchBase "OU=User Accounts,OU=Users,OU=Accounts,DC=contoso,DC=com" | where {$_.Enabled -eq “True”} 
#"total active users created before the week of " + $checktime.ToShortDateString() + " are " + $users.length
<#
$i=$lastsunday
do
{
    $checktime = (get-date).adddays($i)
    $endofweek = (get-date).adddays($i+7)
    $users=Get-ADUser -Filter {whenchanged -ge $checktime -and whenchanged -le $endofweek} -Properties whenchanged -searchscope OneLevel -SearchBase "OU=Disabled Users,DC=contoso,DC=com" | where {$_.Enabled -ne “True”} 
    "users disabled the week of " + $checktime.ToShortDateString() + " is " + $users.Count
    $companycount=@{}
    foreach ($user in $users)
    {
        if ($user.extensionattribute3 -eq $null)
        {
            $user.extensionattribute3="blank"
        }
        if ($companycount -eq $null)
        {
            $companycount.add($user.extensionattribute3,1)
            $user.extensionattribute3
        }
        else
        {
            if ($companycount.contains($user.extensionattribute3))
            {
                $companycount.($user.extensionattribute3)=($companycount.($user.extensionattribute3) + 1)
            }
            else
            {
                $companycount.add($user.extensionattribute3,1)
            }
        }
    }
    $companycount    
    $i=$i-7
}
while ($i -ge -31)
#>
