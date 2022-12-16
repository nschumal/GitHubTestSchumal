#Nolan Schumal
#Online Infastructure Automation
#12/12/2022
#Script for gathering information on a system


param (
    [Parameter (Mandatory=$True)]
    [string] $computername
)
#Os info
Get-CIMinstance win32_OperatingSystem -ComputerName $computername|
select -property Caption,Buildnumber,Version|
Out-file -FilePath .\SchumalFall2022.txt -Encoding utf8
#Processor info
Get-CimInstance Win32_Processor -ComputerName $computername|
Select-Object -Property MaxClockSpeed,DeviceID,Name|
Out-file -FilePath .\SchumalFall2022.txt -Append
#IP info
Get-CimInstance Win32_NetworkAdapterConfiguration -ComputerName $computername|
Select-Object -Property IPAddress, IPSubnet, DefaultIPGateway, DHCPEnabled|
Out-file -FilePath .\SchumalFall2022.txt -Append
#DNS info
Get-dnsclientserveraddress -cimsession $computername|
Select-Object -Property ServerAddresses|
Out-file -FilePath .\SchumalFall2022.txt -Append
#Memory in GB
Get-CimInstance Win32_PhysicalMemory -ComputerName $computername|
Select-Object -Property @{
label='Capacity (GB)'
expression={($_.Capacity/1GB).ToString('F2')}
}|
Out-file -FilePath .\SchumalFall2022.txt -Append
#Free space in C:
Get-CimInstance Win32_LogicalDisk -ComputerName $computername|
Where-Object -Property DeviceID -eq 'C:' |
Select-Object -Property @{
label='FreeSpace (GB)'
expression={($_.FreeSpace/1GB).ToString('F2')}
}|
Out-file -FilePath .\SchumalFall2022.txt -Append
#Last boot up time
Get-CimInstance Win32_OperatingSystem -ComputerName $computername|
Select-Object -Property CSName,LastBootUpTime|
Out-file -FilePath .\SchumalFall2022.txt -Append
#last user login
Get-CimInstance Win32_computersystem -ComputerName $computername|
Select-Object -Property UserName|
Out-file -FilePath .\SchumalFall2022.txt -Append
#all users

#installed apps
Get-CimInstance Win32_Product -ComputerName $computername|
Select-Object -Property Name,Vendor,Version|
Out-file -FilePath .\SchumalFall2022.txt -Append
