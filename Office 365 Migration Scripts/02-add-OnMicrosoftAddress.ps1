$MigrationUsers = $global:USERLIST
$RoutingDomain = your-org.mail.onmicrosoft.com
$i = 1

foreach ($user in $MigrationUsers) {
    $NewO365User = $user.name
    $UserInfo = get-mailbox $NewO365User | select DisplayName, alias
    $UserAlias = $UserInfo.Alias

    set-mailbox $NewO365User -EmailAddresses @{add="$UserAlias@$RoutingDomain"}
    write-progress -activity "Adding $RoutingDomain Addresses..." -status "Processing $user" -PercentComplete ($i / $global:USERCOUNT*100)
    $i++       
}
    


    