import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class ReturnsPage extends StatefulWidget {
  const ReturnsPage({super.key});

  @override
  State<ReturnsPage> createState() => _ReturnsPageState();
}

class _ReturnsPageState extends State<ReturnsPage> {
  final TextEditingController _searchController = TextEditingController();
  final TextEditingController _reasonController = TextEditingController();
  final List<ReturnItem> _returnItems = [];
  bool _isLoading = false;
  String _errorMessage = '';
  String _selectedReturnReason = 'Damaged Product';
  final List<String> _returnReasons = [
    'Damaged Product',
    'Wrong Item',
    'Expired Product',
    'Customer Changed Mind',
    'Other'
  ];

  @override
  void dispose() {
    _searchController.dispose();
    _reasonController.dispose();
    super.dispose();
  }

  Future<void> _searchTransaction() async {
    final query = _searchController.text.trim();
    if (query.isEmpty) return;

    setState(() {
      _isLoading = true;
      _errorMessage = '';
      _returnItems.clear();
    });

    try {
      // Simulate API call - replace with actual transaction lookup
      await Future.delayed(const Duration(seconds: 1));

      // Sample data - replace with actual transaction search
      if (query == 'TX-1001') {
        setState(() {
          _returnItems.addAll([
            ReturnItem(
              transactionId: 'TX-1001',
              productId: 'P-001',
              productName: 'Paracetamol 500mg',
              saleDate: DateTime.now().subtract(const Duration(days: 2)),
              originalPrice: 5.99,
              quantity: 2,
              returnReason: _selectedReturnReason,
            ),
            ReturnItem(
              transactionId: 'TX-1001',
              productId: 'P-002',
              productName: 'Ibuprofen 200mg',
              saleDate: DateTime.now().subtract(const Duration(days: 2)),
              originalPrice: 7.50,
              quantity: 1,
              returnReason: _selectedReturnReason,
            ),
          ]);
        });
      } else {
        setState(() {
          _errorMessage = 'No transaction found with ID: $query';
        });
      }
    } catch (e) {
      setState(() {
        _errorMessage = 'Error searching transaction: ${e.toString()}';
      });
    } finally {
      setState(() => _isLoading = false);
    }
  }

  void _updateReturnReason(String? reason) {
    if (reason != null) {
      setState(() {
        _selectedReturnReason = reason;
        for (var item in _returnItems) {
          item.returnReason = reason;
        }
      });
    }
  }

  void _adjustQuantity(String productId, int delta) {
    setState(() {
      final item = _returnItems.firstWhere((item) => item.productId == productId);
      if (item.quantity + delta > 0) {
        item.quantity += delta;
      }
    });
  }

  void _removeItem(String productId) {
    setState(() {
      _returnItems.removeWhere((item) => item.productId == productId);
    });
  }

