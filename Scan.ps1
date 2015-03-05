#region Scans
####################################################################

<#
.Synops
   Pause a running scan on a Nessus server.
.DESCRIPTION
   Pause a running scan on a Nessus server.
.EXAMPLE
    Suspend-NessusScan -SessionId 0 -ScanId 46


    Name            : Whole Lab
    ScanId          : 46
    Status          : running
    Enabled         : 
    Owner           : carlos
    AlternateTarget : 
    IsPCI           : 
    UserPermission  : 
    CreationDate    : 2/24/2015 6:17:11 AM
    LastModified    : 2/24/2015 6:17:11 AM
    StartTime       : 12/31/1969 8:00:00 PM

    PS C:\> Get-NessusScan -SessionId 0 -Status Paused


    Name           : Whole Lab
    ScanId         : 46
    Status         : paused
    Enabled        : False
    FolderId       : 2
    Owner          : carlos
    UserPermission : 
    Rules          : 
    Shared         : False
    TimeZone       : 
    CreationDate   : 2/24/2015 6:17:11 AM
    LastModified   : 2/24/2015 6:22:17 AM
    StartTime      : 12/31/1969 8:00:00 PM
#>
function Suspend-NessusScan
{
    [CmdletBinding()]
    Param
    (
        # Nessus session Id
        [Parameter(Mandatory=$true,
                   Position=0,
                   ValueFromPipelineByPropertyName=$true)]
        [Alias('Index')]
        [int32[]]
        $SessionId = @(),

        [Parameter(Mandatory=$false,
                   Position=1,
                   ValueFromPipelineByPropertyName=$true)]
        [int32]
        $ScanId 
    )

    Begin
    {
        $origin = New-Object -Type DateTime -ArgumentList 1970, 1, 1, 0, 0, 0, 0
    }
    Process
    {
        $ToProcess = @()

        foreach($i in $SessionId)
        {
            $Connections = $Global:NessusConn
            
            foreach($Connection in $Connections)
            {
                if ($Connection.SessionId -eq $i)
                {
                    $ToProcess += $Connection
                }
            }
        }
        
        foreach($Connection in $ToProcess)
        {
            $Scans =  InvokeNessusRestRequest -SessionObject $Connection -Path "/scans/$($ScanId)/pause" -Method 'Post'

            if ($Scans -is [psobject])
            {
                $scan = $Scans.scan
                $ScanProps = [ordered]@{}
                $ScanProps.add('Name', $scan.name)
                $ScanProps.add('ScanId', $ScanId)
                $ScanProps.add('HistoryId', $scan.id)
                $ScanProps.add('Status', $scan.status)
                $ScanProps.add('Enabled', $scan.enabled)
                $ScanProps.add('Owner', $scan.owner)
                $ScanProps.add('AlternateTarget', $scan.ownalt_targetser)
                $ScanProps.add('IsPCI', $scan.is_pci)
                $ScanProps.add('UserPermission', $PermissionsId2Name[$scan.user_permissions])
                $ScanProps.add('CreationDate', $origin.AddSeconds($scan.creation_date).ToLocalTime())
                $ScanProps.add('LastModified', $origin.AddSeconds($scan.last_modification_date).ToLocalTime())
                $ScanProps.add('StartTime', $origin.AddSeconds($scan.starttime).ToLocalTime())
                $ScanProps.Add('SessionId', $Connection.SessionId)
                $ScanObj = New-Object -TypeName psobject -Property $ScanProps
                $ScanObj.pstypenames[0] = 'Nessus.RunningScan'
                $ScanObj
            }
        }
    }
    End{}
}


<#
.Synopsis
   Resume a paused scan on a Nessus server.
.DESCRIPTION
   Resume a paused scan on a Nessus server.
.EXAMPLE
   Resume-NessusScan -SessionId 0 -ScanId 46


    Name            : Whole Lab
    ScanId          : 46
    Status          : paused
    Enabled         : 
    Owner           : carlos
    AlternateTarget : 
    IsPCI           : 
    UserPermission  : 
    CreationDate    : 2/24/2015 6:17:11 AM
    LastModified    : 2/24/2015 6:17:11 AM
    StartTime       : 12/31/1969 8:00:00 PM




    PS C:\> Get-NessusScan -SessionId 0 -Status Running


    Name           : Whole Lab
    ScanId         : 46
    Status         : running
    Enabled        : False
    FolderId       : 2
    Owner          : carlos
    UserPermission : 
    Rules          : 
    Shared         : False
    TimeZone       : 
    CreationDate   : 2/24/2015 6:17:11 AM
    LastModified   : 2/24/2015 6:25:34 AM
    StartTime      : 12/31/1969 8:00:00 PM
#>
function Resume-NessusScan
{
    [CmdletBinding()]
    Param
    (
        # Nessus session Id
        [Parameter(Mandatory=$true,
                   Position=0,
                   ValueFromPipelineByPropertyName=$true)]
        [Alias('Index')]
        [int32[]]
        $SessionId = @(),

        [Parameter(Mandatory=$true,
                   Position=1,
                   ValueFromPipelineByPropertyName=$true)]
        [int32]
        $ScanId 
    )

    Begin
    {
        $origin = New-Object -Type DateTime -ArgumentList 1970, 1, 1, 0, 0, 0, 0
    }
    Process
    {
        $ToProcess = @()

        foreach($i in $SessionId)
        {
            $Connections = $Global:NessusConn
            
            foreach($Connection in $Connections)
            {
                if ($Connection.SessionId -eq $i)
                {
                    $ToProcess += $Connection
                }
            }
        }
        

        foreach($Connection in $ToProcess)
        {
            $Scans =  InvokeNessusRestRequest -SessionObject $Connection -Path "/scans/$($ScanId)/resume" -Method 'Post'

            if ($Scans -is [psobject])
            {
                $scan = $Scans.scan
                $ScanProps = [ordered]@{}
                $ScanProps.add('Name', $scan.name)
                $ScanProps.add('ScanId', $ScanId)
                $ScanProps.add('HistoryId', $scan.id)
                $ScanProps.add('Status', $scan.status)
                $ScanProps.add('Enabled', $scan.enabled)
                $ScanProps.add('Owner', $scan.owner)
                $ScanProps.add('AlternateTarget', $scan.ownalt_targetser)
                $ScanProps.add('IsPCI', $scan.is_pci)
                $ScanProps.add('UserPermission', $PermissionsId2Name[$scan.user_permissions])
                $ScanProps.add('CreationDate', $origin.AddSeconds($scan.creation_date).ToLocalTime())
                $ScanProps.add('LastModified', $origin.AddSeconds($scan.last_modification_date).ToLocalTime())
                $ScanProps.add('StartTime', $origin.AddSeconds($scan.starttime).ToLocalTime())
                $ScanProps.Add('SessionId', $Connection.SessionId)
                $ScanObj = New-Object -TypeName psobject -Property $ScanProps
                $ScanObj.pstypenames[0] = 'Nessus.RunningScan'
                $ScanObj
            }
        }
    }
    End
    {
    }
}


