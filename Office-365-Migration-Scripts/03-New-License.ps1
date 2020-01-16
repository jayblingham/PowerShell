[CmdletBinding()]
Param(
  [Parameter(Mandatory=$false)]
   [string]$file
)

$YourOrgName = yourorg #This is the first part of your Office 365 domain (yourorg.onmicrosoft.com)

#Parameter validation
if($file -eq "") {$isInputInFile = $false}
elseif (Test-Path -Path $file) {$isInputInFile = $true}
else {$isInputInFile = $false}

$AccountSKU = "$YourOrgName:ENTERPRISEWITHSCAL"


$Exchange = "Enabled"
$SharePoint = "Disabled" 
$Lync = "Disabled" 
$Office = "Disabled"
$WebApps = "Disabled"
$RMS = "Disabled"
$LyncConf = "Disabled"

$DisabledOptions = New-Object System.Collections.ArrayList
If ($Exchange -eq "Disabled") { $DisabledOptions.Add("EXCHANGE_S_ENTERPRISE") }
If ($SharePoint -eq "Disabled") { $DisabledOptions.Add("SHAREPOINTENTERPRISE") }
If ($Lync -eq "Disabled") { $DisabledOptions.Add("MCOSTANDARD") }
If ($Office -eq "Disabled") { $DisabledOptions.Add("OFFICESUBSCRIPTION") }
If ($WebApps -eq "Disabled") { $DisabledOptions.Add("SHAREPOINTWAC") }
If ($RMS -eq "Disabled") { $DisabledOptions.Add("RMS_S_ENTERPRISE") }
If ($LyncConf -eq "Disabled") { $DisabledOptions.Add("MCOVOICECONF") }


if($isInputInFile) {

$users = ($global:USERLIST).name

}
else {

Write-host "Input file required"
Exit

}

$i = 1

foreach ($user in $users) {
write-progress -activity "Assigning Exchange Online License..." -status "Processing $user" -PercentComplete ($i / $global:USERCOUNT*100)

try{
    $msoluser = Get-MsolUser -UserPrincipalName $user -ErrorAction Stop
    }
catch {
    Write-Output "$user not found in the syncrhonized users"
continue
}

try{

    if ($msoluser.isLicensed) {

    Set-MSOLUser -UserPrincipalName $msoluser.UserPrincipalName -UsageLocation "CA" -ErrorAction Stop

 #Build a license list for users here.
 
    $UserDisabledOptions = New-Object System.Collections.ArrayList
    $UserDisabledOptions = $DisabledOptions  
    $msoluser.Licenses.ServiceStatus | ?{$_.ProvisioningStatus -ne "Disabled"} | foreach{
    $ActiveOption = $_.ServicePlan.ServiceName
    
    if ($ActiveOption -in $UserDisabledOptions) {$UserDisabledOptions.Remove($ActiveOption)}

    }


#Define new aray with disabled options: Remove only disabled one. If it was enabled before - don't touch.
    $LicenseOptions = New-MsolLicenseOptions -AccountSkuId $AccountSKU -DisabledPlans @($UserDisabledOptions)
    Set-MsolUserLicense -UserPrincipalName $msoluser.UserPrincipalName -LicenseOptions $LicenseOptions
    Write-Output ("Update")
    Remove-Variable UserDisabledOptions
    }
    else{

    $LicenseOptions = New-MsolLicenseOptions -AccountSkuId $AccountSKU -DisabledPlans @($DisabledOptions)
    Set-MSOLUser -UserPrincipalName $msoluser.UserPrincipalName -UsageLocation "CA" -ErrorAction Stop
    Set-MsolUserLicense -UserPrincipalName $msoluser.UserPrincipalName -LicenseOptions $LicenseOptions -AddLicenses $AccountSKU -ErrorAction Stop
    Write-Output ("Assign")
    }
    }
catch {

Write-Output $user.UserPrincipalName $_.Exception.Message
Write-Output $_.Exception.ItemName

}
$i++
}