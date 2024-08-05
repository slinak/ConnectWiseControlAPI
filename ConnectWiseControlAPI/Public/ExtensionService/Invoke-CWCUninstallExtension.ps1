function Invoke-CWCUninstallExtension {
    [CmdletBinding()]
    param (
        [guid]$ExtensionID
    )

    $Endpoint = 'Services/ExtensionService.ashx/UninstallExtension'

    $Body = ConvertTo-Json @(
        $ExtensionPackageContent
    )
    Write-Verbose $Body

    $WebRequestArguments = @{
        Endpoint = $Endpoint
        Body     = $Body
        Method   = 'Post'
    }

    Invoke-CWCWebRequest -Arguments $WebRequestArguments
}