<#
.Synopsis
   Cancel a scan on a Nessus server.
.DESCRIPTION
   Cancel a scan on a Nessus server.
.EXAMPLE
   Stop-NessusScan -SessionId 0 -ScanId 46


    Name            : Whole Lab
    ScanId          : 46
    Status          : running
    Enabled         : 
    Owner           : carlos
    AlternateTarget : 
    IsPCI           : 
    UserPermission  : 
    CreationDate    : 2/24/2015 6:17:11 AM
    LastModified    : 2/24/2015 6:17:11 AM
    StartTime       : 12/31/1969 8:00:00 PM




    PS C:\> Get-NessusScan -SessionId 0 


    Name           : Whole Lab
    ScanId         : 46
    Status         : canceled
    Enabled        : False
    FolderId       : 2
    Owner          : carlos
    UserPermission : 
    Rules          : 
    Shared         : False
    TimeZone       : 
    CreationDate   : 2/24/2015 6:17:11 AM
    LastModified   : 2/24/2015 6:27:20 AM
    StartTime      : 12/31/1969 8:00:00 PM

#>
function Stop-NessusScan
{
    [CmdletBinding()]
    Param
    (
        # Nessus session Id
        [Parameter(Mandatory=$true,
                   Position=0,
                   ValueFromPipelineByPropertyName=$true)]
        [Alias('Index')]
        [int32[]]
        $SessionId = @(),

        [Parameter(Mandatory=$true,
                   Position=1,
                   ValueFromPipelineByPropertyName=$true)]
        [int32]
        $ScanId 
    )

    Begin
    {
        $origin = New-Object -Type DateTime -ArgumentList 1970, 1, 1, 0, 0, 0, 0
    }
    Process
    {
        $ToProcess = @()

        foreach($i in $SessionId)
        {
            $Connections = $Global:NessusConn
            
            foreach($Connection in $Connections)
            {
                if ($Connection.SessionId -eq $i)
                {
                    $ToProcess += $Connection
                }
            }
        }
        

        foreach($Connection in $ToProcess)
        {
            $Scans =  InvokeNessusRestRequest -SessionObject $Connection -Path "/scans/$($ScanId)/stop" -Method 'Post'

            if ($Scans -is [psobject])
            {
                $scan = $Scans.scan
                $ScanProps = [ordered]@{}
                $ScanProps.add('Name', $scan.name)
                $ScanProps.add('ScanId', $ScanId)
                $ScanProps.add('HistoryId', $scan.id)
                $ScanProps.add('Status', $scan.status)
                $ScanProps.add('Enabled', $scan.enabled)
                $ScanProps.add('Owner', $scan.owner)
                $ScanProps.add('AlternateTarget', $scan.ownalt_targetser)
                $ScanProps.add('IsPCI', $scan.is_pci)
                $ScanProps.add('UserPermission', $PermissionsId2Name[$scan.user_permissions])
                $ScanProps.add('CreationDate', $origin.AddSeconds($scan.creation_date).ToLocalTime())
                $ScanProps.add('LastModified', $origin.AddSeconds($scan.last_modification_date).ToLocalTime())
                $ScanProps.add('StartTime', $origin.AddSeconds($scan.starttime).ToLocalTime())
                $ScanProps.Add('SessionId', $Connection.SessionId)
                $ScanObj = New-Object -TypeName psobject -Property $ScanProps
                $ScanObj.pstypenames[0] = 'Nessus.RunningScan'
                $ScanObj
            }
        }
    }
    End
    {
    }
}


<#
.Synopsis
   Launch a scan on a Nessus server.
.DESCRIPTION
   Launch a scan on a Nessus server.
.EXAMPLE
   Start-NessusScan -SessionId 0 -ScanId 15 -AlternateTarget 192.168.11.11,192.168.11.12

    ScanUUID                                                                                                                                                                 
    --------                                                                                                                                                                 
    70aff007-3e61-242f-e90c-ee96ace62ca57ea8eb669c32205a                                                                                                                     



    PS C:\> Get-NessusScan -SessionId 0 -Status Running


    Name           : Lab1
    ScanId         : 15
    Status         : running
    Enabled        : True
    FolderId       : 2
    Owner          : carlos
    UserPermission : Sysadmin
    Rules          : 
    Shared         : False
    TimeZone       : 
    CreationDate   : 2/25/2015 7:39:49 PM
    LastModified   : 2/25/2015 7:40:28 PM
    StartTime      : 12/31/1969 8:00:00 PM
