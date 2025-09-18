param (
    [Parameter(Mandatory = $true)]
    [string[]]$IPList
)

$pingSender = New-Object System.Net.NetworkInformation.Ping
$timeout = 500

$sortedIPs = $IPList | Sort-Object

$statusMap = @{}
foreach ($ip in $sortedIPs) {
    $statusMap[$ip] = "Checking..."
}

Clear-Host
Write-Host "Pinging Addresses:"
foreach ($ip in $sortedIPs) {
    Write-Host "$ip : $($statusMap[$ip])"
}

[int]$startY = [Console]::CursorTop - $sortedIPs.Count

while ($true) {
    foreach ($i in 0..($sortedIPs.Count - 1)) {
        $ip = $sortedIPs[$i]
        try {
            $reply = $pingSender.Send($ip, $timeout)
            if ($reply.Status -eq 'Success') {
                $statusMap[$ip] = "ONLINE"
                $color = "Green"
            }
            else {
                $statusMap[$ip] = "OFFLINE"
                $color = "Red"
            }
        }
        catch {
            $statusMap[$ip] = "ERROR"
            $color = "DarkRed"
        }

        [Console]::SetCursorPosition(0, $startY + $i)
        Write-Host "$ip : $($statusMap[$ip])".PadRight(30) -ForegroundColor $color
    }

    $maxY = [Console]::BufferHeight
    if (($startY + $i) -ge 0 -and ($startY + $i) -lt $maxY) {
        [Console]::SetCursorPosition(0, $startY + $i)
    }
    
    $timestamp = Get-Date -Format "HH:mm:ss"
    Write-Host "Last checked: $timestamp".PadRight(30)

    Start-Sleep -Seconds 5
}
