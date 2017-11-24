-- 
-- Author: Matticusau
-- Purpose: Provides summary data for the DB Space Used Insights Widget
-- 
SELECT type_desc
    -- , CONVERT(decimal(18,2), SUM(size)/128.0) [file_size_mb]
    -- , CONVERT(decimal(18,2), SUM(max_size)/128.0) [max_growth_size_mb]
    -- , CONVERT(decimal(18,2), SUM(FILEPROPERTY(name, 'SpaceUsed'))/128.0) [used_space_mb]
    -- , CONVERT(decimal(18,2), SUM(size)/128.0) - CONVERT(decimal(18,2), SUM(FILEPROPERTY(name,'SpaceUsed'))/128.0) AS [free_space_mb] 
    , CONVERT(decimal(18,2), (SUM(FILEPROPERTY(name, 'SpaceUsed'))/128.0) / (SUM(size)/128.0) * 100) [used_space_percent]
    , 100 - CONVERT(decimal(18,2), (SUM(FILEPROPERTY(name, 'SpaceUsed'))/128.0) / (SUM(size)/128.0) * 100) AS [free_space_percent] 
FROM sys.database_files
WHERE type_desc IN ('ROWS','LOG')
GROUP BY type_desc
ORDER BY type_desc