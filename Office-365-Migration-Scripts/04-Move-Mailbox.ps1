$localcred = get-credential -message "Enter EXCHANGE ADMIN Credentials"
$BatchName = read-host "Batch Name"
$OnPremName = read-Host "Enter your On-Prem MRSProxy Name"
$TargetDomain = read-host "Enter your Office 365 domain (ie. your-org.mail.onmicrosoft.com)"
$UserToMove = ($global:USERLIST).name
$i = 1
foreach ($user in $UserToMove) {

    New-MoveRequest $user -Remote -RemoteHostName $OnPremName -TargetDeliveryDomain $TargetDomain -Remotecredential $localcred -baditemlimit 1000 -SuspendWhenReadyToComplete -BatchName $BatchName
    #-ErrorAction SilentlyContinue -WarningVariable:$null 
    write-progress -activity "Submitting move requests..." -status "Processing $user" -PercentComplete ($i / $global:USERCOUNT*100)
    $i++
}