import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

class PaymentReportPage extends StatefulWidget {
  const PaymentReportPage({super.key});

  @override
  State<PaymentReportPage> createState() => _PaymentReportPageState();
}

class _PaymentReportPageState extends State<PaymentReportPage> {
  DateTimeRange _dateRange = DateTimeRange(
    start: DateTime.now().subtract(const Duration(days: 30)),
    end: DateTime.now(),
  );
  String _paymentType = 'all';
  String _reportView = 'summary';

  final List<PaymentRecord> _payments = [
    PaymentRecord(
      date: DateTime.now().subtract(const Duration(days: 3)),
      invoiceNo: 'INV-2023-0456',
      customer: 'Regular Customer',
      amount: 1245.50,
      paymentMethod: 'Credit Card',
      status: 'Completed',
    ),
    PaymentRecord(
      date: DateTime.now().subtract(const Duration(days: 2)),
      invoiceNo: 'INV-2023-0457',
      customer: 'Walk-in Customer',
      amount: 745.00,
      paymentMethod: 'Cash',
      status: 'Completed',
    ),
    PaymentRecord(
      date: DateTime.now().subtract(const Duration(days: 1)),
      invoiceNo: 'INV-2023-0458',
      customer: 'John Smith',
      amount: 2105.75,
      paymentMethod: 'Bank Transfer',
      status: 'Completed',
    ),
    PaymentRecord(
      date: DateTime.now(),
      invoiceNo: 'INV-2023-0459',
      customer: 'Maria Garcia',
      amount: 450.25,
      paymentMethod: 'Credit Card',
      status: 'Pending',
    ),
  ];

  final List<PaymentTrend> _dailyTrends = [
    PaymentTrend(day: 'Mon', amount: 1800),
    PaymentTrend(day: 'Tue', amount: 2200),
    PaymentTrend(day: 'Wed', amount: 1500),
    PaymentTrend(day: 'Thu', amount: 3000),
    PaymentTrend(day: 'Fri', amount: 2500),
    PaymentTrend(day: 'Sat', amount: 1900),
    PaymentTrend(day: 'Sun', amount: 1200),
  ];

  final List<PaymentMethodData> _methodDistribution = [
    PaymentMethodData(method: 'Cash', amount: 3500, percentage: 35),
    PaymentMethodData(method: 'Credit Card', amount: 4500, percentage: 45),
    PaymentMethodData(method: 'Bank Transfer', amount: 2000, percentage: 20),
  ];

  @override
  Widget build(BuildContext context) {
    final completedPayments = _payments.where((p) => p.status == 'Completed');
    final totalReceived = completedPayments.fold(0.0, (sum, p) => sum + p.amount);
    final pendingPayments = _payments.where((p) => p.status == 'Pending');
    final totalPending = pendingPayments.fold(0.0, (sum, p) => sum + p.amount);

    return Scaffold(
      backgroundColor: Colors.blue.withOpacity(0.01),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header Section
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Reports > Payment Reports',
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.grey[700],
                    fontWeight: FontWeight.w500,
                  ),
                ),
                ElevatedButton.icon(
                  onPressed: _exportReport,
                  icon: const Icon(Icons.download, size: 18),
                  label: const Text('Export Report'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue[600],
                    foregroundColor: Colors.white,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              'Track and analyze payment transactions',
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey[600],
              ),
            ),
            const SizedBox(height: 16),

