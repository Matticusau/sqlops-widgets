-- 
-- Author: Matticusau
-- Purpose: Provides summary data for the AlwaysOn DB RPO RTO Insights Widget
-- License: https://github.com/Matticusau/sqlops-widgets/blob/master/LICENSE
-- 
SELECT ar.replica_server_name [replica_name]
    , ag.health_check_timeout + (drs.redo_queue_size / NULLIF(drs.redo_rate,0)) [estimated_recovery_time]
    , (drs.log_send_queue_size / NULLIF(drs.log_send_rate,0)) [estimated_data_loss]
from sys.databases d
INNER JOIN sys.dm_hadr_database_replica_states drs ON drs.database_id = d.database_id
INNER JOIN sys.availability_groups ag ON ag.group_id = drs.group_id
INNER JOIN sys.availability_replicas ar ON ar.replica_id = drs.replica_id
WHERE d.database_id = DB_ID()
