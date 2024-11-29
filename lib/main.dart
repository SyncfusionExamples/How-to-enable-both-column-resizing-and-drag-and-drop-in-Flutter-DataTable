import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';

void main() {
  runApp(const MainApp());
}

class MainApp extends StatefulWidget {
  const MainApp({super.key});

  @override
  State<MainApp> createState() => _MainAppState();
}

class _MainAppState extends State<MainApp> {
  late Map<String, double> columnWidths = {
    'id': double.nan,
    'name': double.nan,
    'designation': double.nan,
    'salary': double.nan
  };
  List<GridColumn> getDataGridColumns = [];
  late EmployeeDataSource _employeeDataSource;
  List<Employee> _employees = <Employee>[];

  @override
  void initState() {
    super.initState();
    getDataGridColumns = getColumn();
    _employees = getEmployeeData();
    _employeeDataSource =
        EmployeeDataSource(employees: _employees, columns: getDataGridColumns);
  }

  List<GridColumn> getColumn() {
    return <GridColumn>[
      GridColumn(
          width: columnWidths['id']!,
          columnName: 'id',
          label: Container(
              padding: const EdgeInsets.all(16.0),
              alignment: Alignment.center,
              child: const Text(
                'ID',
              ))),
      GridColumn(
          width: columnWidths['name']!,
          columnName: 'name',
          label: Container(
              padding: const EdgeInsets.all(8.0),
              alignment: Alignment.center,
              child: const Text('Name'))),
      GridColumn(
          width: columnWidths['designation']!,
          columnName: 'designation',
          label: Container(
              padding: const EdgeInsets.all(8.0),
              alignment: Alignment.center,
              child: const Text(
                'Designation',
                overflow: TextOverflow.ellipsis,
              ))),
      GridColumn(
          width: columnWidths['salary']!,
          columnName: 'salary',
          label: Container(
              padding: const EdgeInsets.all(8.0),
              alignment: Alignment.center,
              child: const Text('Salary'))),
    ];
  }

  List<Employee> getEmployeeData() {
    return [
      Employee(10001, 'James', 'Project Lead', 20000),
      Employee(10002, 'Kathryn', 'Manager', 30000),
      Employee(10003, 'Lara', 'Developer', 15000),
      Employee(10004, 'Michael', 'Designer', 15000),
      Employee(10005, 'Martin', 'Developer', 15000),
      Employee(10006, 'Newberry', 'Developer', 15000),
      Employee(10007, 'Balnc', 'Developer', 15000),
      Employee(10008, 'Perry', 'Developer', 15000),
      Employee(10009, 'Gable', 'Developer', 15000),
      Employee(10010, 'Grimes', 'Developer', 15000)
    ];
  }

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
}

class EmployeeDataSource extends DataGridSource {
  EmployeeDataSource({required this.employees, required this.columns}) {
    buildDataGridRows();
  }

  void buildDataGridRows() {
    dataGridRows = employees.map<DataGridRow>((employee) {
      return DataGridRow(
          cells: columns.map<DataGridCell>((column) {
        return DataGridCell(
          columnName: column.columnName,
          value: employee[column.columnName],
        );
      }).toList());
    }).toList();
  }

  List<Employee> employees = [];
  List<GridColumn> columns = [];
  List<DataGridRow> dataGridRows = [];

  @override
  List<DataGridRow> get rows => dataGridRows;

  @override
  DataGridRowAdapter? buildRow(DataGridRow row) {
    return DataGridRowAdapter(
        cells: row.getCells().map((dataGridCell) {
      return Container(
          alignment: Alignment.center,
          padding: const EdgeInsets.symmetric(horizontal: 8.0),
          child: Text(
            dataGridCell.value.toString(),
          ));
    }).toList());
  }

  refreshDataGrid() {
    notifyListeners();
  }
}

class Employee {
  Employee(this.id, this.name, this.designation, this.salary);
  final int id;
  final String name;
  final String designation;
  final int salary;

  operator [](Object? value) {
    if (value == 'id') {
      return id;
    } else if (value == 'name') {
      return name;
    } else if (value == 'designation') {
      return designation;
    } else if (value == 'salary') {
      return salary;
    } else {
      throw ArgumentError('Invalid property: $value');
    }
  }
}