  void _processReturn() {
    if (_returnItems.isEmpty) {
      setState(() {
        _errorMessage = 'Please add items to process return';
      });
      return;
    }

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Confirm Return'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('You are about to process:'),
            const SizedBox(height: 10),
            Text('Items: ${_returnItems.length}'),
            Text('Total Refund: \$${_calculateTotalRefund().toStringAsFixed(2)}'),
            const SizedBox(height: 10),
            if (_selectedReturnReason == 'Other' && _reasonController.text.isEmpty)
              const Text(
                'Please specify return reason',
                style: TextStyle(color: Colors.red),
              ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: Colors.green),
            onPressed: () {
              if (_selectedReturnReason == 'Other' && _reasonController.text.isEmpty) {
                return; // Prevent submission
              }

              Navigator.pop(context);
              _completeReturnProcess();
            },
            child: const Text('Confirm', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }

  double _calculateTotalRefund() {
    return _returnItems.fold(
      0.0,
          (total, item) => total + (item.originalPrice * item.quantity),
    );
  }

  void _completeReturnProcess() {
    setState(() => _isLoading = true);

    // Simulate API call
    Future.delayed(const Duration(seconds: 2)).then((_) {
      setState(() {
        _isLoading = false;
        _returnItems.clear();
        _searchController.clear();
        _reasonController.clear();
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Return processed successfully. Refund: \$${_calculateTotalRefund().toStringAsFixed(2)}',
          ),
          backgroundColor: Colors.green,
        ),
      );
    }).catchError((e) {
      setState(() {
        _isLoading = false;
        _errorMessage = 'Error processing return: ${e.toString()}';
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header and Search
            const Text(
              'Process Returns',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _searchController,
                    decoration: InputDecoration(
                      hintText: 'Enter Transaction ID...',
                      prefixIcon: const Icon(Icons.search),
                      suffixIcon: IconButton(
                        icon: const Icon(Icons.clear),
                        onPressed: () {
                          _searchController.clear();
                          setState(() {
                            _returnItems.clear();
                            _errorMessage = '';
                          });
                        },
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    onSubmitted: (_) => _searchTransaction(),
                  ),
                ),
                const SizedBox(width: 10),
                ElevatedButton.icon(
                  icon: const Icon(Icons.search),
                  label: const Text('Search'),
                  onPressed: _searchTransaction,
                ),
              ],
            ),
            const SizedBox(height: 10),

            // Return Reason Selection
            Row(
              children: [
                const Text('Return Reason: ', style: TextStyle(fontWeight: FontWeight.bold)),
                const SizedBox(width: 10),
                DropdownButton<String>(
                  value: _selectedReturnReason,
                  items: _returnReasons.map((reason) {
                    return DropdownMenuItem<String>(
                      value: reason,
                      child: Text(reason),
                    );
                  }).toList(),
                  onChanged: _updateReturnReason,
                ),
                if (_selectedReturnReason == 'Other') ...[
                  const SizedBox(width: 10),
                  Expanded(
                    child: TextField(
                      controller: _reasonController,
                      decoration: const InputDecoration(
                        hintText: 'Specify reason...',
                        border: UnderlineInputBorder(),
                      ),
                    ),
                  ),
                ],
              ],
            ),
            const SizedBox(height: 10),

            // Error Message
            if (_errorMessage.isNotEmpty)
              Padding(
                padding: const EdgeInsets.only(bottom: 10),
                child: Text(
                  _errorMessage,
                  style: const TextStyle(color: Colors.red),
                ),
              ),

            // Loading Indicator
            if (_isLoading && _returnItems.isEmpty)
              const Center(child: CircularProgressIndicator()),

            // Return Items List
            Expanded(
              child: _returnItems.isEmpty && !_isLoading
                  ? const Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.assignment_return, size: 48, color: Colors.grey),
                    SizedBox(height: 16),
                    Text('No items to return'),
                    Text('Search for a transaction to begin', style: TextStyle(color: Colors.grey)),
                  ],
                ),
              )
                  : ListView.builder(
                itemCount: _returnItems.length,
                itemBuilder: (context, index) {
                  final item = _returnItems[index];
                  return Card(
                    margin: const EdgeInsets.only(bottom: 8),
                    child: ListTile(
                      leading: const Icon(Icons.medication, color: Colors.red),
                      title: Text(item.productName),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Sale Date: ${DateFormat.yMd().format(item.saleDate)}'),
                          Text('Price: \$${item.originalPrice.toStringAsFixed(2)}'),
                          Text('Reason: ${item.returnReason}'),
                        ],
                      ),
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          IconButton(
                            icon: const Icon(Icons.remove),
                            onPressed: () => _adjustQuantity(item.productId, -1),
                          ),
                          Text(item.quantity.toString()),
                          IconButton(
                            icon: const Icon(Icons.add),
                            onPressed: () => _adjustQuantity(item.productId, 1),
                          ),
                          IconButton(
                            icon: const Icon(Icons.delete, color: Colors.red),
                            onPressed: () => _removeItem(item.productId),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),

            // Summary and Action Buttons
            if (_returnItems.isNotEmpty)
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.grey[100],
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text('Items to Return:', style: TextStyle(fontWeight: FontWeight.bold)),
                        Text(_returnItems.length.toString()),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text('Total Refund:', style: TextStyle(fontWeight: FontWeight.bold)),
                        Text(
                          '\$${_calculateTotalRefund().toStringAsFixed(2)}',
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 18,
                            color: Colors.green,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.red[700],
                          padding: const EdgeInsets.symmetric(vertical: 16),
                        ),
                        onPressed: _isLoading ? null : _processReturn,
                        child: _isLoading
                            ? const CircularProgressIndicator(color: Colors.white)
                            : const Text(
                          'PROCESS RETURN',
                          style: TextStyle(color: Colors.white),
                        ),
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

class ReturnItem {
  final String transactionId;
  final String productId;
  final String productName;
  final DateTime saleDate;
  final double originalPrice;
  int quantity;
  String returnReason;

  ReturnItem({
    required this.transactionId,
    required this.productId,
    required this.productName,
    required this.saleDate,
    required this.originalPrice,
    required this.quantity,
    required this.returnReason,
  });
}