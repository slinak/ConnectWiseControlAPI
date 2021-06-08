function Invoke-CWCCommand {
    [CmdletBinding()]
    param (
        [Parameter(Mandatory=$True)]
        [guid]$GUID,
        [string]$Command,
        [int]$TimeOut = 10000,
        [switch]$PowerShell,
        [string]$Group = 'All Machines',
        [switch]$NoWait
    )

    $Endpoint = 'Services/PageService.ashx/AddEventToSessions'

    $origin = New-Object -Type DateTime -ArgumentList 1970, 1, 1, 0, 0, 0, 0
    $SessionEventType = 44

    # Format command
    $FormattedCommand = @()
    if ($Powershell) { $FormattedCommand += '#!ps' }
    $FormattedCommand += "#timeout=$TimeOut"
    $FormattedCommand += $Command
    $FormattedCommand = $FormattedCommand | Out-String

    $Body = (ConvertTo-Json @($Group,@($GUID),$SessionEventType,$FormattedCommand)).Replace('\r\n','\n')
    Write-Verbose $Body

    # Issue command
    $WebRequestArguments = @{
        Endpoint = $Endpoint
        Body = $Body
        Method = 'Post'
    }
    $null = Invoke-CWCWebRequest -Arguments $WebRequestArguments
    if ($NoWait) { return }

    # Get Session
    $Endpoint = 'Services/PageService.ashx/GetSessionDetails'
    $Body = ConvertTo-Json @($Group,$GUID)
    Write-Verbose $Body
    try {
        $WebRequestArguments = @{
            Endpoint = $Endpoint
            Body = $Body
            Method = 'Post'
        }
        $SessionDetails = Invoke-CWCWebRequest -Arguments $WebRequestArguments
    }
    catch { return $_ }

    #Get time command was executed
    $epoch = $((New-TimeSpan -Start $(Get-Date -Date "01/01/1970") -End $(Get-Date)).TotalSeconds)
    $ExecuteTime = $epoch - ((($SessionDetails.events | Where-Object {$_.EventType -eq 44})[-1]).Time /1000)
    $ExecuteDate = $origin.AddSeconds($ExecuteTime)

    # Look for results of command
    $Looking = $True
    $TimeOutDateTime = (Get-Date).AddMilliseconds($TimeOut)
    $Body = ConvertTo-Json @($Group,$GUID)
    while ($Looking) {
        try {
            $WebRequestArguments = @{
                Endpoint = $Endpoint
                Body = $Body
                Method = 'Post'
            }
            $SessionDetails = Invoke-CWCWebRequest -Arguments $WebRequestArguments
        }
        catch { return $_ }

        $ConnectionsWithData = @()
        Foreach ($Connection in $SessionDetails.connections) {
            $ConnectionsWithData += $Connection | Where-Object {$_.Events.EventType -eq 70}
        }

        $Events = ($ConnectionsWithData.events | Where-Object {$_.EventType -eq 70 -and $_.Time})
        foreach ($Event in $Events) {
            $epoch = $((New-TimeSpan -Start $(Get-Date -Date "01/01/1970") -End $(Get-Date)).TotalSeconds)
            $CheckTime = $epoch - ($Event.Time /1000)
            $CheckDate = $origin.AddSeconds($CheckTime)
            if ($CheckDate -gt $ExecuteDate) {
                $Looking = $False
                $Output = $Event.Data -split '[\r\n]' | Where-Object {$_ -and $_ -ne "C:\WINDOWS\system32>$Command"}
                Write-Verbose $Event.Data
                return $Output
            }
        }

        Start-Sleep -Seconds 1
        if ($(Get-Date) -gt $TimeOutDateTime.AddSeconds(1)) {
            $Looking = $False
            Write-Warning "Command timed out."
        }
    }
}