-- 
-- Author: Matticusau
-- Purpose: Provides IO performance data from Extended Events System Health Session
-- License: https://github.com/Matticusau/sqlops-widgets/blob/master/LICENSE
-- Credit to: https://troubleshootingsql.com/2013/07/25/powerview-and-system-health-session-io-health/
-- 
SET NOCOUNT ON
-- Fetch data only if SQL 2012 or higher (Extended Events schema changed between 2008 R2 and 2012)
IF (SUBSTRING(CAST(SERVERPROPERTY ('ProductVersion') AS varchar(50)),1,CHARINDEX('.',CAST(SERVERPROPERTY ('ProductVersion') AS varchar(50)))-1) >= 11)
BEGIN
    -- Get UTC time difference for reporting event times local to server time
    DECLARE @UTCDateDiff int = DATEDIFF(mi,GETUTCDATE(),GETDATE());
    
    -- Store XML data retrieved in temp table
    SELECT TOP 1 CAST(xet.target_data AS XML) AS XMLDATA
    INTO #SystemHealthSessionData
    FROM sys.dm_xe_session_targets xet
    JOIN sys.dm_xe_sessions xe ON (xe.address = xet.event_session_address)
    WHERE xe.name = 'system_health'
    AND xet.target_name = 'ring_buffer';
 
    -- Parse XML data and provide required values in the form of a table
    ;WITH CTE_HealthSession (EventXML) AS
    (
        SELECT C.query('.') EventXML
        FROM #SystemHealthSessionData a
        CROSS APPLY a.XMLDATA.nodes('/RingBufferTarget/event') as T(C)
    )
    SELECT
        DATEADD(mi,@UTCDateDiff,EventXML.value('(/event/@timestamp)[1]','datetime')) as [Event Time],
        EventXML.value('(/event/data/text)[1]','varchar(255)') as Component,
        EventXML.value('(/event/data/value/ioSubsystem/@ioLatchTimeouts)[1]','bigint') as [IO Latch Timeouts],
        EventXML.value('(/event/data/value/ioSubsystem/@totalLongIos)[1]','bigint') as [Total Long IOs],
        ISNULL(EventXML.value('(/event/data/value/ioSubsystem/longestPendingRequests/pendingRequest/@filePath)[1]','varchar(8000)'),'') as [Longest Pending Request File],
        ISNULL(EventXML.value('(/event/data/value/ioSubsystem/longestPendingRequests/pendingRequest/@duration)[1]','bigint'),0) as [Longest Pending IO Duration]
    FROM CTE_HealthSession
    WHERE EventXML.value('(/event/@name)[1]', 'varchar(255)') = 'sp_server_diagnostics_component_result'
    AND EventXML.value('(/event/data/text)[1]','varchar(255)') = 'IO_SUBSYSTEM'
    AND DATEADD(mi,@UTCDateDiff,EventXML.value('(/event/@timestamp)[1]','datetime')) >= DATEADD(mi, -240, GETUTCDATE())
    ORDER BY [Event Time];

    -- Clean up
    DROP TABLE #SystemHealthSessionData

END