-- 
-- Author: Matticusau
-- Purpose: Provides general System performance data from Extended Events System Health Session
-- License: https://github.com/Matticusau/sqlops-widgets/blob/master/LICENSE
-- Credit to: https://troubleshootingsql.com/2013/08/02/powerview-and-system-health-session-system/
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
        EventXML.value('(/event/data/value/system/@latchWarnings)[1]','bigint') as [Latch Warnings],
        EventXML.value('(/event/data/value/system/@isAccessViolationOccurred)[1]','bigint') as [Access Violations],
        EventXML.value('(/event/data/value/system/@nonYieldingTasksReported)[1]','bigint') as [Non Yields Reported],
        EventXML.value('(/event/data/value/system/@BadPagesDetected)[1]','bigint') as [Bad Pages Detected],
        EventXML.value('(/event/data/value/system/@BadPagesFixed)[1]','bigint') as [Bad Pages Fixed]
    FROM CTE_HealthSession
    WHERE EventXML.value('(/event/@name)[1]', 'varchar(255)') = 'sp_server_diagnostics_component_result'
    AND EventXML.value('(/event/data/text)[1]','varchar(255)') = 'SYSTEM'
    AND DATEADD(mi,@UTCDateDiff,EventXML.value('(/event/@timestamp)[1]','datetime')) >= DATEADD(mi, -240, GETUTCDATE())
    ORDER BY [Event Time];

    -- Clean Up
    DROP TABLE #SystemHealthSessionData
 
END