            // Summary Cards
            SizedBox(
              height: 120,
              child: ListView(
                scrollDirection: Axis.horizontal,
                children: [
                  _buildSummaryCard(
                    title: 'Total Received',
                    value: totalReceived,
                    color: Colors.green[600]!,
                    icon: Icons.attach_money,
                  ),
                  const SizedBox(width: 12),
                  _buildSummaryCard(
                    title: 'Pending Payments',
                    value: totalPending,
                    color: Colors.orange[600]!,
                    icon: Icons.pending_actions,
                  ),
                  const SizedBox(width: 12),
                  _buildSummaryCard(
                    title: 'Transactions',
                    value: _payments.length.toDouble(),
                    color: Colors.purple[600]!,
                    icon: Icons.receipt,
                    isCurrency: false,
                  ),
                  const SizedBox(width: 12),
                  _buildSummaryCard(
                    title: 'Avg. Payment',
                    value: totalReceived / completedPayments.length,
                    color: Colors.blue[600]!,
                    icon: Icons.trending_up,
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),

            // Charts Row
            Row(
              children: [
                Expanded(
                  flex: 2,
                  child: Card(
                    elevation: 3,
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Weekly Payment Trends',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: Colors.grey[800],
                            ),
                          ),
                          const SizedBox(height: 8),
                          SizedBox(
                            height: 250,
                            child: SfCartesianChart(
                              primaryXAxis: CategoryAxis(),
                              series: <CartesianSeries>[
                                LineSeries<PaymentTrend, String>(
                                  dataSource: _dailyTrends,
                                  xValueMapper: (PaymentTrend trend, _) => trend.day,
                                  yValueMapper: (PaymentTrend trend, _) => trend.amount,
                                  color: Colors.blue[400],
                                  markerSettings: const MarkerSettings(isVisible: true),
                                  dataLabelSettings: const DataLabelSettings(isVisible: true),
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
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Payment Methods',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: Colors.grey[800],
                            ),
                          ),
                          const SizedBox(height: 8),
                          SizedBox(
                            height: 250,
                            child: SfCircularChart(
                              series: <CircularSeries>[
                                DoughnutSeries<PaymentMethodData, String>(
                                  dataSource: _methodDistribution,
                                  xValueMapper: (PaymentMethodData data, _) => data.method,
                                  yValueMapper: (PaymentMethodData data, _) => data.amount,
                                  dataLabelSettings: const DataLabelSettings(isVisible: true),
                                  pointColorMapper: (PaymentMethodData data, _) {
                                    return {
                                      'Cash': Colors.green[400],
                                      'Credit Card': Colors.blue[400],
                                      'Bank Transfer': Colors.purple[400],
                                    }[data.method];
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
            const SizedBox(height: 16),

            // Filters
            Card(
              elevation: 3,
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
                              '${DateFormat('MMM d, y').format(_dateRange.start)} - ${DateFormat('MMM d, y').format(_dateRange.end)}',
                              style: TextStyle(color: Colors.grey[800]),
                            ),
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: DropdownButtonFormField<String>(
                            value: _paymentType,
                            decoration: InputDecoration(
                              labelText: 'Payment Type',
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                            ),
                            items: const [
                              DropdownMenuItem(value: 'all', child: Text('All Payments')),
                              DropdownMenuItem(value: 'completed', child: Text('Completed')),
                              DropdownMenuItem(value: 'pending', child: Text('Pending')),
                            ],
                            onChanged: (value) => setState(() => _paymentType = value!),
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: DropdownButtonFormField<String>(
                            value: _reportView,
                            decoration: InputDecoration(
                              labelText: 'View',
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                            ),
                            items: const [
                              DropdownMenuItem(value: 'summary', child: Text('Summary')),
                              DropdownMenuItem(value: 'detailed', child: Text('Detailed')),
                            ],
                            onChanged: (value) => setState(() => _reportView = value!),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        Expanded(
                          child: ElevatedButton(
                            onPressed: () {},
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.blue[600],
                              foregroundColor: Colors.white,
                            ),
                            child: const Text('Apply Filters'),
                          ),
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: OutlinedButton(
                            onPressed: _resetFilters,
                            child: const Text('Reset'),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),

            // Payments Table
            Card(
              elevation: 3,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    const Row(
                      children: [
                        Text(
                          'Payment Transactions',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Spacer(),
                        Text(
                          'Showing ${4} of ${4} transactions',
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.grey,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: DataTable(
                        columnSpacing: 24,
                        headingRowColor: MaterialStateProperty.resolveWith<Color>(
                              (states) => Colors.grey[100]!,
                        ),
                        columns: const [
                          DataColumn(
                            label: Text(
                              'Date',
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                          ),
                          DataColumn(
                            label: Text(
                              'Invoice No.',
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                          ),
                          DataColumn(
                            label: Text(
                              'Customer',
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                          ),
                          DataColumn(
                            label: Text(
                              'Amount',
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                            numeric: true,
                          ),
                          DataColumn(
                            label: Text(
                              'Method',
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                          ),
                          DataColumn(
                            label: Text(
                              'Status',
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                          ),
                          DataColumn(
                            label: Text(
                              'Action',
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                          ),
                        ],
                        rows: _payments.map((payment) {
                          return DataRow(
                            cells: [
                              DataCell(
                                Text(DateFormat('MMM d, y').format(payment.date)),
                              ),
                              DataCell(
                                Text(
                                  payment.invoiceNo,
                                  style: const TextStyle(
                                    color: Colors.blue,
                                  ),
                                ),
                              ),
                              DataCell(Text(payment.customer)),
                              DataCell(
                                Text(
                                  NumberFormat.currency(
                                    symbol: '\$',
                                    decimalDigits: 2,
                                  ).format(payment.amount),
                                  style: const TextStyle(
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ),
                              DataCell(Text(payment.paymentMethod)),
                              DataCell(
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 8,
                                    vertical: 4,
                                  ),
                                  decoration: BoxDecoration(
                                    color: payment.status == 'Completed'
                                        ? Colors.green[50]
                                        : Colors.orange[50],
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  child: Text(
                                    payment.status,
                                    style: TextStyle(
                                      color: payment.status == 'Completed'
                                          ? Colors.green[800]
                                          : Colors.orange[800],
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ),
                              ),
                              DataCell(
                                IconButton(
                                  icon: const Icon(Icons.visibility),
                                  color: Colors.blue[600],
                                  onPressed: () => _viewDetails(payment),
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
    );
  }

  Widget _buildSummaryCard({
    required String title,
    required double value,
    required Color color,
    required IconData icon,
    bool isCurrency = true,
  }) {
    return Card(
      elevation: 3,
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
                const SizedBox(width: 12),
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
              isCurrency
                  ? NumberFormat.currency(symbol: '\$', decimalDigits: 2).format(value)
                  : value.toInt().toString(),
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
    final DateTimeRange? newDateRange = await showDateRangePicker(
      context: context,
      initialDateRange: _dateRange,
      firstDate: DateTime(2020),
      lastDate: DateTime.now().add(const Duration(days: 365)),
      builder: (context, child) {
        return Theme(
          data: ThemeData.light().copyWith(
            colorScheme: const ColorScheme.light(
              primary: Colors.blue,
            ),
          ),
          child: child!,
        );
      },
    );

    if (newDateRange != null) {
      setState(() {
        _dateRange = newDateRange;
      });
    }
  }

  void _resetFilters() {
    setState(() {
      _dateRange = DateTimeRange(
        start: DateTime.now().subtract(const Duration(days: 30)),
        end: DateTime.now(),
      );
      _paymentType = 'all';
      _reportView = 'summary';
    });
  }

  void _exportReport() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Exporting payment report...'),
        backgroundColor: Colors.green,
      ),
    );
  }

  void _viewDetails(PaymentRecord payment) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Payment Details - ${payment.invoiceNo}'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Date: ${DateFormat('MMM d, y').format(payment.date)}'),
            Text('Customer: ${payment.customer}'),
            Text('Amount: \$${payment.amount.toStringAsFixed(2)}'),
            Text('Method: ${payment.paymentMethod}'),
            const SizedBox(height: 16),
            const Text(
              'Payment Items:',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            _buildPaymentItems(),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Close'),
          ),
          ElevatedButton(
            onPressed: () {},
            child: const Text('Print Receipt'),
          ),
        ],
      ),
    );
  }

  Widget _buildPaymentItems() {
    const items = [
      {'name': 'Paracetamol 500mg', 'qty': 2, 'price': 5.50},
      {'name': 'Vitamin C 1000mg', 'qty': 1, 'price': 8.75},
      {'name': 'Ibuprofen 400mg', 'qty': 3, 'price': 6.25},
    ];

    return Column(
      children: items.map((item) => Padding(
        padding: const EdgeInsets.symmetric(vertical: 4),
        child: Row(
          children: [
            Expanded(child: Text(item['name'] as String)),
            Text('${item['qty']} x \$${item['price']}'),
            const SizedBox(width: 16),
            Text(
              '\$${((item['qty'] as int) * (item['price'] as double)).toStringAsFixed(2)}',
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
          ],
        ),
      )).toList(),
    );
  }
}

class PaymentRecord {
  final DateTime date;
  final String invoiceNo;
  final String customer;
  final double amount;
  final String paymentMethod;
  final String status;

  PaymentRecord({
    required this.date,
    required this.invoiceNo,
    required this.customer,
    required this.amount,
    required this.paymentMethod,
    required this.status,
  });
}

class PaymentTrend {
  final String day;
  final double amount;

  PaymentTrend({required this.day, required this.amount});
}

class PaymentMethodData {
  final String method;
  final double amount;
  final double percentage;

  PaymentMethodData({
    required this.method,
    required this.amount,
    required this.percentage,
  });
}