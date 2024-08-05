function Invoke-CWCDeleteSessionEventTrigger {
    [CmdletBinding()]
    param (
        [string]$TriggerName
    )

    $Endpoint = 'Services/TriggerService.ashx/DeleteSessionEventTrigger'

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