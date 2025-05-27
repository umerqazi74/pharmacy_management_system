import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class QuickSalePage extends StatefulWidget {
  const QuickSalePage({super.key});

  @override
  State<QuickSalePage> createState() => _QuickSalePageState();
}

class _QuickSalePageState extends State<QuickSalePage> {
  final TextEditingController _barcodeController = TextEditingController();
  final List<Map<String, dynamic>> _cartItems = [];
  final List<Map<String, dynamic>> _frequentItems = [
    {'id': '1', 'name': 'Paracetamol', 'price': 5.99, 'barcode': '12345678'},
    {'id': '2', 'name': 'Ibuprofen', 'price': 7.50, 'barcode': '23456789'},
    {'id': '3', 'name': 'Vitamin C', 'price': 9.25, 'barcode': '34567890'},
  ];
  bool _isProcessing = false;

  @override
  void initState() {
    super.initState();
    // Focus on barcode field automatically
    Future.delayed(Duration.zero, () {
      FocusScope.of(context).requestFocus(FocusNode());
      SystemChannels.textInput.invokeMethod('TextInput.show');
    });
  }

  void _addToCart(Map<String, dynamic> product) {
    setState(() {
      final existingItem = _cartItems.firstWhere(
            (item) => item['id'] == product['id'],
        orElse: () => {},
      );
      if (existingItem.isNotEmpty) {
        existingItem['quantity'] += 1;
      } else {
        _cartItems.add({...product, 'quantity': 1});
      }
      _barcodeController.clear();
    });
  }

  void _processQuickSale() async {
    if (_cartItems.isEmpty) return;

    setState(() => _isProcessing = true);

    // Simulate payment processing
    await Future.delayed(const Duration(seconds: 1));

    setState(() {
      _cartItems.clear();
      _isProcessing = false;
    });

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Quick sale completed!'),
        backgroundColor: Colors.green,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final totalAmount = _cartItems.fold(
        0.0,
            (sum, item) => sum + (item['price'] * item['quantity'])
    );

    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          children: [
          // Barcode Input Field (Always focused)
          TextField(
          controller: _barcodeController,
          autofocus: true,
          decoration: InputDecoration(
            hintText: 'Scan barcode...',
            prefixIcon: const Icon(Icons.barcode_reader),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
            ),
            filled: true,
            fillColor: Colors.grey[200],
          ),
          keyboardType: TextInputType.number,
          inputFormatters: [FilteringTextInputFormatter.digitsOnly],
          onSubmitted: (barcode) {
            final product = _frequentItems.firstWhere(
                  (item) => item['barcode'] == barcode,
              orElse: () => {},
            );
            if (product.isNotEmpty) {
              _addToCart(product);
            } else {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('Product $barcode not found')),
              );
            }
          },
        ),
        const SizedBox(height: 16),

        // Frequent Items Quick Buttons
         Align(
          alignment: Alignment.centerLeft,
          child: Text('FREQUENT ITEMS:',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12))),
           SizedBox(height: 8),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: _frequentItems.map((item) => ActionChip(
              avatar: const Icon(Icons.medication, size: 18),
              label: Text('${item['name']} \$${item['price']}'),
              onPressed: () => _addToCart(item),
            )).toList(),
          ),
          const SizedBox(height: 16),

          // Current Cart Items
          Expanded(
            child: _cartItems.isEmpty
                ? const Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.shopping_cart_outlined, size: 48, color: Colors.grey),
                  SizedBox(height: 8),
                  Text('Scan items to begin quick sale'),
                ],
              ),
            )
                : ListView.builder(
              itemCount: _cartItems.length,
              itemBuilder: (context, index) {
                final item = _cartItems[index];
                return Dismissible(
                  key: Key(item['id']),
                  direction: DismissDirection.endToStart,
                  background: Container(
                    color: Colors.red,
                    alignment: Alignment.centerRight,
                    padding: const EdgeInsets.only(right: 20),
                    child: const Icon(Icons.delete, color: Colors.white),
                  ),
                  onDismissed: (_) => setState(() => _cartItems.removeAt(index)),
                  child: Card(
                    child: ListTile(
                      leading: const Icon(Icons.medication),
                      title: Text(item['name']),
                      subtitle: Text('\$${item['price']} x ${item['quantity']}'),
                      trailing: Text(
                        '\$${(item['price'] * item['quantity']).toStringAsFixed(2)}',
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                );
              },
            ),
          ),

          // Total and Checkout Button
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.grey[100],
              borderRadius: BorderRadius.circular(10),
            ),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text('TOTAL:', style: TextStyle(fontWeight: FontWeight.bold)),
                    Text(
                      '\$${totalAmount.toStringAsFixed(2)}',
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                        color: Colors.green,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton.icon(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                    ),
                    icon: _isProcessing
                        ? const SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(
                        color: Colors.white,
                        strokeWidth: 2,
                      ),
                    )
                        : const Icon(Icons.done_all),
                    label: Text(_isProcessing ? 'PROCESSING...' : 'COMPLETE SALE (\$${totalAmount.toStringAsFixed(2)})'),
                    onPressed: _isProcessing ? null : _processQuickSale,
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