#>
function Start-NessusScan
{
    [CmdletBinding()]
    Param
    (
        # Nessus session Id
        [Parameter(Mandatory=$true,
                   Position=0,
                   ValueFromPipelineByPropertyName=$true)]
        [Alias('Index')]
        [int32[]]
        $SessionId = @(),

        [Parameter(Mandatory=$true,
                   Position=1,
                   ValueFromPipelineByPropertyName=$true)]
        [int32]
        $ScanId,

        [Parameter(Mandatory=$false,
                   Position=2,
                   ValueFromPipelineByPropertyName=$true)]
        [string[]]
        $AlternateTarget 
    )

    Begin
    {
        $origin = New-Object -Type DateTime -ArgumentList 1970, 1, 1, 0, 0, 0, 0
    }
    Process
    {
        $ToProcess = @()

        foreach($i in $SessionId)
        {
            $Connections = $Global:NessusConn
            
            foreach($Connection in $Connections)
            {
                if ($Connection.SessionId -eq $i)
                {
                    $ToProcess += $Connection
                }
            }
        }
        $Params = @{}

        if($AlternateTarget)
        {
            $Params.Add('alt_targets', $AlternateTarget)
        }
        $paramJson = ConvertTo-Json -InputObject $params -Compress

        foreach($Connection in $ToProcess)
        {
            $Scans =  InvokeNessusRestRequest -SessionObject $Connection -Path "/scans/$($ScanId)/launch" -Method 'Post' -Parameter $paramJson

            if ($Scans -is [psobject])
            {

                $ScanProps = [ordered]@{}
                $ScanProps.add('ScanUUID', $scans.scan_uuid)
                $ScanProps.add('ScanId', $ScanId)
                $ScanProps.add('SessionId', $Connection.SessionId)
                $ScanObj = New-Object -TypeName psobject -Property $ScanProps
                $ScanObj.pstypenames[0] = 'Nessus.LaunchedScan'
                $ScanObj
            }
        }
    }
    End
    {
    }
}


<#
.Synopsis
   Get scans present on a Nessus server.
.DESCRIPTION
   Get scans present on a Nessus server.
.EXAMPLE
    Get-NessusScan -SessionId 0 -Status Completed


    Name           : Lab Domain Controller Audit
    ScanId         : 61
    Status         : completed
    Enabled        : False
    FolderId       : 2
    Owner          : carlos
    UserPermission : Sysadmin
    Rules          : 
    Shared         : False
    TimeZone       : 
    CreationDate   : 2/25/2015 2:45:53 PM
    LastModified   : 2/25/2015 2:46:34 PM
    StartTime      : 12/31/1969 8:00:00 PM

    Name           : Whole Lab
    ScanId         : 46
    Status         : completed
    Enabled        : False
    FolderId       : 2
    Owner          : carlos
    UserPermission : Sysadmin
    Rules          : 
    Shared         : False
    TimeZone       : 
    CreationDate   : 2/24/2015 6:32:45 AM
    LastModified   : 2/24/2015 6:46:20 AM
    StartTime      : 12/31/1969 8:00:00 PM

    Name           : Lab1
    ScanId         : 15
    Status         : completed
    Enabled        : True
    FolderId       : 2
    Owner          : carlos
    UserPermission : Sysadmin
    Rules          : 
    Shared         : False
    TimeZone       : 
    CreationDate   : 2/18/2015 5:40:54 PM
    LastModified   : 2/18/2015 5:41:01 PM
    StartTime      : 12/31/1969 8:00:00 PM

    Name           : Lab2
    ScanId         : 17
    Status         : completed
    Enabled        : False
    FolderId       : 2
    Owner          : carlos
    UserPermission : Sysadmin
    Rules          : 
    Shared         : False
    TimeZone       : 
    CreationDate   : 2/13/2015 9:12:31 PM
    LastModified   : 2/13/2015 9:19:04 PM
    StartTime      : 12/31/1969 8:00:00 PM
#>
function Get-NessusScan
{
    [CmdletBinding()]
    Param
    (
        # Nessus session Id
        [Parameter(Mandatory=$true,
                   Position=0,
                   ValueFromPipelineByPropertyName=$true)]
        [Alias('Index')]
        [int32[]]
        $SessionId = @(),

        [Parameter(Mandatory=$false,
                   Position=1,
                   ValueFromPipelineByPropertyName=$true)]
        [int32]
        $FolderId,

        [Parameter(Mandatory=$false,
                   Position=2,
                   ValueFromPipelineByPropertyName=$true)]
        [ValidateSet('Completed', 'Imported', 'Running', 'Paused', 'Canceled')]
        [string]
        $Status
    )

    Begin
    {
        $origin = New-Object -Type DateTime -ArgumentList 1970, 1, 1, 0, 0, 0, 0
    }
    Process
    {
        $ToProcess = @()

        foreach($i in $SessionId)
        {
            $Connections = $Global:NessusConn
            
            foreach($Connection in $Connections)
            {
                if ($Connection.SessionId -eq $i)
                {
                    $ToProcess += $Connection
                }
            }
        }
        $Params = @{}

        if($FolderId)
        {
            $Params.Add('folder_id', $FolderId)
        }

        foreach($Connection in $ToProcess)
        {
            $Scans =  InvokeNessusRestRequest -SessionObject $Connection -Path '/scans' -Method 'Get' -Parameter $Params

            if ($Scans -is [psobject])
            {
                
                if($Status.length -gt 0)
                {
                    $Scans2Process = $Scans.scans | Where-Object {$_.status -eq $Status.ToLower()}
                }
                else
                {
                    $Scans2Process = $Scans.scans
                }
                foreach ($scan in $Scans2Process)
                {
                    $ScanProps = [ordered]@{}
                    $ScanProps.add('Name', $scan.name)
                    $ScanProps.add('ScanId', $scan.id)
                    $ScanProps.add('Status', $scan.status)
                    $ScanProps.add('Enabled', $scan.enabled)
                    $ScanProps.add('FolderId', $scan.folder_id)
                    $ScanProps.add('Owner', $scan.owner)
                    $ScanProps.add('UserPermission', $PermissionsId2Name[$scan.user_permissions])
                    $ScanProps.add('Rules', $scan.rrules)
                    $ScanProps.add('Shared', $scan.shared)
                    $ScanProps.add('TimeZone', $scan.timezone)
                    $ScanProps.add('CreationDate', $origin.AddSeconds($scan.creation_date).ToLocalTime())
                    $ScanProps.add('LastModified', $origin.AddSeconds($scan.last_modification_date).ToLocalTime())
                    $ScanProps.add('StartTime', $origin.AddSeconds($scan.starttime).ToLocalTime())
                    $ScanProps.Add('SessionId', $Connection.SessionId)
                    $ScanObj = New-Object -TypeName psobject -Property $ScanProps
                    $ScanObj.pstypenames[0] = 'Nessus.Scan'
                    $ScanObj
                }
            }
        }
    }
    End
    {
    }
}


