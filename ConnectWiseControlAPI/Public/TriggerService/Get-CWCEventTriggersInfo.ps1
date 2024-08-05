function Get-CWCEventTriggersInfo {
    [CmdletBinding()]
    param ()

    $Endpoint = 'Services/TriggerService.ashx/GetEventTriggers'

    $WebRequestArguments = @{
        Endpoint = $Endpoint
        Method   = 'Post'
    }

    Invoke-CWCWebRequest -Arguments $WebRequestArguments
}