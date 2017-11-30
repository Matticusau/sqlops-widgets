# AlwaysOn-Insights widget

This collection of widgets are designed to provide insights into AlwaysOn Availability Group components to assist DBA's or similar in managing their environment.

Where possible all of these widgets will include more detail when you click *_Show Details_* from the widget menu.

![Show details](../docs/images/show-detail.png)

## Supported SQL Server Versions

These widgets have been tested against the following SQL Server versions:

* SQL Server 2016
* SQL Server 2017 (Windows & linux)

If you find any issues using these widgets on these supported SQL Server versions, or any other versions please create an issue as we would like to make these available for as many releases as possible.

***We are looking for testers to confirm other environments.*** So if you find they do work on other releases let me know, and credit will be given.

## alwayson-ag-replica-health

This Server Dashboard widget includes information on the health of the Availability Group replicas associated with this instance. Information will be shown in the form of a pie chart displaying the percentage of CONNECTED and DISCONNECTED replicas.

![Screen Shot](../docs/images/alwayson-insights/ag-replica-health-insight.png)

> NOTE: in v0.1.0.0 this widget was called `ag-replica-health-insight`

You can access more information about the replicas in the detailed fly-out displayed when you select "..." on the widget.

![Show details](../docs/images/show-detail.png)
![Screen Shot](../docs/images/alwayson-insights/ag-replica-health-insight-details.png)

To install this widget add the following json to either your user or workspace settings in the *dashboard.server.widgets* section.

```json
{
    "name": "AG Replica Health",
    "widget": {
        "alwayson-ag-replica-health": null
    }
}
```

## alwayson-ag-db-sync

This Database Dashboard widget includes information on the health of the database replicas associated with the selected database. Information will be shown in the form of a pie chart displaying the percentage of HEALTHY and NOT_HEALTHY database replicas that the selected database is partnered with inside an Availability Group.

![Screen Shot](../docs/images/alwayson-insights/ag-db-sync-insight.png)

> NOTE: in v0.1.0.0 this widget was called `ag-db-sync-insight`

You can access more information about the database replicas in the detailed fly-out displayed when you select "..." on the widget.

![Screen Shot](../docs/images/alwayson-insights/ag-db-sync-insight-details.png)

To install this widget add the following json to either your user or workspace settings in the *dashboard.database.widgets* section.

```json
{
    "name": "AG DB Sync",
    "widget": {
        "alwayson-ag-db-sync": null
    }
}
```

## alwayson-ag-db-rpo-rto

This Database Dashboard widget includes information on the synchronization state of the avaialbility group database to the partnered replicas. The information assists in estimating the current Recovery Time Objective (RTO) through the *estimated_recovery_time* column, and the Recovery Point Objective (RPO) through the *estimated_data_loss* column. Information will be shown in the form of a bar chart displaying both fields.

![Screen Shot](../docs/images/alwayson-insights/ag-db-rpo-rto-insight.png)

> NOTE: in v0.1.0.0 this widget was called `ag-db-rpo-rto-insight`

You can access more information about the synchronization state in the detailed fly-out displayed when you select "..." on the widget.

![Screen Shot](../docs/images/alwayson-insights/ag-db-rpo-rto-insight-details.png)

To install this widget add the following json to either your user or workspace settings in the *dashboard.database.widgets* section.

```json
{
    "name": "AG DB RPO/RTO",
    "widget": {
        "alwayson-ag-db-rpo-rto": null
    }
}
```