<#
.Synopsis
   Short description
.DESCRIPTION
   Long description
.EXAMPLE
   Example of how to use this cmdlet
.EXAMPLE
   Another example of how to use this cmdlet
#>
function Export-NessusScan
{
    [CmdletBinding()]
    Param
    (
       # Nessus session Id
        [Parameter(Mandatory=$true,
                   Position=0,
                   ValueFromPipelineByPropertyName=$true)]
        [Alias('Index')]
        [int32[]]
        $SessionId = @(),

        [Parameter(Mandatory=$true,
                   Position=1,
                   ValueFromPipelineByPropertyName=$true)]
        [int32]
        $ScanId,

        [Parameter(Mandatory=$true,
                   Position=2,
                   ValueFromPipelineByPropertyName=$true)]
        [ValidateSet('Nessus', 'HTML', 'PDF', 'CSV', 'DB')]
        [string]
        $Format,

        [Parameter(Mandatory=$true,
                   ValueFromPipelineByPropertyName=$true)]
        [String]
        $OutFile,

        [Parameter(Mandatory=$false,
                   Position=3,
                   ValueFromPipelineByPropertyName=$true)]
        [ValidateSet('Vuln_Hosts_Summary', 'Vuln_By_Host', 
                     'Compliance_Exec', 'Remediations', 
                     'Vuln_By_Plugin', 'Compliance')]
        [string[]]
        $Chapters,

        [Parameter(Mandatory=$false,
                   Position=4,
                   ValueFromPipelineByPropertyName=$true)]
        [Int32]
        $HistoryID,

        [Parameter(Mandatory=$false,
                   ValueFromPipelineByPropertyName=$true)]
        [securestring]
        $Password

    )

    Begin
    {
    }
    Process
    {
        $ToProcess = @()

        foreach($i in $SessionId)
        {
            $Connections = $Global:NessusConn
            
            foreach($Connection in $Connections)
            {
                if ($Connection.SessionId -eq $i)
                {
                    $ToProcess += $Connection
                }
            }
        }

        $ExportParams = @{}

        if($Format -eq 'DB' -and $Password)
        {
            $Credentials = New-Object System.Management.Automation.PSCredential -ArgumentList 'user', $Password
            $ExportParams.Add('password', $Credentials.GetNetworkCredential().Password)
        }

        if($Format)
        {
            $ExportParams.Add('format', $Format.ToLower())
        }

        foreach($Connection in $ToProcess)
        {
            $path =  "/scans/$($ScanId)/export"
            Write-Verbose -Message "Exporting scan with Id of $($ScanId) in $($Format) format."
            $FileID = InvokeNessusRestRequest -SessionObject $Connections -Path $path  -Method 'Post' -Parameter $ExportParams
            if ($FileID -is [psobject])
            {
                $FileStatus = ''
                while ($FileStatus.status -ne 'ready')
                {
                    try
                    {
                        $FileStatus = InvokeNessusRestRequest -SessionObject $Connections -Path "/scans/$($ScanId)/export/$($FileID.file)/status"  -Method 'Get'
                        Write-Verbose -Message "Status of export is $($FileStatus.status)"
                    }
                    catch
                    {
                        break
                    }
                    Start-Sleep -Seconds 1
                }
                if ($FileStatus.status -eq 'ready')
                {
                    Write-Verbose -Message "Downloading report to $($OutFile)"
                    InvokeNessusRestRequest -SessionObject $Connections -Path "/scans/$($ScanId)/export/$($FileID.file)/download" -Method 'Get' -OutFile $OutFile
                }
            }
        }
    }
    End
    {
    }
}


<#
.Synopsis
   Short description
.DESCRIPTION
   Long description
.EXAMPLE
   Example of how to use this cmdlet
.EXAMPLE
   Another example of how to use this cmdlet
