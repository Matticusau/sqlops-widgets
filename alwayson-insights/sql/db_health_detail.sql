-- 
-- Author: Matticusau
-- Purpose: Provides detailed data for the AG Database Health Insights Widget
-- 
SELECT d.name [database_name]
    , ag.name [group_name]
    , ar.replica_server_name
    , drs.is_primary_replica
    , drs.synchronization_state_desc
    , drs.synchronization_health_desc
    , drs.database_state_desc
    , drs.suspend_reason_desc
    , ar.availability_mode_desc
    , ar.failover_mode_desc
    -- ADD latency info
    -- Estimated Failover Time = tDetection + tRedo + tOverhead
    , ag.health_check_timeout + (drs.redo_queue_size / NULLIF(drs.redo_rate,0)) [estimated_recovery_time]
    , (drs.log_send_queue_size / NULLIF(drs.log_send_rate,0)) [estimated_data_loss]
    -- , drs.redo_queue_size
    -- , drs.redo_rate
    -- , drs.log_send_queue_size
    -- , drs.log_send_rate
from sys.databases d
INNER JOIN sys.dm_hadr_database_replica_states drs ON drs.database_id = d.database_id
INNER JOIN sys.availability_groups ag ON ag.group_id = drs.group_id
INNER JOIN sys.availability_replicas ar ON ar.replica_id = drs.replica_id
WHERE d.database_id = DB_ID()