function Connect-Aruba {
    param(
        [Parameter(Mandatory = $true)]
        [string]$IPAddress,
        [Parameter(Mandatory = $true)]
        [string]$Username,
        [Parameter(Mandatory = $true)]
        [securestring]$Password
    )

    $plainPassword = [Runtime.InteropServices.Marshal]::PtrToStringAuto(
        [Runtime.InteropServices.Marshal]::SecureStringToBSTR($Password)
    )

    $api = Get-ArubaAPIVersion -IPAddress $IPAddress
    $prefix = $api.ApiPrefix
    $uri = "https://$IPAddress$prefix/login?username=$Username&password=$plainPassword"

    $headers = @{
        "accept"           = "*/*"
        "x-use-csrf-token" = "true"
    }
    
    $session = New-Object Microsoft.PowerShell.Commands.WebRequestSession

    try {
        Invoke-RestMethod -Uri $uri -Method POST -Headers $headers -Body "" -WebSession $session -SkipCertificateCheck
        return  $session
    }
    catch {
        throw "Failed to login: $($_.Exception.Message)"
    }
}

function Disconnect-Aruba {
    param(
        [Parameter(Mandatory = $true)]
        [string]$IPAddress,
        [Parameter(Mandatory = $true)]
        [Microsoft.PowerShell.Commands.WebRequestSession]$Session
    )

    $api = Get-ArubaAPIVersion -IPAddress $IPAddress
    $prefix = $api.ApiPrefix
    $uri = "https://$IPAddress$prefix/logout"

    $headers = @{
        "accept"           = "*/*"
        "x-use-csrf-token" = "true"
    }

    try {
        Invoke-RestMethod -Uri $uri -Method POST -Headers $headers -Body "" -WebSession $session -SkipCertificateCheck
    }
    catch {
        throw "Failed to logout: $($_.Exception.Message)"
    }
}