#>
function Show-NessusScanDetail
{
    [CmdletBinding()]
    Param
    (
        # Nessus session Id
        [Parameter(Mandatory=$true,
                   Position=0,
                   ValueFromPipelineByPropertyName=$true)]
        [Alias('Index')]
        [int32[]]
        $SessionId = @(),

        [Parameter(Mandatory=$true,
                   Position=1,
                   ValueFromPipelineByPropertyName=$true)]
        [int32]
        $ScanId,

        [Parameter(Mandatory=$false,
                   Position=2,
                   ValueFromPipelineByPropertyName=$true)]
        [Int32]
        $HistoryId 
    )

    Begin
    {
        $origin = New-Object -Type DateTime -ArgumentList 1970, 1, 1, 0, 0, 0, 0
    }
    Process
    {
        $ToProcess = @()

        foreach($i in $SessionId)
        {
            $Connections = $Global:NessusConn
            
            foreach($Connection in $Connections)
            {
                if ($Connection.SessionId -eq $i)
                {
                    $ToProcess += $Connection
                }
            }
        }
        $Params = @{}

        if($HistoryId)
        {
            $Params.Add('history_id', $HistoryId)
        }

        foreach($Connection in $ToProcess)
        {
            $ScanDetails =  InvokeNessusRestRequest -SessionObject $Connection -Path "/scans/$($ScanId)" -Method 'Get' -Parameter $Params

            if ($ScanDetails -is [psobject])
            {
                
                $ScanDetailProps = [ordered]@{}
                $hosts = @()
                $history = @()

                # Process Scan Info
                $ScanInfo = [ordered]@{}
                $ScanInfo.add('Name', $ScanDetails.info.name)
                $ScanInfo.add('ScanId', $ScanDetails.info.object_id)
                $ScanInfo.add('Status', $ScanDetails.info.status)
                $ScanInfo.add('UUID', $ScanDetails.info.uuid)
                $ScanInfo.add('Policy', $ScanDetails.info.policy)
                $ScanInfo.add('FolderId', $ScanDetails.info.folder_id)
                $ScanInfo.add('ScannerName', $ScanDetails.info.scanner_name)
                $ScanInfo.add('HostCount', $ScanDetails.info.hostcount)
                $ScanInfo.add('Targets', $ScanDetails.info.targets)
                $ScanInfo.add('AlternetTargetsUsed', $ScanDetails.info.alt_targets_used)
                $ScanInfo.add('HasAuditTrail', $ScanDetails.info.hasaudittrail)
                $ScanInfo.add('HasKb', $ScanDetails.info.haskb)
                $ScanInfo.add('ACL', $ScanDetails.info.acls)
                $ScanInfo.add('Permission', $PermissionsId2Name[$ScanDetails.info.user_permissions])
                $ScanInfo.add('EditAllowed', $ScanDetails.info.edit_allowed)
                $ScanInfo.add('LastModified', $origin.AddSeconds($ScanDetails.info.timestamp).ToLocalTime())
                $ScanInfo.add('ScanStart', $origin.AddSeconds($ScanDetails.info.scan_start).ToLocalTime())
                $ScanInfo.Add('SessionId', $Connection.SessionId)
                $InfoObj = New-Object -TypeName psobject -Property $ScanInfo
                $InfoObj.pstypenames[0] = 'Nessus.Scan.Info'


                # Process host info.
                foreach ($Host in $ScanDetails.hosts)
                {
                    $HostProps = [ordered]@{}
                    $HostProps.Add('HostName', $Host.hostname)
                    $HostProps.Add('HostId', $Host.host_id)
                    $HostProps.Add('Critical', $Host.critical)
                    $HostProps.Add('High',  $Host.high)
                    $HostProps.Add('Medium', $Host.medium)
                    $HostProps.Add('Low', $Host.low)
                    $HostProps.Add('Info', $Host.info)
                    $HostObj = New-Object -TypeName psobject -Property $HostProps
                    $HostObj.pstypenames[0] = 'Nessus.Scan.Host'
                    $hosts += $HostObj
                } 

                # Process hostory info.
                foreach ($History in $ScanDetails.history)
                {
                    $HistoryProps = [ordered]@{}
                    $HistoryProps['HistoryId'] = $History.history_id
                    $HistoryProps['UUID'] = $History.uuid
                    $HistoryProps['Status'] = $History.status
                    $HistoryProps['Type'] = $History.type
                    $HistoryProps['CreationDate'] = $origin.AddSeconds($History.creation_date).ToLocalTime()
                    $HistoryProps['LastModifiedDate'] = $origin.AddSeconds($History.last_modification_date).ToLocalTime()
                    $HistObj = New-Object -TypeName psobject -Property $HistoryProps
                    $HistObj.pstypenames[0] = 'Nessus.Scan.History'
                    $history += $HistObj
                }

                $ScanDetails
            }
        }
    }
    End{}
}


<#
.Synopsis
   Show details of a speific host on a scan in a Nessus server.
.DESCRIPTION
   Long description
.EXAMPLE
   Show-NessusScanHostDetail -SessionId 0 -ScanId 46 -HostId 31 | fl


    Info            : @{host_start=Tue Feb 24 06:32:45 2015; host-fqdn=fw1.darkoperator.com; 
                       host_end=Tue Feb 24 06:35:52 2015; operating-system=FreeBSD 8.3-RELEASE-p16 
                      (i386); host-ip=192.168.1.1}
    Vulnerabilities : {@{count=1; hostname=192.168.1.1; plugin_name=Nessus Scan Information; vuln_index=0; 
                      severity=0; plugin_id=19506; severity_index=0; plugin_family=Settings; host_id=31}, 
                      @{count=3; hostname=192.168.1.1; plugin_name=Nessus SYN scanner; vuln_index=1; severity=0; 
                      plugin_id=11219; 
                      severity_index=1; plugin_family=Port scanners; host_id=31}, @{count=1;
                      hostname=192.168.1.1; plugin_name=Unsupported Unix Operating System; 
                      vuln_index=2; severity=4; plugin_id=33850; severity_index=2; 
                      plugin_family=General; host_id=31}}
    Compliance      : {}
#>
function Show-NessusScanHostDetail
{
    [CmdletBinding()]
    Param
    (
        # Nessus session Id
        [Parameter(Mandatory=$true,
                   Position=0,
                   ValueFromPipelineByPropertyName=$true)]
        [Alias('Index')]
        [int32[]]
        $SessionId = @(),

        [Parameter(Mandatory=$true,
                   Position=1,
                   ValueFromPipelineByPropertyName=$true)]
        [int32]
        $ScanId,

        [Parameter(Mandatory=$true,
                   Position=2,
                   ValueFromPipelineByPropertyName=$true)]
        [int32]
        $HostId,

        [Parameter(Mandatory=$false,
                   Position=3,
                   ValueFromPipelineByPropertyName=$true)]
        [Int32]
        $HistoryId 
    )

    Begin{}
    Process
    {
        $ToProcess = @()

        foreach($i in $SessionId)
        {
            $Connections = $Global:NessusConn
            
            foreach($Connection in $Connections)
            {
                if ($Connection.SessionId -eq $i)
                {
                    $ToProcess += $Connection
                }
            }
        }
        $Params = @{}

        if($HistoryId)
        {
            $Params.Add('history_id', $HistoryId)
        }

        foreach($Connection in $ToProcess)
        {
            $ScanDetails =  InvokeNessusRestRequest -SessionObject $Connection -Path "/scans/$($ScanId)/hosts/$($HostId)" -Method 'Get' -Parameter $Params

            if ($ScanDetails -is [psobject])
            {                
                $HostProps = [ordered]@{}
                $HostProps.Add('Info', $ScanDetails.info)
                $HostProps.Add('Vulnerabilities', $ScanDetails.vulnerabilities)
                $HostProps.Add('Compliance', $ScanDetails.compliance)
                $HostProps.Add('ScanId', $ScanId)
                $HostProps.Add('SessionId', $Connection.SessionId)
                $HostObj = New-Object -TypeName psobject -Property $HostProps
                $HostObj.pstypenames[0] = 'Nessus.Scan.HostDetails'
                $HostObj             
            }
        }
    }
    End{}
}


