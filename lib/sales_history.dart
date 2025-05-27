import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';

class SalesHistoryPage extends StatefulWidget {
  const SalesHistoryPage({super.key});

  @override
  State<SalesHistoryPage> createState() => _SalesHistoryPageState();
}

class _SalesHistoryPageState extends State<SalesHistoryPage> {
  final TextEditingController _searchController = TextEditingController();
  late List<SaleTransaction> _allTransactions = [];
  List<SaleTransaction> _filteredTransactions = [];
  DateTimeRange? _dateRange;
  bool _isLoading = false;
  String _errorMessage = '';

  @override
  void initState() {
    super.initState();
    _loadSalesData();
    _searchController.addListener(_filterTransactions);
  }

  Future<void> _loadSalesData() async {
    setState(() {
      _isLoading = true;
      _errorMessage = '';
    });

    try {
      // Simulate API call
      await Future.delayed(const Duration(seconds: 1));

      // Sample data - replace with actual database call
      final mockData = [
        SaleTransaction(
          id: 'TX-1001',
          date: DateTime.now().subtract(const Duration(hours: 2)),
          customer: 'Regular Customer',
          items: 3,
          total: 28.97,
          paymentMethod: 'Card',
          status: 'Completed',
        ),
        SaleTransaction(
          id: 'TX-1002',
          date: DateTime.now().subtract(const Duration(days: 1)),
          customer: 'Walk-in',
          items: 5,
          total: 42.50,
          paymentMethod: 'Cash',
          status: 'Completed',
        ),
        SaleTransaction(
          id: 'TX-1003',
          date: DateTime.now().subtract(const Duration(days: 3)),
          customer: 'Insurance Claim',
          items: 2,
          total: 15.98,
          paymentMethod: 'Insurance',
          status: 'Pending',
        ),
      ];

      setState(() {
        _allTransactions = mockData;
        _filteredTransactions = mockData;
      });
    } catch (e) {
      setState(() {
        _errorMessage = 'Failed to load sales data: ${e.toString()}';
      });
    } finally {
      setState(() => _isLoading = false);
    }
  }

  void _filterTransactions() {
    final query = _searchController.text.toLowerCase();
    setState(() {
      _filteredTransactions = _allTransactions.where((txn) {
        final matchesSearch = txn.id.toLowerCase().contains(query) ||
            txn.customer.toLowerCase().contains(query) ||
            txn.paymentMethod.toLowerCase().contains(query);

        final matchesDate = _dateRange == null ||
            (txn.date.isAfter(_dateRange!.start) &&
                txn.date.isBefore(_dateRange!.end));

        return matchesSearch && matchesDate;
      }).toList();
    });
  }

  Future<void> _selectDateRange(BuildContext context) async {
    final initialRange = DateTimeRange(
      start: DateTime.now().subtract(const Duration(days: 7)),
      end: DateTime.now(),
    );

    final pickedRange = await showDateRangePicker(
      context: context,
      firstDate: DateTime(2020),
      lastDate: DateTime.now(),
      initialDateRange: initialRange,
    );

    if (pickedRange != null) {
      setState(() {
        _dateRange = pickedRange;
        _filterTransactions();
      });
    }
  }

