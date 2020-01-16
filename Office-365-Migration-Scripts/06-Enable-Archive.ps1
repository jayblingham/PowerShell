$UserToEnable = ($global:USERLIST).name

foreach ($user in $UserToEnable) {
    get-remotemailbox $user | enable-remotemailbox -archive
}