<#
.Synopsis
   Show the hosts present in a specific scan on a Nessus server.
.DESCRIPTION
   Show the hosts present in a specific scan on a Nessus server. The number
   of vulnerabilities found per severity.
.EXAMPLE
   Show-NessusScanHost -SessionId 0 -ScanId 46


    HostName : 192.168.1.253
    HostId   : 252
    Critical : 0
    High     : 1
    Medium   : 0
    Low      : 0
    Info     : 3

    HostName : 192.168.1.250
    HostId   : 251
    Critical : 0
    High     : 2
    Medium   : 0
    Low      : 0
    Info     : 3

    HostName : 192.168.1.242
    HostId   : 244
    Critical : 0
    High     : 0
    Medium   : 1
    Low      : 0
    Info     : 40

    HostName : 192.168.1.223
    HostId   : 225
    Critical : 0
    High     : 0
    Medium   : 0
    Low      : 0
    Info     : 6

    HostName : 192.168.1.218
    HostId   : 219
    Critical : 0
    High     : 0
    Medium   : 0
    Low      : 0
    Info     : 2

    HostName : 192.168.1.217
    HostId   : 221
    Critical : 0
    High     : 0
    Medium   : 0
    Low      : 0
    Info     : 4
#>
function Show-NessusScanHost
{
    [CmdletBinding()]
    Param
    (
        # Nessus session Id
        [Parameter(Mandatory=$true,
                   Position=0,
                   ValueFromPipelineByPropertyName=$true)]
        [Alias('Index')]
        [int32[]]
        $SessionId = @(),

        [Parameter(Mandatory=$true,
                   Position=1,
                   ValueFromPipelineByPropertyName=$true)]
        [int32]
        $ScanId,

        [Parameter(Mandatory=$false,
                   Position=2,
                   ValueFromPipelineByPropertyName=$true)]
        [Int32]
        $HistoryId 
    )

    Begin{}
    Process
    {
        $ToProcess = @()

        foreach($i in $SessionId)
        {
            $Connections = $Global:NessusConn
            
            foreach($Connection in $Connections)
            {
                if ($Connection.SessionId -eq $i)
                {
                    $ToProcess += $Connection
                }
            }
        }
        $Params = @{}

        if($HistoryId)
        {
            $Params.Add('history_id', $HistoryId)
        }

        foreach($Connection in $ToProcess)
        {
            $ScanDetails =  InvokeNessusRestRequest -SessionObject $Connection -Path "/scans/$($ScanId)" -Method 'Get' -Parameter $Params

            if ($ScanDetails -is [psobject])
            {
                foreach ($Host in $ScanDetails.hosts)
                {
                    $HostProps = [ordered]@{}
                    $HostProps.Add('HostName', $Host.hostname)
                    $HostProps.Add('HostId', $Host.host_id)
                    $HostProps.Add('Critical', $Host.critical)
                    $HostProps.Add('High',  $Host.high)
                    $HostProps.Add('Medium', $Host.medium)
                    $HostProps.Add('Low', $Host.low)
                    $HostProps.Add('Info', $Host.info)
                    $HostProps.Add('ScanId', $ScanId)
                    $HostProps.Add('SessionId', $Connection.SessionId)
                    $HostObj = New-Object -TypeName psobject -Property $HostProps
                    $HostObj.pstypenames[0] = 'Nessus.Scan.Host'
                    $HostObj
                } 
            }
        }
    }
    End{}
}


<#
.Synopsis
   Shows the history of times ran for a specific scan in a Nessus server.
.DESCRIPTION
   Shows the history of times ran for a specific scan in a Nessus server.
.EXAMPLE
   Show-NessusScanHistory -SessionId 0 -ScanId 46


    HistoryId        : 47
    UUID             : 909d61c2-5f6d-605d-6e4d-79739bbe1477dd85043154a6077f
    Status           : completed
    Type             : local
    CreationDate     : 2/24/2015 2:52:35 AM
    LastModifiedDate : 2/24/2015 5:57:33 AM

    HistoryId        : 48
    UUID             : e8df16c4-390c-b4d8-0ae5-ea7c48867bd57618d7bd96b32122
    Status           : canceled
    Type             : local
    CreationDate     : 2/24/2015 6:17:11 AM
    LastModifiedDate : 2/24/2015 6:27:20 AM

    HistoryId        : 49
    UUID             : e933c0be-3b16-5a44-be32-b17e32f2a2e6f7be26c34082817a
    Status           : canceled
    Type             : local
    CreationDate     : 2/24/2015 6:31:52 AM
    LastModifiedDate : 2/24/2015 6:32:43 AM

    HistoryId        : 50
    UUID             : 484d03b9-3196-4cc7-6567-4e99d8cc0e949924ccfb6ce4af3d
    Status           : completed
    Type             : local
    CreationDate     : 2/24/2015 6:32:45 AM
    LastModifiedDate : 2/24/2015 6:46:20 AM
