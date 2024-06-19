# zabbix-winraid
Zabbix script and template for Windows software RAID monitoring (striped and spanned volumes, mirrored volumes and RAID-5 sets on dynamic disks)

It's a very simple template and script for Windows software RAID monitoring that uses Microsoft Virtual Disk Service to get storage status info.
It could be a Zabbix Discovery rule but it's version shown here is enough for my purposes) Just checking status of all RAID that exist at machine and if at least one of them have not HEALTHY status trigger will send appropriate notification.

Idea of VDS usage - https://kazunposh.wordpress.com/2013/03/24/%D0%BA%D0%B0%D0%BA-%D0%BF%D0%BE%D0%BB%D1%83%D1%87%D0%B8%D1%82%D1%8C-%D1%81%D1%82%D0%B0%D1%82%D1%83%D1%81-%D0%BF%D1%80%D0%BE%D0%B3%D1%80%D0%B0%D0%BC%D0%BC%D0%BD%D0%BE%D0%B3%D0%BE-%D0%BC%D0%B0%D1%81/

Just place pwsh script somewhere at the server where you want to monitor RAID and add UserParameter to zabbix agent config, for example:
```powershell
UserParameter=raid_status, powershell -NoProfile -ExecutionPolicy Bypass -File "C:\Program Files\Zabbix Agent 2\raid_status.ps1"
```
