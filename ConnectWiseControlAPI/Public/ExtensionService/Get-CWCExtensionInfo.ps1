function Get-CWCExtensionInfo {
    [CmdletBinding()]
    param ()

    $Endpoint = 'Services/ExtensionService.ashx/GetExtensionInfos'

    $WebRequestArguments = @{
        Endpoint = $Endpoint
        Method   = 'Post'
    }

    Invoke-CWCWebRequest -Arguments $WebRequestArguments
}