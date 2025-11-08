param (
    [Parameter(Mandatory = $true)]
    [string]$IPAddress,
    [Parameter(Mandatory = $true)]
    [securestring]$Password
)

$api = Get-ArubaAPIVersion -IPAddress $IPAddress

Write-Host $api.DocsAddress

$session = Connect-Aruba -IPAddress $IPAddress -Username "admin" -Password $Password

Write-Host $session.Cookies.GetCookies("https://$IPAddress")

Disconnect-Aruba -IPAddress $IPAddress -Session $session
