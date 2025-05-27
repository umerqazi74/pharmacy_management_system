import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class NewSalePage extends StatefulWidget {
  const NewSalePage({super.key});

  @override
  State<NewSalePage> createState() => _NewSalePageState();
}

class _NewSalePageState extends State<NewSalePage> {
  final TextEditingController _searchController = TextEditingController();
  final TextEditingController _customerController = TextEditingController();
  final TextEditingController _discountController = TextEditingController(text: '0');
  final _formKey = GlobalKey<FormState>();

  // Sample medicine database
  final List<Map<String, dynamic>> _allProducts = [
    {'id': '1', 'name': 'Paracetamol 500mg', 'price': 5.99, 'stock': 42, 'barcode': '12345678'},
    {'id': '2', 'name': 'Ibuprofen 200mg', 'price': 7.50, 'stock': 35, 'barcode': '23456789'},
    {'id': '3', 'name': 'Amoxicillin 250mg', 'price': 12.99, 'stock': 18, 'barcode': '34567890'},
    {'id': '4', 'name': 'Vitamin C 1000mg', 'price': 9.25, 'stock': 56, 'barcode': '45678901'},
    {'id': '5', 'name': 'Cetirizine 10mg', 'price': 4.75, 'stock': 28, 'barcode': '56789012'},
    {'id': '6', 'name': 'Omeprazole 20mg', 'price': 8.40, 'stock': 32, 'barcode': '67890123'},
  ];

  List<Map<String, dynamic>> _filteredProducts = [];
  final List<Map<String, dynamic>> _cartItems = [];
  String _paymentMethod = 'Cash';
  bool _isBarcodeMode = false;
  double _taxRate = 0.05; // 5% tax

  @override
  void initState() {
    super.initState();
    _filteredProducts = _allProducts;
    _searchController.addListener(_filterProducts);
  }

  void _filterProducts() {
    final query = _searchController.text.toLowerCase();
    setState(() {
      _filteredProducts = _allProducts.where((product) {
        return product['name'].toLowerCase().contains(query) ||
            product['barcode'].contains(query);
      }).toList();
    });
  }

