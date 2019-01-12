write-host "Welcome to the Maple Leaf Foods Office 365 User Migration Script." -ForegroundColor "Red" -BackgroundColor "Black"
write-host ""
write-host "This script will migrate a list of users to Exchange Online." -ForegroundColor "Yellow"
write-host ""
$FILEREADY = read-host "Have you created a migration-users.csv file? (Y/N)"
$USERMIGRATION = read-host "Is this a user migration? (Y/N)"

if ($FILEREADY.ToUpper() -eq "Y") {
    
    $global:USERLIST = Import-csv .\migration-users.csv
    $global:USERCOUNT = @($global:USERLIST).count

    $USERLISTCONFIRM = Read-Host "You are about to migrate $USERCOUNT user(s), do you want to proceed? (Y/N)"

    if ($USERLISTCONFIRM.ToUpper() -eq "Y") {
        write-host "Migration Starting..."
        write-host ""
        write-host "Adding Routing Addresses..."
        write-host ""
        .\02-add-OnMicrosoftAddress.ps1
        if ($USERMIGRATION.ToUpper() -eq "Y") {
            write-host "Licensing users for Exchange Online..."
            write-host ""
            .\03-New-License.ps1 -file .\migration-users.csv
            }
        else {
            write-host "No licensing required."
            }
        write-host ""
        .\04-Move-Mailbox.ps1
        write-host ""
        write-host "Migration Successfully Submitted." -BackgroundColor "Black" -Foregroundcolor "Yellow"
        write-host ""
        write-host "When a move is ready to complete, it will stop at 95% with a status of AutoSuspended."
    }

    else {
        write-host "User migration cancelled."
    }
}
else {
    write-host ""
    write-host "In order for this script to migrate users, a file named migration-users.csv must be populated with a list of UPNs, and the first field must be called 'name'.  This file must be located in the main script directory for all of the subsequent steps to use."
}