#Nolan Schumal
#Online
#Script for outputting OS name build and version to report.txt

#For each command you have the following 3 lines:
#1 is a comment line in your script that provides information about what your script is doing.  Example: "1. Outputing information about installed hotfixes"
#2 is header infomration for your report file. Example: Write-Output 'Header/Title of Output' | out-file report.txt
#3 is the command itself
#Example of a single command:
#Ex1. Outputing Servcies that are running
#Write-Output "#1: Outputing Services that are running" | Out-File report.txt
#Get-Service | Where-Object Status -eq 'Running' | Out-File report.txt -Append


param (
    [Parameter (Mandatory=$True)]
    [string] $computername
)

Get-CIMinstance win32_OperatingSystem -ComputerName $computername|
select -property Caption,Buildnumber,Version|
Out-file -FilePath .\report.txt

Get-CimInstance Win32_Processor -ComputerName $computername|
Select-Object -Property MaxClockSpeed,DeviceID,Name|
Out-file -FilePath .\report.txt -Append

Get-CimInstance Win32_NetworkAdapterConfiguration -ComputerName $computername|
Select-Object -Property IPAddress, IPSubnet, DefaultIPGateway, DHCPEnabled|
Out-file -FilePath .\report.txt -Append

Get-dnsclientserveraddress -cimsession $computername|
Select-Object -Property ServerAddresses|
Out-file -FilePath .\report.txt -Append

Get-CimInstance Win32_PhysicalMemory -ComputerName $computername|
Select-Object -Property @{
label='Capacity (GB)'
expression={($_.Capacity/1GB).ToString('F2')}
}|
Out-file -FilePath .\report.txt -Append

Get-CimInstance Win32_LogicalDisk -ComputerName $computername|
Where-Object -Property DeviceID -eq 'C:' |
Select-Object -Property @{
label='FreeSpace (GB)'
expression={($_.FreeSpace/1GB).ToString('F2')}
}|
Out-file -FilePath .\report.txt -Append

Get-CimInstance Win32_OperatingSystem -ComputerName $computername|
Select-Object -Property CSName,LastBootUpTime|
Out-file -FilePath .\report.txt -Append

Get-CimInstance Win32_computersystem -ComputerName $computername|
Select-Object -Property UserName|
Out-file -FilePath .\report.txt -Append

Get-CimInstance Win32_Product -ComputerName $computername|
Select-Object -Property Name,Vendor,Version|
Out-file -FilePath .\report.txt -Append
