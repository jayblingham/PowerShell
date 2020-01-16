#By CSS ERW 14 Sept 2013
#Updates by Jason Billingham, 1 JAN 2020  

#This script creates DNS A records and associated Reverse PTR 
#If Reverse zone doesn't exist the script creates it 
#Create a records.csv file with Computer,IP information

#Example format below add first line to your csv file, or modify the provided example CSV file
 
#Computer,IP 
#Computer,192.168.0.1 
#Computer1,192.168.0.2 
#Computer2,192.168.0.3 

###############SCRIPT BEGINS HERE###############

#Update these variables with your dns server info: Servername and DNS Domain name
$ServerName = "DNS-Server-Name"
$domain = "mydomain.com"

Import-Csv .\records.csv | ForEach-Object { 
 
    #Def variable
    $Computer = "$($_.Computer).$domain" 
    $addr = $_.IP -split "\." 
    $rzone = "$($addr[2]).$($addr[1]).$($addr[0]).in-addr.arpa" 
    
    #Create Dns entries 
    dnscmd $Servername /recordadd $domain "$($_.Computer)" A "$($_.IP)" 
    
    #Create New Reverse Zone if zone already exist, system return a normal error 
    dnscmd $Servername /zoneadd $rzone /primary 
    
    #Create reverse DNS 
    dnscmd $Servername /recordadd $rzone "$($addr[3])" PTR $Computer 
}