  void _showTransactionDetails(SaleTransaction transaction) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Transaction ${transaction.id}'),
        content: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              _buildDetailRow('Date:', DateFormat.yMd().add_jm().format(transaction.date)),
              _buildDetailRow('Customer:', transaction.customer),
              _buildDetailRow('Items:', transaction.items.toString()),
              _buildDetailRow('Total:', '\$${transaction.total.toStringAsFixed(2)}'),
              _buildDetailRow('Payment:', transaction.paymentMethod),
              _buildDetailRow('Status:', transaction.status),
              const SizedBox(height: 16),
              const Text('Items Purchased:', style: TextStyle(fontWeight: FontWeight.bold)),
              // In real app, list actual items from transaction
              const Padding(
                padding: EdgeInsets.only(top: 8),
                child: Text('Paracetamol 500mg x2\nIbuprofen 200mg x1'),
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Close'),
          ),
          if (transaction.status == 'Pending')
            TextButton(
              onPressed: () {
                // Handle status change
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Transaction status updated')),
                );
              },
              child: const Text('Mark Complete'),
            ),
        ],
      ),
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          SizedBox(
            width: 80,
            child: Text(label, style: const TextStyle(fontWeight: FontWeight.bold)),
          ),
          Text(value),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header and Filters
            Row(
              children: [
                const Text(
                  'Sales History',
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                ),
                const Spacer(),
                SizedBox(
                  width: 250,
                  child: TextField(
                    controller: _searchController,
                    decoration: InputDecoration(
                      hintText: 'Search transactions...',
                      prefixIcon: const Icon(Icons.search),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 16),
                OutlinedButton.icon(
                  icon: const Icon(Icons.calendar_today, size: 18),
                  label: Text(
                    _dateRange == null
                        ? 'All Dates'
                        : '${DateFormat.yMd().format(_dateRange!.start)} - ${DateFormat.yMd().format(_dateRange!.end)}',
                  ),
                  onPressed: () => _selectDateRange(context),
                ),
                const SizedBox(width: 8),
                IconButton(
                  icon: const Icon(Icons.refresh),
                  onPressed: _loadSalesData,
                  tooltip: 'Refresh',
                ),
              ],
            ),
            const SizedBox(height: 16),

            // Error Message
            if (_errorMessage.isNotEmpty)
              Padding(
                padding: const EdgeInsets.only(bottom: 16),
                child: Text(
                  _errorMessage,
                  style: const TextStyle(color: Colors.red),
                ),
              ),

            // Data Table
            Expanded(
              child: _isLoading
                  ? const Center(child: CircularProgressIndicator())
                  : _filteredTransactions.isEmpty
                  ? const Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.receipt_long, size: 48, color: Colors.grey),
                    SizedBox(height: 16),
                    Text('No transactions found'),
                    Text('Try adjusting your filters', style: TextStyle(color: Colors.grey)),
                  ],
                ),
              )
                  : Card(
                elevation: 2,
                child: SfDataGrid(
                  source: TransactionDataSource(_filteredTransactions),
                  columns: [
                    GridColumn(
                      columnName: 'id',
                      label: Container(
                        padding: const EdgeInsets.all(8),
                        alignment: Alignment.centerLeft,
                        child: const Text('Transaction ID'),
                      ),
                    ),
                    GridColumn(
                      columnName: 'date',
                      label: Container(
                        padding: const EdgeInsets.all(8),
                        alignment: Alignment.centerLeft,
                        child: const Text('Date'),
                      ),
                    ),
                    GridColumn(
                      columnName: 'customer',
                      label: Container(
                        padding: const EdgeInsets.all(8),
                        alignment: Alignment.centerLeft,
                        child: const Text('Customer'),
                      ),
                    ),
                    GridColumn(
                      columnName: 'total',
                      label: Container(
                        padding: const EdgeInsets.all(8),
                        alignment: Alignment.centerRight,
                        child: const Text('Amount'),
                      ),
                    ),
                    GridColumn(
                      columnName: 'status',
                      label: Container(
                        padding: const EdgeInsets.all(8),
                        alignment: Alignment.center,
                        child: const Text('Status'),
                      ),
                    ),
                  ],
                  onCellTap: (details) {
                    if (details.rowColumnIndex.rowIndex > 0) {
                      final transaction = _filteredTransactions[
                      details.rowColumnIndex.rowIndex - 1];
                      _showTransactionDetails(transaction);
                    }
                  },
                  gridLinesVisibility: GridLinesVisibility.both,
                  headerGridLinesVisibility: GridLinesVisibility.both,
                  headerRowHeight: 40,
                  rowHeight: 40,
                  allowSorting: true,
                ),
              ),
            ),

            // Summary Footer
            if (_filteredTransactions.isNotEmpty)
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.grey[100],
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  children: [
                    Text(
                      'Showing ${_filteredTransactions.length} of ${_allTransactions.length} transactions',
                      style: const TextStyle(color: Colors.grey),
                    ),
                    const Spacer(),
                    Text(
                      'Total: \$${_filteredTransactions.fold(0.0, (sum, txn) => sum + txn.total).toStringAsFixed(2)}',
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                  ],
                ),
              ),
          ],
        ),
      ),
    );
  }
}

class SaleTransaction {
  final String id;
  final DateTime date;
  final String customer;
  final int items;
  final double total;
  final String paymentMethod;
  final String status;

  SaleTransaction({
    required this.id,
    required this.date,
    required this.customer,
    required this.items,
    required this.total,
    required this.paymentMethod,
    required this.status,
  });
}

class TransactionDataSource extends DataGridSource {
  TransactionDataSource(List<SaleTransaction> transactions) {
    _transactions = transactions
        .map<DataGridRow>((txn) => DataGridRow(cells: [
      DataGridCell<String>(columnName: 'id', value: txn.id),
      DataGridCell<String>(
        columnName: 'date',
        value: DateFormat.yMd().add_jm().format(txn.date),
      ),
      DataGridCell<String>(columnName: 'customer', value: txn.customer),
      DataGridCell<String>(
        columnName: 'total',
        value: '\$${txn.total.toStringAsFixed(2)}',
      ),
      DataGridCell<Widget>(
        columnName: 'status',
        value: Container(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
          decoration: BoxDecoration(
            color: txn.status == 'Completed'
                ? Colors.green[100]
                : Colors.orange[100],
            borderRadius: BorderRadius.circular(12),
          ),
          child: Text(
            txn.status,
            style: TextStyle(
              color: txn.status == 'Completed'
                  ? Colors.green[800]
                  : Colors.orange[800],
            ),
          ),
        ),
      ),
    ]))
        .toList();
  }

  List<DataGridRow> _transactions = [];

  @override
  List<DataGridRow> get rows => _transactions;

  @override
  DataGridRowAdapter buildRow(DataGridRow row) {
    return DataGridRowAdapter(
      cells: row.getCells().map<Widget>((dataGridCell) {
        return Container(
          alignment: dataGridCell.columnName == 'total'
              ? Alignment.centerRight
              : Alignment.centerLeft,
          padding: const EdgeInsets.all(8),
          child: dataGridCell.value is Widget
              ? dataGridCell.value
              : Text(
            dataGridCell.value.toString(),
            style: TextStyle(
              color: dataGridCell.columnName == 'id'
                  ? Colors.blue[800]
                  : null,
            ),
          ),
        );
      }).toList(),
    );
  }
}