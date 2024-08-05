function Invoke-CWCInstallExtension {
    [CmdletBinding()]
    param (
        [string]$ExtensionPackageContent
    )

    $Endpoint = 'Services/ExtensionService.ashx/InstallExtension'

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