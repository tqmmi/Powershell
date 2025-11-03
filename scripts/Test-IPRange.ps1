function Test-IPRange {
    param (
        [Parameter(Mandatory = $true)]
        [string]$StartIP,
        [Parameter(Mandatory = $true)]
        [string]$EndIP,
        [int]$Timeout = 100,
        [switch]$ShowUnreachable
    )

    function Convert-IPToUInt32 {
        param ([string]$ip)
        $parts = $ip.Split('.')
        return ($parts[0] -as [int]) * 16777216 + ($parts[1] -as [int]) * 65536 + ($parts[2] -as [int]) * 256 + ($parts[3] -as [int])
    }

    function Convert-UInt32ToIP {
        param ([uint32]$int)
        $a = [math]::Floor($int / 16777216)
        $b = [math]::Floor(($int % 16777216) / 65536)
        $c = [math]::Floor(($int % 65536) / 256)
        $d = $int % 256
        return "$a.$b.$c.$d"
    }

    $startInt = Convert-IPToUInt32 $StartIP
    $endInt = Convert-IPToUInt32 $EndIP
    $total = $endInt - $startInt + 1
    $count = 0

    for ($i = $startInt; $i -le $endInt; $i++) {
        $count++
        $ip = Convert-UInt32ToIP $i

        Write-Progress -Activity "Pinging IPs" -Status "Checking $ip" -PercentComplete (($count / $total) * 100)

        $ping = New-Object System.Net.NetworkInformation.Ping
        try {
            $reply = $ping.Send($ip, $Timeout)
            if ($reply.Status -eq 'Success') {
                Write-Host "$ip is alive" -ForegroundColor Green
            }
            elseif ($ShowUnreachable) {
                Write-Host "$ip is unreachable" -ForegroundColor DarkGray
            }
        }
        catch {
            Write-Host "$ip error" -ForegroundColor Red
        }
    }

    Write-Progress -Activity "Pinging IPs" -Completed
}