function Get-ArubaAPIVersion {
    param (
        [Parameter(Mandatory = $true)]
        [string]$IPAddress
    )

    $uri = "https://$IPAddress/rest"

    try {
        $response = Invoke-RestMethod -Uri $uri -SkipCertificateCheck -ConnectionTimeoutSeconds 5

        $version = $response.latest.version
        $api_prefix = $response.latest.prefix
        $docs = $response.latest.doc
        $docs_address = "https://$IPAddress$docs"

        $result = [PSCustomObject]@{
            Version     = $version
            ApiPrefix   = $api_prefix
            Docs        = $docs
            DocsAddress = $docs_address
        }

        return $result

    }
    catch {
        throw "Error fetching API response: $($_.Exception.Message)"
    }
}
