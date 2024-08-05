function Invoke-CWCDeleteSecurityEventTrigger {
    [CmdletBinding()]
    param (
        [string]$TriggerName
    )

    $Endpoint = 'Services/TriggerService.ashx/DeleteSecurityEventTrigger'

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