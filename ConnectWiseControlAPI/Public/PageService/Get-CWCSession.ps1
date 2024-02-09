function Get-CWCSession {
    [CmdletBinding()]
    param (
        [Parameter(Mandatory=$True)]
        [ValidateSet('Support','Access','Meeting')]
        $Type,
        [string]$Group = 'All Machines',
        [string]$Search,
        [int]$Limit
    )

    $BaseLiveDataEndpoint = 'Services/PageService.ashx/GetLiveData'

    switch($Type){
        'Support' { $Number = 0 }
        'Meeting' { $Number = 1 }
        'Access' { $Number = 2 }
        default { return Write-Error "Unknown Type, $Type" }
    }

    $Body = ConvertTo-Json @($Number,@($Group),$Search,$null,$Limit)
    Write-Verbose $Body

    $WebRequestArguments = @{
        Endpoint = $BaseLiveDataEndpoint
        Body = $Body
        Method = 'Post'
    }

    $Data =  Invoke-CWCWebRequest -Arguments $WebRequestArguments
    $Data.sessions
}
