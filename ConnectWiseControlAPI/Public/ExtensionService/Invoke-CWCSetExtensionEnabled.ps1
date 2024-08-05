function Invoke-CWCSetExtensionEnabled {
    [CmdletBinding()]
    param (
        [guid]$ExtensionID,
        [bool]$EnabledOrDisabled
    )

    $Endpoint = 'Services/ExtensionService.ashx/SetExtensionEnabled'

    $Body = ConvertTo-Json @(
        $ExtensionPackageContent,
        $EnabledOrDisabled
    )
    Write-Verbose $Body

    $WebRequestArguments = @{
        Endpoint = $Endpoint
        Body     = $Body
        Method   = 'Post'
    }

    Invoke-CWCWebRequest -Arguments $WebRequestArguments
}