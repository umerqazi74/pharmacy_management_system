import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

class SalesReportPage extends StatefulWidget {
  const SalesReportPage({super.key});

  @override
  State<SalesReportPage> createState() => _SalesReportPageState();
}

class _SalesReportPageState extends State<SalesReportPage> {
  DateTimeRange _dateRange = DateTimeRange(
    start: DateTime.now().subtract(const Duration(days: 30)),
    end: DateTime.now(),
  );
  String _reportType = 'daily';

  final List<SalesRecord> _salesData = [
    SalesRecord(date: DateTime(2023, 10, 1), amount: 1245.50, items: 5, status: "Completed"),
    SalesRecord(date: DateTime(2023, 10, 2), amount: 745.00, items: 3, status: "Completed"),
    SalesRecord(date: DateTime(2023, 10, 3), amount: 2105.75, items: 7, status: "Completed"),
    SalesRecord(date: DateTime(2023, 10, 4), amount: 450.25, items: 2, status: "Pending"),
  ];

  final List<SalesTrend> _weeklyTrend = [
    SalesTrend(day: "Mon", sales: 1200),
    SalesTrend(day: "Tue", sales: 1800),
    SalesTrend(day: "Wed", sales: 900),
    SalesTrend(day: "Thu", sales: 2500),
    SalesTrend(day: "Fri", sales: 2100),
    SalesTrend(day: "Sat", sales: 3000),
    SalesTrend(day: "Sun", sales: 2700),
  ];

  final List<MedicineSales> _topMedicines = [
    MedicineSales(name: "Paracetamol", sales: 45),
    MedicineSales(name: "Ibuprofen", sales: 30),
    MedicineSales(name: "Vitamin C", sales: 25),
    MedicineSales(name: "Amoxicillin", sales: 20),
  ];

