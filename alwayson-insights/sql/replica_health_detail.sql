-- 
-- Author: Matticusau
-- Purpose: Provides detailed data for the Replica Health Insights Widget
-- 
SELECT ag.name [ag_name]
    , ar.replica_server_name
    , ars.role_desc
    , ars.operational_state
    , ars.connected_state_desc
    , ars.synchronization_health_desc
FROM sys.availability_groups ag
INNER JOIN sys.dm_hadr_availability_replica_states ars ON ars.group_id = ag.group_id
INNER JOIN sys.availability_replicas ar ON ar.replica_id = ars.replica_id
ORDER BY ag_name, replica_server_name