  void _addToCart(Map<String, dynamic> product) {
    setState(() {
      final existingIndex = _cartItems.indexWhere((item) => item['id'] == product['id']);

      if (existingIndex >= 0) {
        if (_cartItems[existingIndex]['quantity'] < product['stock']) {
          _cartItems[existingIndex]['quantity'] += 1;
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Maximum stock reached for ${product['name']}')),
          );
        }
      } else {
        _cartItems.add({
          ...product,
          'quantity': 1,
          'originalStock': product['stock'] // Keep original stock value
        });
      }
    });
  }

  void _removeFromCart(String productId) {
    setState(() {
      _cartItems.removeWhere((item) => item['id'] == productId);
    });
  }

  void _adjustQuantity(String productId, int delta) {
    setState(() {
      final itemIndex = _cartItems.indexWhere((item) => item['id'] == productId);
      if (itemIndex >= 0) {
        final newQuantity = _cartItems[itemIndex]['quantity'] + delta;
        final originalStock = _cartItems[itemIndex]['originalStock'];

        if (newQuantity > 0 && newQuantity <= originalStock) {
          _cartItems[itemIndex]['quantity'] = newQuantity;
        } else if (newQuantity > originalStock) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Cannot exceed available stock of ${_cartItems[itemIndex]["name"]}')),
          );
        } else {
          _removeFromCart(productId);
        }
      }
    });
  }

  double get _subtotal {
    return _cartItems.fold(0, (sum, item) => sum + (item['price'] * item['quantity']));
  }

  double get _discountAmount {
    try {
      return double.parse(_discountController.text);
    } catch (_) {
      return 0;
    }
  }

  double get _taxAmount {
    return (_subtotal - _discountAmount) * _taxRate;
  }

  double get _totalAmount {
    return (_subtotal - _discountAmount) + _taxAmount;
  }

  void _processPayment() {
    if (_cartItems.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please add items to cart first')),
      );
      return;
    }

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Confirm Payment'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Total: \$${_totalAmount.toStringAsFixed(2)}'),
            const SizedBox(height: 10),
            const Text('Payment Method:'),
            DropdownButtonFormField(
              value: _paymentMethod,
              items: ['Cash', 'Card', 'Mobile Payment', 'Insurance']
                  .map((method) => DropdownMenuItem(
                value: method,
                child: Text(method),
              ))
                  .toList(),
              onChanged: (value) {
                setState(() {
                  _paymentMethod = value!;
                });
              },
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
              // Save transaction to database
              _printReceipt();
              Navigator.pop(context);

              // Clear cart after successful payment
              setState(() {
                _cartItems.clear();
                _discountController.text = '0';
              });

              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Payment successful!')),
              );
            },
            child: const Text('Confirm', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }

  void _printReceipt() {
    // In a real app, this would connect to a receipt printer
    final receipt = '''
    PHARMACY RECEIPT
    ${DateFormat('yyyy-MM-dd HH:mm').format(DateTime.now())}
    ----------------------------
    ${_customerController.text.isNotEmpty ? 'Customer: ${_customerController.text}\n' : ''}
    Items:
    ${_cartItems.map((item) => '${item['name']} x${item['quantity']} \$${(item['price'] * item['quantity']).toStringAsFixed(2)}').join('\n')}
    ----------------------------
    Subtotal: \$${_subtotal.toStringAsFixed(2)}
    Discount: -\$${_discountAmount.toStringAsFixed(2)}
    Tax (${(_taxRate * 100).toStringAsFixed(0)}%): \$${_taxAmount.toStringAsFixed(2)}
    TOTAL: \$${_totalAmount.toStringAsFixed(2)}
    ----------------------------
    Payment Method: $_paymentMethod
    Thank you!
    ''';

    debugPrint(receipt); // Replace with actual printing logic
  }

  void _showBarcodeScanner() {
    setState(() {
      _isBarcodeMode = !_isBarcodeMode;
      if (!_isBarcodeMode) {
        _searchController.clear();
      }
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
            // Header
            Row(
              children: [
                const Text(
                  'New Sale',
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                ),
                const Spacer(),
                SizedBox(
                  width: 200,
                  child: TextFormField(
                    controller: _customerController,
                    decoration: const InputDecoration(
                      hintText: 'Customer name/ID',
                      prefixIcon: Icon(Icons.person),
                      border: OutlineInputBorder(),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),

            // Search & Product Grid
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _searchController,
                    decoration: InputDecoration(
                      hintText: _isBarcodeMode ? 'Scan barcode...' : 'Search medicines...',
                      prefixIcon: const Icon(Icons.search),
                      suffixIcon: IconButton(
                        icon: Icon(_isBarcodeMode ? Icons.barcode_reader : Icons.qr_code),
                        onPressed: _showBarcodeScanner,
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    onChanged: (_) => _filterProducts(),
                  ),
                ),
                const SizedBox(width: 10),
                IconButton(
                  icon: const Icon(Icons.filter_alt, size: 28),
                  onPressed: () {
                    showModalBottomSheet(
                      context: context,
                      builder: (context) => const FilterBottomSheet(),
                    );
                  },
                ),
              ],
            ),
            const SizedBox(height: 20),

            // Main Content (Products + Cart)
            Expanded(
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Product List (Left Side)
                  Expanded(
                    flex: 3,
                    child: Card(
                      elevation: 2,
                      child: Padding(
                        padding: const EdgeInsets.all(12.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'Available Medicines',
                              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                            ),
                            const SizedBox(height: 10),
                            Expanded(
                              child: _filteredProducts.isEmpty
                                  ? const Center(
                                child: Text('No products found'),
                              )
                                  : GridView.builder(
                                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                                  crossAxisCount: 3,
                                  childAspectRatio: 1.2,
                                  crossAxisSpacing: 10,
                                  mainAxisSpacing: 10,
                                ),
                                itemCount: _filteredProducts.length,
                                itemBuilder: (context, index) {
                                  final product = _filteredProducts[index];
                                  return InkWell(
                                    onTap: () => _addToCart(product),
                                    child: Card(
                                      elevation: 1,
                                      child: Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Column(
                                          mainAxisAlignment: MainAxisAlignment.center,
                                          children: [
                                            Text(
                                              product['name'],
                                              style: const TextStyle(fontWeight: FontWeight.bold),
                                              textAlign: TextAlign.center,
                                              maxLines: 2,
                                              overflow: TextOverflow.ellipsis,
                                            ),
                                            const SizedBox(height: 4),
                                            Text(
                                              '\$${product['price']}',
                                              style: TextStyle(
                                                color: Colors.green[700],
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                            const SizedBox(height: 4),
                                            Text(
                                              'Stock: ${product['stock']}',
                                              style: TextStyle(
                                                fontSize: 12,
                                                color: product['stock'] <= 5 ? Colors.red : Colors.grey,
                                              ),
                                            ),
                                            if (product['barcode'] != null)
                                              Padding(
                                                padding: const EdgeInsets.only(top: 4),
                                                child: Text(
                                                  'Barcode: ${product['barcode']}',
                                                  style: const TextStyle(fontSize: 10, color: Colors.blue),
                                                ),
                                              ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  );
                                },
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(width: 16),

                  // Shopping Cart (Right Side)
                  Expanded(
                    flex: 2,
                    child: Card(
                      elevation: 2,
                      child: Padding(
                        padding: const EdgeInsets.all(12.0),
                        child: Column(
                          children: [
                            const Text(
                              'Order Summary',
                              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                            ),
                            const SizedBox(height: 10),
                            Expanded(
                              child: _cartItems.isEmpty
                                  ? const Center(
                                child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Icon(Icons.shopping_cart_outlined, size: 48, color: Colors.grey),
                                    SizedBox(height: 8),
                                    Text('Your cart is empty', style: TextStyle(color: Colors.grey)),
                                  ],
                                ),
                              )
                                  : ListView.builder(
                                itemCount: _cartItems.length,
                                itemBuilder: (context, index) {
                                  final item = _cartItems[index];
                                  return Card(
                                    margin: const EdgeInsets.only(bottom: 8),
                                    child: Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Row(
                                        children: [
                                          Expanded(
                                            child: Column(
                                              crossAxisAlignment: CrossAxisAlignment.start,
                                              children: [
                                                Text(
                                                  item['name'],
                                                  style: const TextStyle(fontWeight: FontWeight.bold),
                                                ),
                                                Text(
                                                  '\$${item['price']} x ${item['quantity']}',
                                                  style: const TextStyle(color: Colors.grey),
                                                ),
                                              ],
                                            ),
                                          ),
                                          Row(
                                            children: [
                                              IconButton(
                                                icon: const Icon(Icons.remove, size: 18),
                                                onPressed: () => _adjustQuantity(item['id'], -1),
                                              ),
                                              Text(item['quantity'].toString()),
                                              IconButton(
                                                icon: const Icon(Icons.add, size: 18),
                                                onPressed: () => _adjustQuantity(item['id'], 1),
                                              ),
                                              IconButton(
                                                icon: const Icon(Icons.delete_outline, size: 18, color: Colors.red),
                                                onPressed: () => _removeFromCart(item['id']),
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                    ),
                                  );
                                },
                              ),
                            ),
                            const Divider(height: 20),
                            Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 8.0),
                              child: Column(
                                children: [
                                Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  const Text('Subtotal:', style: TextStyle(fontWeight: FontWeight.bold)),
                                  Text('\$${_subtotal.toStringAsFixed(2)}', style: const TextStyle(fontWeight: FontWeight.bold)),
                                ],
                              ),
                              const SizedBox(height: 8),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  const Text('Discount:'),
                                  SizedBox(
                                    width: 100,
                                    child: TextFormField(
                                      controller: _discountController,
                                      keyboardType: TextInputType.number,
                                      decoration: const InputDecoration(
                                        prefixText: '\$',
                                        border: UnderlineInputBorder(),
                                      ),
                                      onChanged: (_) => setState(() {}),
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 8),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Text('Tax (${(_taxRate * 100).toStringAsFixed(0)}%):'),
                                  Text('\$${_taxAmount.toStringAsFixed(2)}'),
                                ],
                              ),
                              const Divider(height: 20),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  const Text('TOTAL:', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                                  Text(
                                    '\$${_totalAmount.toStringAsFixed(2)}',
                                    style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: Colors.green),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 16),
                              SizedBox(
                                width: double.infinity,
                                child: ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.green,
                                    padding: const EdgeInsets.symmetric(vertical: 16),
                                  ),
                                  onPressed: _processPayment,
                                  child: const Text(
                                    'PROCEED TO PAYMENT',
                                    style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                                  ),
                                )),
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
            ),
          ],
        ),
      ),
    );
  }
}

// Example Filter Bottom Sheet (can be expanded)
class FilterBottomSheet extends StatelessWidget {
  const FilterBottomSheet({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Text('Filter Products', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          const SizedBox(height: 16),
          // Add filter options here
          ElevatedButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Apply Filters'),
          ),
        ],
      ),
    );
  }
}