#>
function Show-NessusScanHistory
{
    [CmdletBinding()]
    Param
    (
        # Nessus session Id
        [Parameter(Mandatory=$true,
                   Position=0,
                   ValueFromPipelineByPropertyName=$true)]
        [Alias('Index')]
        [int32[]]
        $SessionId = @(),

        [Parameter(Mandatory=$true,
                   Position=1,
                   ValueFromPipelineByPropertyName=$true)]
        [int32]
        $ScanId
    )

    Begin
    {
        $origin = New-Object -Type DateTime -ArgumentList 1970, 1, 1, 0, 0, 0, 0
    }
    Process
    {
        $ToProcess = @()

        foreach($i in $SessionId)
        {
            $Connections = $Global:NessusConn
            
            foreach($Connection in $Connections)
            {
                if ($Connection.SessionId -eq $i)
                {
                    $ToProcess += $Connection
                }
            }
        }
        $Params = @{}

        if($HistoryId)
        {
            $Params.Add('history_id', $HistoryId)
        }

        foreach($Connection in $ToProcess)
        {
            $ScanDetails =  InvokeNessusRestRequest -SessionObject $Connection -Path "/scans/$($ScanId)" -Method 'Get' -Parameter $Params

            if ($ScanDetails -is [psobject])
            {
                foreach ($History in $ScanDetails.history)
                {
                    $HistoryProps = [ordered]@{}
                    $HistoryProps['HistoryId'] = $History.history_id
                    $HistoryProps['UUID'] = $History.uuid
                    $HistoryProps['Status'] = $History.status
                    $HistoryProps['Type'] = $History.type
                    $HistoryProps['CreationDate'] = $origin.AddSeconds($History.creation_date).ToLocalTime()
                    $HistoryProps['LastModifiedDate'] = $origin.AddSeconds($History.last_modification_date).ToLocalTime()
                    $HistoryProps['SessionId'] = $Connection.SessionId
                    $HistObj = New-Object -TypeName psobject -Property $HistoryProps
                    $HistObj.pstypenames[0] = 'Nessus.Scan.History'
                    $HistObj
                } 
            }
        }
    }
    End{}
}


<#
.Synopsis
   Deletes a scan result from a Nessus server.
.DESCRIPTION
   Deletes a scan result from a Nessus server.
.EXAMPLE
    Get-NessusScan -SessionId 0 -Status Imported | Remove-NessusScan -SessionId 0 -Verbose
    VERBOSE: Removing scan with Id 45
    VERBOSE: DELETE https://192.168.1.211:8834/scans/45 with 0-byte payload
    VERBOSE: received 4-byte response of content type application/json
    VERBOSE: Scan Removed
    VERBOSE: Removing scan with Id 41
    VERBOSE: DELETE https://192.168.1.211:8834/scans/41 with 0-byte payload
    VERBOSE: received 4-byte response of content type application/json
    VERBOSE: Scan Removed
    VERBOSE: Removing scan with Id 39
    VERBOSE: DELETE https://192.168.1.211:8834/scans/39 with 0-byte payload
    VERBOSE: received 4-byte response of content type application/json
    VERBOSE: Scan Removed
    VERBOSE: Removing scan with Id 37
    VERBOSE: DELETE https://192.168.1.211:8834/scans/37 with 0-byte payload
    VERBOSE: received 4-byte response of content type application/json
    VERBOSE: Scan Removed
    VERBOSE: Removing scan with Id 7
    VERBOSE: DELETE https://192.168.1.211:8834/scans/7 with 0-byte payload
    VERBOSE: received 4-byte response of content type application/json
    VERBOSE: Scan Removed
    VERBOSE: Removing scan with Id 5
    VERBOSE: DELETE https://192.168.1.211:8834/scans/5 with 0-byte payload
    VERBOSE: received 4-byte response of content type application/json
    VERBOSE: Scan Removed
#>
function Remove-NessusScan
{
    [CmdletBinding()]
    Param
    (
        # Nessus session Id
        [Parameter(Mandatory=$true,
                   Position=0,
                   ValueFromPipelineByPropertyName=$true)]
        [Alias('Index')]
        [int32[]]
        $SessionId = @(),

        [Parameter(Mandatory=$true,
                   Position=1,
                   ValueFromPipelineByPropertyName=$true)]
        [int32]
        $ScanId
    )

    Begin{}
    Process
    {
        $ToProcess = @()

        foreach($i in $SessionId)
        {
            $Connections = $Global:NessusConn
            
            foreach($Connection in $Connections)
            {
                if ($Connection.SessionId -eq $i)
                {
                    $ToProcess += $Connection
                }
            }
        }

        foreach($Connection in $ToProcess)
        {
            Write-Verbose -Message "Removing scan with Id $($ScanId)"
            
            $ScanDetails =  InvokeNessusRestRequest -SessionObject $Connection -Path "/scans/$($ScanId)" -Method 'Delete' -Parameter $Params
            if ($ScanDetails -eq 'null')
            {
                Write-Verbose -Message 'Scan Removed'
            }
            
            
        }
    }
    End{}
}


<#
.Synopsis
   Short description
.DESCRIPTION
   Long description
.EXAMPLE
   Example of how to use this cmdlet
.EXAMPLE
   Another example of how to use this cmdlet
