-- 
-- Author: Matticusau
-- Purpose: Provides detailed data for the DB Space Used Insights Widget
-- 
SELECT file_id
    , name [file_name]
    , type_desc
    , physical_name
    , CONVERT(decimal(18,2), size/128.0) [file_size_mb]
    , CONVERT(decimal(18,2), max_size/128.0) [max_growth_size_mb]
    , CONVERT(decimal(18,2), FILEPROPERTY(name, 'SpaceUsed')/128.0) [used_space_mb]
    , CONVERT(decimal(18,2), size/128.0) - CONVERT(decimal(18,2), FILEPROPERTY(name,'SpaceUsed')/128.0) AS [free_space_mb] 
    , CONVERT(decimal(18,2), (FILEPROPERTY(name, 'SpaceUsed')/128.0) / (size/128.0) * 100) [used_space_percent]
    , 100 - CONVERT(decimal(18,2), (FILEPROPERTY(name, 'SpaceUsed')/128.0) / (size/128.0) * 100) AS [free_space_percent] 
FROM sys.database_files
ORDER BY type_desc
    , file_id