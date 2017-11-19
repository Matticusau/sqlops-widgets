-- 
-- Author: Matticusau
-- Purpose: Provides summary data for the Replica Health Insights Widget
-- 
DECLARE @totalReplicaCnt INT = (
    SELECT Count(connected_state_desc)
    FROM sys.availability_groups ag
    INNER JOIN sys.dm_hadr_availability_replica_states ars ON ars.group_id = ag.group_id
    INNER JOIN sys.availability_replicas ar ON ar.replica_id = ars.replica_id
)
--SELECT @totalReplicaCnt
SELECT ars.connected_state_desc
    --, Count(connected_state_desc) [replica_count]
    , CONVERT( DECIMAL(5,2), ((Count(connected_state_desc) * 1.0 / @totalReplicaCnt) * 100))  [replica_percent]
FROM sys.availability_groups ag
INNER JOIN sys.dm_hadr_availability_replica_states ars ON ars.group_id = ag.group_id
INNER JOIN sys.availability_replicas ar ON ar.replica_id = ars.replica_id
--WHERE ars.connected_state_desc = 'DISCONNECTED'
GROUP BY ars.connected_state_desc
ORDER BY ars.connected_state_desc