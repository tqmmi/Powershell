# Powershell

## Test-IPRange.ps1

```powershell
.\fast-ping.ps1 -Start "<start>" -End "<end>" [-Timeout <ms>] [-ShowUnreachable]
```
| Parameter | Description |
| --------- | ----------- |
| -Start | Starting IP address, e.g. `192.168.1.1` |
| -End | Ending IP address, e.g. `192.168.1.255` |
| -Timeout | Ping timeout in milliseconds, default: `100` |
| -ShowUnreachable | Display unreachable IPs |
