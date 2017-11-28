# MSSQL-Instance-Insights widget

This collection of widgets are designed to provide insights into MSSQL Instance to further extend the built-in default widgets.

Where possible all of these widgets will include more detail when you click *_Show Details_* from the widget menu.

![Show details](../docs/images/show-detail.png)

## Supported SQL Server Versions

These widgets have been tested against the following SQL Server versions:

* SQL Server 2016
* SQL Server 2017 (Windows & linux)

If you find any issues using these widgets on these supported SQL Server versions, or any other versions please create an issue as we would like to make these available for as many releases as possible.

***We are looking for testers to confirm other environments.*** So if you find they do work on other releases let me know, and credit will be given.

## mssql-instance-waits

This Server Dashboard widget includes information on the top 10 waits for the SQL Instance. Information will be shown in the form of a bar chart.

![mssql-instance-waits.png](../docs/images/mssql-instance-insights/mssql-instance-waits.png)

You can access more information about the waits in the detailed fly-out displayed when you select "..." on the widget.

![mssql-instance-waits-details.png](../docs/images/mssql-instance-insights/mssql-instance-waits-details.png)

Credit for the query this widget is based on goes to [Paul Randal - Tell me where it hurts](https://www.sqlskills.com/blogs/paul/wait-statistics-or-please-tell-me-where-it-hurts/)

To enable this widget add the following json to either your user or workspace settings in the *dashboard.server.widgets* section.

```json
{
    "name": "Top 10 Waits",
    "widget": {
        "mssql-instance-waits": null
    }
}
```

## mssql-instance-xelsystem

This Server Dashboard widget includes information on the general system performance captured by the Extended Events System Health Session for the SQL Instance. Information will be shown in the form of a line chart. If the System Health Session is stopped or the instance has been restarted will affect the amount of data available for this widget.

![mssql-instance-xelsystem.png](../docs/images/mssql-instance-insights/mssql-instance-xelsystem.png)

You can access more information in the detailed fly-out displayed when you select "..." on the widget.

![mssql-instance-xelsystem-details.png](../docs/images/mssql-instance-insights/mssql-instance-xelsystem-details.png)

Credit for the query this widget is based on goes to [troubleshootingsql.com](https://troubleshootingsql.com/2013/08/02/powerview-and-system-health-session-system/)

> This widget is not currently supported on *_Azure SQL DB_* due to lack of support for Extended Events.

To enable this widget add the following json to either your user or workspace settings in the *dashboard.server.widgets* section.

```json
{
    "name": "XEL System Stats",
    "widget": {
        "mssql-instance-xelsystem": null
    }
}
```

## mssql-instance-xelio

This Server Dashboard widget includes information on the IO performance captured by the Extended Events System Health Session for the SQL Instance. Information will be shown in the form of a line chart. If the System Health Session is stopped or the instance has been restarted will affect the amount of data available for this widget.

![mssql-instance-xelio.png](../docs/images/mssql-instance-insights/mssql-instance-xelio.png)

You can access more information in the detailed fly-out displayed when you select "..." on the widget.

![mssql-instance-xelio-details.png](../docs/images/mssql-instance-insights/mssql-instance-xelio-details.png)

Credit for the query this widget is based on goes to [troubleshootingsql.com](https://troubleshootingsql.com/2013/07/25/powerview-and-system-health-session-io-health/)

> This widget is not currently supported on *_Azure SQL DB_* due to lack of support for Extended Events.

To enable this widget add the following json to either your user or workspace settings in the *dashboard.server.widgets* section.

```json
{
    "name": "XEL IO Stats",
    "widget": {
        "mssql-instance-xelio": null
    }
}
```

## mssql-instance-xelmemory

This Server Dashboard widget includes information on the Memory performance captured by the Extended Events System Health Session for the SQL Instance. Information will be shown in the form of a line chart. If the System Health Session is stopped or the instance has been restarted will affect the amount of data available for this widget.

![mssql-instance-xelmemory.png](../docs/images/mssql-instance-insights/mssql-instance-xelmemory.png)

You can access more information in the detailed fly-out displayed when you select "..." on the widget.

![mssql-instance-xelmemory-details.png](../docs/images/mssql-instance-insights/mssql-instance-xelmemory-details.png)

Credit for the query this widget is based on goes to [troubleshootingsql.com](https://troubleshootingsql.com/2013/07/19/powerview-and-system-health-sessionsql-memory-health/)

> This widget is not currently supported on *_Azure SQL DB_* due to lack of support for Extended Events.

To enable this widget add the following json to either your user or workspace settings in the *dashboard.server.widgets* section.

```json
{
    "name": "XEL Memory Stats",
    "widget": {
        "mssql-instance-xelmemory": null
    }
}
```