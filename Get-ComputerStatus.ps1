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
Select-Object -property Caption,BuildNumber,Version

Get-CimInstance Win32_Processor -ComputerName $computername |
Select-Object -Property MaxClockSpeed,DeviceID,Name

Get-CimInstance Win32_NetworkAdapterConfiguration |
Select-Object -Property IPAddress, IPSubnet, DefaultIPGateway, DHCPEnabled

Get-dnsclientserveraddress |
Select-Object -Property ServerAddresses

Get-CimInstance Win32_PhysicalMemory |
Select-Object -Property @{
label='Capacity (GB)'
expression={($_.Capacity/1GB).ToString('F2')}
}

Get-CimInstance Win32_LogicalDisk |
Where-Object -Property DeviceID -eq 'C:' |
Select-Object -Property @{
label='FreeSpace (GB)'
expression={($_.FreeSpace/1GB).ToString('F2')}
}

Get-CimInstance Win32_OperatingSystem |
Select-Object -Property CSName,LastBootUpTime

Get-CimInstance Win32_computersystem |
Select-Object -Property UserName

Get-CimInstance Win32_Product|
Select-Object -Property Name,Vendor,Version