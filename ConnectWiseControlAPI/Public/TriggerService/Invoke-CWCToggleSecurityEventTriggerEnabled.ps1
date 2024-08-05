function Invoke-CWCToggleSecurityEventTriggerEnabled {
    [CmdletBinding()]
    param (
        [string]$TriggerName
    )

    $Endpoint = 'Services/TriggerService.ashx/ToggleSecurityEventTriggerEnabled'

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