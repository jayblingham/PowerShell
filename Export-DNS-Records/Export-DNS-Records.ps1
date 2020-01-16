$Zones = @(Get-DnsServerZone -computername CAMIS1-MLF-MF02 | where {$_.IsReverseLookupZone -eq $False})
$OUTPUT = "ZoneName| HostName| RecordType| RecordData" | Out-file .\output.txt
ForEach ($Zone in $Zones) {
    $ZONERECORD = Get-DnsServerResourceRecord $Zone.ZoneName -computername CAMIS1-MLF-MF02

    foreach ($record in $ZONERECORD){
        $Hostname = $record.Hostname
        $RecordType = $record.RecordType
        $RecordData = $record.RecordData
        $ZoneName = $Zone.ZoneName

    $OUTPUT = "$ZoneName| $Hostname| $recordType| $RecordData" | Out-File .\output.txt -Append
    }
}


