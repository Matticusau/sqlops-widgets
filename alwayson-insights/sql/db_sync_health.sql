-- 
-- Author: Matticusau
-- Purpose: Provides summary data for the AlwaysOn DB Sync Insights Widget
-- License: https://github.com/Matticusau/sqlops-widgets/blob/master/LICENSE
-- 
DECLARE @totalReplicaCnt INT = (
    SELECT COUNT(ar.replica_server_name)
    FROM sys.databases d
    INNER JOIN sys.dm_hadr_database_replica_states drs ON drs.database_id = d.database_id
    INNER JOIN sys.availability_groups ag ON ag.group_id = drs.group_id
    INNER JOIN sys.availability_replicas ar ON ar.replica_id = drs.replica_id
    WHERE d.database_id = DB_ID()
)
--SELECT @totalReplicaCnt
SELECT drs.synchronization_health_desc
    --, Count(connected_state_desc) [replica_count]
    , CONVERT( DECIMAL(5,2), ((Count(drs.synchronization_health_desc) * 1.0 / @totalReplicaCnt) * 100))  [replica_percent]
FROM sys.databases d
INNER JOIN sys.dm_hadr_database_replica_states drs ON drs.database_id = d.database_id
INNER JOIN sys.availability_groups ag ON ag.group_id = drs.group_id
INNER JOIN sys.availability_replicas ar ON ar.replica_id = drs.replica_id
WHERE d.database_id = DB_ID()
GROUP BY drs.synchronization_health_desc
ORDER BY drs.synchronization_health_desc
