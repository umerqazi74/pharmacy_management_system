import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class CustomerDirectoryPage extends StatefulWidget {
  const CustomerDirectoryPage({super.key});

  @override
  State<CustomerDirectoryPage> createState() => _CustomerDirectoryPageState();
}

class _CustomerDirectoryPageState extends State<CustomerDirectoryPage> {
  final TextEditingController _searchController = TextEditingController();
  List<Customer> _allCustomers = [];
  List<Customer> _filteredCustomers = [];
  bool _isLoading = false;
  String _errorMessage = '';
  String _filterBy = 'All';
  final List<String> _filterOptions = ['All', 'Active', 'Inactive', 'Loyalty Members'];

  @override
  void initState() {
    super.initState();
    _loadCustomers();
    _searchController.addListener(_filterCustomers);
  }

  Future<void> _loadCustomers() async {
    setState(() {
      _isLoading = true;
      _errorMessage = '';
    });

    try {
      // Simulate API call
      await Future.delayed(const Duration(seconds: 1));

      // Sample data - replace with actual database call
      final mockData = [
        Customer(
          id: 'C-1001',
          name: 'John Smith',
          phone: '(555) 123-4567',
          email: 'john.smith@example.com',
          joinDate: DateTime.now().subtract(const Duration(days: 365)),
          lastPurchase: DateTime.now().subtract(const Duration(days: 7)),
          totalPurchases: 12,
          totalSpent: 285.50,
          isLoyaltyMember: true,
          loyaltyPoints: 1250,
          status: 'Active',
        ),
        Customer(
          id: 'C-1002',
          name: 'Sarah Johnson',
          phone: '(555) 987-6543',
          email: 'sarahj@example.com',
          joinDate: DateTime.now().subtract(const Duration(days: 180)),
          lastPurchase: DateTime.now().subtract(const Duration(days: 30)),
          totalPurchases: 5,
          totalSpent: 92.75,
          isLoyaltyMember: false,
          loyaltyPoints: 0,
          status: 'Active',
        ),
        Customer(
          id: 'C-1003',
          name: 'Robert Chen',
          phone: '(555) 456-7890',
          email: 'r.chen@example.com',
          joinDate: DateTime.now().subtract(const Duration(days: 90)),
          lastPurchase: DateTime.now().subtract(const Duration(days: 120)),
          totalPurchases: 3,
          totalSpent: 45.20,
          isLoyaltyMember: true,
          loyaltyPoints: 320,
          status: 'Inactive',
        ),
      ];

      setState(() {
        _allCustomers = mockData;
        _filteredCustomers = mockData;
      });
    } catch (e) {
      setState(() {
        _errorMessage = 'Failed to load customers: ${e.toString()}';
      });
    } finally {
      setState(() => _isLoading = false);
    }
  }

  void _filterCustomers() {
    final query = _searchController.text.toLowerCase();
    setState(() {
      _filteredCustomers = _allCustomers.where((customer) {
        final matchesSearch = customer.name.toLowerCase().contains(query) ||
            customer.phone.contains(query) ||
            customer.email.toLowerCase().contains(query) ||
            customer.id.toLowerCase().contains(query);

        final matchesFilter = _filterBy == 'All' ||
            (_filterBy == 'Active' && customer.status == 'Active') ||
            (_filterBy == 'Inactive' && customer.status == 'Inactive') ||
            (_filterBy == 'Loyalty Members' && customer.isLoyaltyMember);

        return matchesSearch && matchesFilter;
      }).toList();
    });
  }

