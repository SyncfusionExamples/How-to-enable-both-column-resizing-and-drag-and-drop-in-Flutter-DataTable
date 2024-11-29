# How to enable both column resizing and drag-and-drop in Flutter DataTable (SfDataGrid)?

In this article, we will show you how to enable both column resizing and drag-and-drop in [Flutter DataTable](https://www.syncfusion.com/flutter-widgets/flutter-datagrid).

Initialize the [SfDataGrid](https://pub.dev/documentation/syncfusion_flutter_datagrid/latest/datagrid/SfDataGrid-class.html) widget with all the required properties. Maintain the column width collection at the application level and use the [SfDataGrid.onColumnResizeUpdate](https://pub.dev/documentation/syncfusion_flutter_datagrid/latest/datagrid/SfDataGrid/onColumnResizeUpdate.html) callback to update the column width for the corresponding column. To reorder the columns in the DataGrid, create an instance to hold the columns and assign it to the [SfDataGrid.columns](https://pub.dev/documentation/syncfusion_flutter_datagrid/latest/datagrid/SfDataGrid/columns.html) property, instead of directly assigning the list of [GridColumn](https://pub.dev/documentation/syncfusion_flutter_datagrid/latest/datagrid/GridColumn-class.html). When resizing, create a new GridColumn instance with the updated width value and replace the existing column in the list.

```dart
 @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: SfDataGrid(
          source: _employeeDataSource,
          allowColumnsResizing: true,
          onColumnResizeUpdate: (ColumnResizeUpdateDetails details) {
            setState(() {
              int index = getDataGridColumns.indexOf(
                  getDataGridColumns.firstWhere((element) =>
                      element.columnName == details.column.columnName));
              getDataGridColumns[index] = GridColumn(
                  columnName: details.column.columnName,
                  width: details.width,
                  label: details.column.label);
            });
            return true;
          },
          allowColumnsDragging: true,
          columns: getDataGridColumns,
          onColumnDragging: (DataGridColumnDragDetails details) {
            if (details.action == DataGridColumnDragAction.dropped &&
                details.to != null) {
              final GridColumn rearrangeColumn =
                  getDataGridColumns[details.from];
              getDataGridColumns.removeAt(details.from);
              getDataGridColumns.insert(details.to!, rearrangeColumn);
              _employeeDataSource.buildDataGridRows();
              _employeeDataSource.refreshDataGrid();
            }
            return true;
          },
        ),
      ),
    );
}
```

You can download this example on [GitHub](https://github.com/SyncfusionExamples/How-to-enable-both-column-resizing-and-drag-and-drop-in-Flutter-DataTable).