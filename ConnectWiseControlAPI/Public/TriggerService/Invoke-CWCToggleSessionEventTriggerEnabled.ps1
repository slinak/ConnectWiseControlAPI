function Invoke-CWCToggleSessionEventTriggerEnabled {
    [CmdletBinding()]
    param (
        [string]$TriggerName
    )

    $Endpoint = 'Services/TriggerService.ashx/ToggleSessionEventTriggerEnabled'

    $Body = ConvertTo-Json @(
        $TriggerName
    )
    Write-Verbose $Body

    $WebRequestArguments = @{
        Endpoint = $Endpoint
        Body     = $Body
        Method   = 'Post'
    }

    Invoke-CWCWebRequest -Arguments $WebRequestArguments
}