  @override
  Widget build(BuildContext context) {
    final totalSales = _salesData.fold(0.0, (sum, record) => sum + record.amount);
    final completedSales = _salesData.where((r) => r.status == "Completed").fold(0.0, (sum, r) => sum + r.amount);

    return Scaffold(
      backgroundColor: Colors.blue.withOpacity(0.01),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // **Header Section**
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "Reports > Sales Report",
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.grey[700],
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  ElevatedButton.icon(
                    onPressed: _exportReport,
                    icon: const Icon(Icons.download, size: 18),
                    label: const Text("Export PDF"),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue[600],
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Text(
                "Analyze sales performance & trends",
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.grey[600],
                ),
              ),
              const SizedBox(height: 20),

              // **Summary Cards (Top Row)**
              SizedBox(
                height: 120,
                child: ListView(
                  scrollDirection: Axis.horizontal,
                  children: [
                    _buildSummaryCard(
                      title: "Total Sales",
                      value: totalSales,
                      icon: Icons.attach_money,
                      color: Colors.blue[600]!,
                    ),
                    const SizedBox(width: 12),
                    _buildSummaryCard(
                      title: "Completed Sales",
                      value: completedSales,
                      icon: Icons.check_circle,
                      color: Colors.green[600]!,
                    ),
                    const SizedBox(width: 12),
                    _buildSummaryCard(
                      title: "Transactions",
                      value: _salesData.length.toDouble(),
                      icon: Icons.receipt,
                      color: Colors.purple[600]!,
                      isCurrency: false,
                    ),
                    const SizedBox(width: 12),
                    _buildSummaryCard(
                      title: "Avg. Sale",
                      value: totalSales / _salesData.length,
                      icon: Icons.trending_up,
                      color: Colors.orange[600]!,
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),

              // **Graphs Section**
              Row(
                children: [
                  Expanded(
                    flex: 2,
                    child: Card(
                      elevation: 3,
                      color: Colors.white,
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Weekly Sales Trend",
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: Colors.grey[800],
                              ),
                            ),
                            const SizedBox(height: 10),
                            SizedBox(
                              height: 250,
                              child: SfCartesianChart(
                                primaryXAxis: CategoryAxis(),
                                series: <CartesianSeries>[
                                  ColumnSeries<SalesTrend, String>(
                                    dataSource: _weeklyTrend,
                                    xValueMapper: (SalesTrend trend, _) => trend.day,
                                    yValueMapper: (SalesTrend trend, _) => trend.sales,
                                    color: Colors.blue[400],
                                    borderRadius: BorderRadius.circular(4),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    flex: 1,
                    child: Card(
                      elevation: 3,
                      color: Colors.white,
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Top Selling Medicines",
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: Colors.grey[800],
                              ),
                            ),
                            const SizedBox(height: 10),
                            SizedBox(
                              height: 250,
                              child: SfCircularChart(
                                series: <CircularSeries>[
                                  PieSeries<MedicineSales, String>(
                                    dataSource: _topMedicines,
                                    xValueMapper: (MedicineSales data, _) => data.name,
                                    yValueMapper: (MedicineSales data, _) => data.sales,
                                    dataLabelSettings: const DataLabelSettings(isVisible: true),
                                    pointColorMapper: (MedicineSales data, _) {
                                      return [
                                        Colors.blue[400],
                                        Colors.green[400],
                                        Colors.orange[400],
                                        Colors.purple[400],
                                      ][_topMedicines.indexOf(data) % 4];
                                    },
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),

              // **Filters & Data Table**
              Card(
                elevation: 3,
                color: Colors.white,
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: TextButton.icon(
                              onPressed: _pickDateRange,
                              icon: const Icon(Icons.calendar_today, size: 18),
                              label: Text(
                                "${DateFormat('MMM d, y').format(_dateRange.start)} - ${DateFormat('MMM d, y').format(_dateRange.end)}",
                                style: TextStyle(color: Colors.grey[800]),
                              ),
                            ),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: DropdownButtonFormField<String>(
                              value: _reportType,
                              decoration: InputDecoration(
                                labelText: "Report Type",
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(8),
                                ),
                              ),
                              items: const [
                                DropdownMenuItem(value: "daily", child: Text("Daily")),
                                DropdownMenuItem(value: "weekly", child: Text("Weekly")),
                                DropdownMenuItem(value: "monthly", child: Text("Monthly")),
                              ],
                              onChanged: (value) => setState(() => _reportType = value!),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      SizedBox(
                        width: double.infinity,
                        child: DataTable(
                          columns: const [
                            DataColumn(label: Text("Date", style: TextStyle(fontWeight: FontWeight.bold))),
                            DataColumn(label: Text("Invoice No.", style: TextStyle(fontWeight: FontWeight.bold))),
                            DataColumn(label: Text("Amount", style: TextStyle(fontWeight: FontWeight.bold))),
                            DataColumn(label: Text("Status", style: TextStyle(fontWeight: FontWeight.bold))),
                          ],
                          rows: _salesData.map((record) {
                            return DataRow(
                              cells: [
                                DataCell(Text(DateFormat('MMM d, y').format(record.date))),
                                DataCell(Text("INV-${record.date.millisecondsSinceEpoch.toString().substring(5)}")),
                                DataCell(Text(
                                  "\$${record.amount.toStringAsFixed(2)}",
                                  style: const TextStyle(fontWeight: FontWeight.bold),
                                )),
                                DataCell(
                                  Container(
                                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                    decoration: BoxDecoration(
                                      color: record.status == "Completed" ? Colors.green[50] : Colors.orange[50],
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                    child: Text(
                                      record.status,
                                      style: TextStyle(
                                        color: record.status == "Completed" ? Colors.green[800] : Colors.orange[800],
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            );
                          }).toList(),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSummaryCard({
    required String title,
    required double value,
    required IconData icon,
    required Color color,
    bool isCurrency = true,
  }) {
    return Card(
      elevation: 3,
      color: Colors.white,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(6),
                  decoration: BoxDecoration(
                    color: color.withOpacity(0.1),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(icon, size: 18, color: color),
                ),
                const SizedBox(width: 8),
                Text(
                  title,
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey[700],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              isCurrency ? "\$${value.toStringAsFixed(2)}" : value.toInt().toString(),
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: color,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _pickDateRange() async {
    final picked = await showDateRangePicker(
      context: context,
      initialDateRange: _dateRange,
      firstDate: DateTime(2023),
      lastDate: DateTime.now(),
    );
    if (picked != null) setState(() => _dateRange = picked);
  }

  void _exportReport() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text("Report exported successfully!"),
        backgroundColor: Colors.green,
      ),
    );
  }
}

class SalesRecord {
  final DateTime date;
  final double amount;
  final int items;
  final String status;

  SalesRecord({
    required this.date,
    required this.amount,
    required this.items,
    required this.status,
  });
}

class SalesTrend {
  final String day;
  final double sales;

  SalesTrend({required this.day, required this.sales});
}

class MedicineSales {
  final String name;
  final double sales;

  MedicineSales({required this.name, required this.sales});
}