#>
function Import-NessusScan
{
    [CmdletBinding()]
    Param
    (
        # Nessus session Id
        [Parameter(Mandatory=$true,
                   Position=0,
                   ValueFromPipelineByPropertyName=$true)]
        [Alias('Index')]
        [int32[]]
        $SessionId = @(),

        [Parameter(Mandatory=$true,
                   Position=1,
                   ValueFromPipelineByPropertyName=$true)]
        [ValidateScript({Test-Path -Path $_})]
        [string]
        $File,

        [Parameter(Mandatory=$false,
                   Position=2,
                   ValueFromPipelineByPropertyName=$true)]
        [switch]
        $Encrypted,

        [Parameter(Mandatory=$false,
                   ValueFromPipelineByPropertyName=$true)]
        [securestring]
        $Password
    )

    Begin
    {
        Write-Warning -Message "This function does not work at this moment."
        if($Encrypted)
        {
            $ContentType = 'application/octet-stream'
            $URIPath = '/file/upload?no_enc=1'
        }
        else
        {
            $ContentType = 'application/octet-stream'
            $URIPath = '/file/upload'
        }
    }
    Process
    {
        $ToProcess = @()

        foreach($i in $SessionId)
        {
            $Connections = $Global:NessusConn
            
            foreach($Connection in $Connections)
            {
                if ($Connection.SessionId -eq $i)
                {
                    $ToProcess += $Connection
                }
            }
        }

        foreach($Connection in $ToProcess)
        {
            $fileinfo = Get-ItemProperty -Path $File
            $req = [System.Net.WebRequest]::Create("$($Connection.uri)$($URIPath)")
            $req.Method = 'POST'
            $req.AllowWriteStreamBuffering = $true
            $req.SendChunked = $false
            $req.KeepAlive = $true
            

            # Set the proper headers.
            $headers = New-Object -TypeName System.Net.WebHeaderCollection
            $req.Headers = $headers
            # Prep the POST Headers for the message
            $req.Headers.Add('X-Cookie',"token=$($connection.token)")
            $req.Headers.Add('X-Requested-With','XMLHttpRequest')
            $req.Headers.Add('Accept-Language: en-US')
            #$req.Headers.Add('Accept-Encoding: gzip,deflate')
            $req.UserAgent = "Mozilla/5.0 (Windows NT 6.3; WOW64; Trident/7.0; Touch; rv:11.0) like Gecko')"
            $boundary = '------' + [DateTime]::Now.Ticks.ToString('x')
            $req.ContentType = 'multipart/form-data; boundary=' + $boundary
            [byte[]]$boundarybytes = [System.Text.Encoding]::UTF8.GetBytes($boundary + "`r`n")
            [string]$formdataTemplate = '--' + $boundary 
            [string]$formitem = [string]::Format($formdataTemplate, 'Filename', $fileinfo.name)
            [byte[]]$formitembytes = [System.Text.Encoding]::UTF8.GetBytes($formitem)
            
            # Headder
            [string]$headerTemplate = "Content-Disposition: form-data; name=`"{0}`"; filename=`"{1}`"`r`nContent-Type: $($ContentType)`r`n`r`n"
            [string]$header = [string]::Format($headerTemplate, 'Filedata', (get-item $file).name)
            [byte[]]$headerbytes = [System.Text.Encoding]::UTF8.GetBytes($header)

            # Footer
            [string]$footerTemplate = "`r`n" + $boundary + '--'
            [byte[]]$footerBytes = [System.Text.Encoding]::UTF8.GetBytes($footerTemplate)


            # Read the file and format the message
            $stream = $req.GetRequestStream()
            $rdr = new-object System.IO.FileStream($fileinfo.FullName, [System.IO.FileMode]::Open, [System.IO.FileAccess]::Read)
            [byte[]]$buffer = new-object byte[] $rdr.Length
            [int]$total = [int]$count = 0
            $stream.Write($boundarybytes, 0, $boundarybytes.Length)
            $stream.Write($headerbytes, 0,$headerbytes.Length)
            $count = $rdr.Read($buffer, 0, $buffer.Length)
            do{
                $stream.Write($buffer, 0, $count)
                $count = $rdr.Read($buffer, 0, $buffer.Length)
            }while ($count > 0)
            $stream.Write($footerBytes, 0, $footerBytes.Length)
            $stream.close()

            try
            {
                # Upload the file
                $response = $req.GetResponse()

                # Read the response
                $respstream = $response.GetResponseStream()
                $sr = new-object System.IO.StreamReader $respstream
                $result = $sr.ReadToEnd()
                $sr.Close()
                #$result.gettype()
                #$UploadName = ConvertFrom-Json -InputObject $result
                
           }
           catch
           {
                throw $_
           }


            $RestParams = New-Object -TypeName System.Collections.Specialized.OrderedDictionary
            $RestParams.add('file', "$()")
            if ($Encrypted)
            {
                $Credentials = New-Object System.Management.Automation.PSCredential -ArgumentList 'user', $Password
                $RestParams.Add('password', $Credentials.GetNetworkCredential().Password)
            }

            $impParams = @{

                
                'Body' = $RestParams
                }
                Invoke-RestMethod -Method Post -Uri "$($Connection.URI)/scans/import" -header @{'X-Cookie' = "token=$($Connection.Token)"} -Body (ConvertTo-Json @{'file' = $fileinfo.name;} -Compress) -ContentType 'application/json'
               # InvokeNessusRestRequest -SessionObject $Connection -Path '/scans/import' -Method 'Post' -Parameter $RestParams
            
        }
    }
    End{}
}

<#
.Synopsis
   Get all scan templates available on a Nessus server.
.DESCRIPTION
   Get all scan templates available on a Nessus server.
.EXAMPLE
   Get-NessusScanTemplate -SessionId 0
#>
function Get-NessusScanTemplate
{
    [CmdletBinding()]
    Param
    (
        # Nessus session Id
        [Parameter(Mandatory=$true,
                   Position=0,
                   ValueFromPipelineByPropertyName=$true)]
        [Alias('Index')]
        [int32[]]
        $SessionId = @()

    )

    Begin
    {
    }
    Process
    {
        $ToProcess = @()

        foreach($i in $SessionId)
        {
            $Connections = $Global:NessusConn
            
            foreach($Connection in $Connections)
            {
                if ($Connection.SessionId -eq $i)
                {
                    $ToProcess += $Connection
                }
            }
        }

        foreach($Connection in $ToProcess)
        {
            $Templates =  InvokeNessusRestRequest -SessionObject $Connection -Path '/editor/scan/templates' -Method 'Get'

            if ($Templates -is [psobject])
            {
                foreach($Template in $Templates.templates)
                {
                    $TmplProps = [ordered]@{}
                    $TmplProps.add('Name', $Template.name)
                    $TmplProps.add('Title', $Template.title)
                    $TmplProps.add('Description', $Template.desc)
                    $TmplProps.add('UUID', $Template.uuid)
                    $TmplProps.add('CloudOnly', $Template.cloud_only)
                    $TmplProps.add('SubscriptionOnly', $Template.subscription_only)
                    $TmplProps.add('SessionId', $Connection.SessionId)
                    $Tmplobj = New-Object -TypeName psobject -Property $TmplProps
                    $Tmplobj.pstypenames[0] = 'Nessus.ScanTemplate'
                    $Tmplobj
                }
            }
        }
    }
    End
    {
    }
}
#endregion