  void _showCustomerDetails(Customer customer) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) => SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  customer.name,
                  style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                IconButton(
                  icon: const Icon(Icons.edit),
                  onPressed: () => _editCustomer(customer),
                ),
              ],
            ),
            const Divider(),
            _buildDetailRow('Customer ID:', customer.id),
            _buildDetailRow('Phone:', customer.phone),
            _buildDetailRow('Email:', customer.email),
            _buildDetailRow('Member Since:', DateFormat.yMMMMd().format(customer.joinDate)),
            _buildDetailRow('Last Purchase:',
                customer.lastPurchase != null
                    ? DateFormat.yMMMMd().format(customer.lastPurchase!)
                    : 'Never'),
            _buildDetailRow('Total Purchases:', customer.totalPurchases.toString()),
            _buildDetailRow('Total Spent:', '\$${customer.totalSpent.toStringAsFixed(2)}'),
            _buildDetailRow('Status:',
                TextSpan(
                  text: customer.status,
                  style: TextStyle(
                    color: customer.status == 'Active' ? Colors.green : Colors.orange,
                    fontWeight: FontWeight.bold,
                  ),
                )),
            if (customer.isLoyaltyMember) ...[
              _buildDetailRow('Loyalty Points:', customer.loyaltyPoints.toString()),
              const SizedBox(height: 16),
              ElevatedButton.icon(
                icon: const Icon(Icons.card_giftcard),
                label: const Text('View Loyalty Rewards'),
                onPressed: () => _viewLoyaltyRewards(customer),
              ),
            ],
            const SizedBox(height: 24),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: () => Navigator.pop(context),
                    child: const Text('Close'),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue[800],
                    ),
                    onPressed: () => _startNewSale(customer),
                    child: const Text('New Sale', style: TextStyle(color: Colors.white)),
                  ),
                ),
              ],
            ),
             SizedBox(height: MediaQuery.of(context).viewInsets.bottom),
          ],
        ),
      ),
    );
  }

  Widget _buildDetailRow(String label, dynamic value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 120,
            child: Text(label, style: const TextStyle(fontWeight: FontWeight.bold)),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: value is TextSpan
                ? RichText(text: value)
                : Text(value.toString()),
          ),
        ],
      ),
    );
  }

  void _editCustomer(Customer customer) {
    Navigator.pop(context); // Close details sheet
    // Implement edit functionality
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Edit ${customer.name} (implementation needed)')),
    );
  }

  void _viewLoyaltyRewards(Customer customer) {
    Navigator.pop(context); // Close details sheet
    // Implement loyalty rewards view
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('View ${customer.name}\'s loyalty rewards (implementation needed)')),
    );
  }

  void _startNewSale(Customer customer) {
    Navigator.pop(context); // Close details sheet
    // Implement new sale for customer
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Start new sale for ${customer.name} (implementation needed)')),
    );
  }

  void _addNewCustomer() {
    // Implement add new customer
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Add new customer (implementation needed)')),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: _addNewCustomer,
        backgroundColor: Colors.blue[800],
        child: const Icon(Icons.person_add, color: Colors.white),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header and Search
            const Text(
              'Customer Directory',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _searchController,
                    decoration: InputDecoration(
                      hintText: 'Search customers...',
                      prefixIcon: const Icon(Icons.search),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                IconButton(
                  icon: const Icon(Icons.filter_list),
                  onPressed: () {
                    showModalBottomSheet(
                      context: context,
                      builder: (context) => _buildFilterBottomSheet(),
                    );
                  },
                  tooltip: 'Filters',
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

            // Active Filter Chip
            if (_filterBy != 'All')
              Align(
                alignment: Alignment.centerLeft,
                child: Chip(
                  label: Text('Filter: $_filterBy'),
                  onDeleted: () {
                    setState(() {
                      _filterBy = 'All';
                      _filterCustomers();
                    });
                  },
                ),
              ),

            // Customer Count
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 8),
              child: Text(
                '${_filteredCustomers.length} ${_filteredCustomers.length == 1 ? 'customer' : 'customers'} found',
                style: TextStyle(color: Colors.grey[600]),
              ),
            ),

            // Customer List
            Expanded(
              child: _isLoading
                  ? const Center(child: CircularProgressIndicator())
                  : _filteredCustomers.isEmpty
                  ? const Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.people_outline, size: 48, color: Colors.grey),
                    SizedBox(height: 16),
                    Text('No customers found'),
                    Text('Try adjusting your search or filters',
                        style: TextStyle(color: Colors.grey)),
                  ],
                ),
              )
                  : ListView.builder(
                itemCount: _filteredCustomers.length,
                itemBuilder: (context, index) {
                  final customer = _filteredCustomers[index];
                  return Card(
                    margin: const EdgeInsets.only(bottom: 8),
                    child: ListTile(
                      leading: CircleAvatar(
                        backgroundColor: Colors.blue[100],
                        child: Text(customer.name[0]),
                      ),
                      title: Text(customer.name),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(customer.phone),
                          if (customer.isLoyaltyMember)
                            Row(
                              children: [
                                const Icon(Icons.star, size: 16, color: Colors.amber),
                                const SizedBox(width: 4),
                                Text(
                                  '${customer.loyaltyPoints} pts',
                                  style: const TextStyle(color: Colors.amber),
                                ),
                              ],
                            ),
                        ],
                      ),
                      trailing: const Icon(Icons.chevron_right),
                      onTap: () => _showCustomerDetails(customer),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFilterBottomSheet() {
    return Container(
      padding: const EdgeInsets.all(16),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Filter Customers',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 16),
          ..._filterOptions.map((option) => RadioListTile<String>(
            title: Text(option),
            value: option,
            groupValue: _filterBy,
            onChanged: (value) {
              Navigator.pop(context);
              setState(() {
                _filterBy = value!;
                _filterCustomers();
              });
            },
          )).toList(),
        ],
      ),
    );
  }
}

class Customer {
  final String id;
  final String name;
  final String phone;
  final String email;
  final DateTime joinDate;
  final DateTime? lastPurchase;
  final int totalPurchases;
  final double totalSpent;
  final bool isLoyaltyMember;
  final int loyaltyPoints;
  final String status;

  Customer({
    required this.id,
    required this.name,
    required this.phone,
    required this.email,
    required this.joinDate,
    this.lastPurchase,
    required this.totalPurchases,
    required this.totalSpent,
    required this.isLoyaltyMember,
    required this.loyaltyPoints,
    required this.status,
  });
}