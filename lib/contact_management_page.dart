import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class ContactManagementPage extends StatefulWidget {
  const ContactManagementPage({super.key});

  @override
  State<ContactManagementPage> createState() => _ContactManagementPageState();
}

class _ContactManagementPageState extends State<ContactManagementPage> {
  final List<Contact> _contacts = [
    Contact(
      id: 'C001',
      name: 'John Smith',
      type: ContactType.customer,
      phone: '+1 (555) 123-4567',
      email: 'john.smith@example.com',
      lastContact: DateTime.now().subtract(const Duration(days: 2)),
      notes: 'Regular customer, prefers email communication',
    ),
    Contact(
      id: 'C002',
      name: 'MedSupply Inc.',
      type: ContactType.supplier,
      phone: '+1 (555) 987-6543',
      email: 'orders@medsupply.com',
      lastContact: DateTime.now().subtract(const Duration(days: 7)),
      notes: 'Primary pharmaceutical supplier',
    ),
    Contact(
      id: 'C003',
      name: 'Dr. Sarah Johnson',
      type: ContactType.doctor,
      phone: '+1 (555) 456-7890',
      email: 's.johnson@clinic.com',
      lastContact: DateTime.now().subtract(const Duration(days: 30)),
      notes: 'Referring physician from Downtown Clinic',
    ),
    Contact(
      id: 'C004',
      name: 'Maria Garcia',
      type: ContactType.customer,
      phone: '+1 (555) 234-5678',
      email: 'maria.g@example.com',
      lastContact: DateTime.now().subtract(const Duration(days: 1)),
      notes: 'Prefers text messages for refill reminders',
    ),
  ];

  ContactFilter _currentFilter = ContactFilter.all;
  final TextEditingController _searchController = TextEditingController();
  bool _sortByRecent = true;

  @override
  Widget build(BuildContext context) {
    final filteredContacts = _contacts.where((contact) {
      final matchesFilter = _currentFilter == ContactFilter.all ||
          contact.type == _typeFromFilter(_currentFilter);
      final matchesSearch = _searchController.text.isEmpty ||
          contact.name.toLowerCase().contains(_searchController.text.toLowerCase()) ||
          contact.phone.contains(_searchController.text) ||
          contact.email.toLowerCase().contains(_searchController.text.toLowerCase());
      return matchesFilter && matchesSearch;
    }).toList();

    filteredContacts.sort((a, b) => _sortByRecent
        ? b.lastContact.compareTo(a.lastContact)
        : a.name.compareTo(b.name));

    return Scaffold(
      backgroundColor: Colors.blue.withOpacity(0.01),
      appBar: AppBar(
        title: const Text('Contact Management'),
        actions: [
          IconButton(
            icon: Icon(_sortByRecent ? Icons.sort_by_alpha : Icons.access_time),
            onPressed: () => setState(() => _sortByRecent = !_sortByRecent),
          ),
        ],
      ),
      body: Column(
        children: [
          // Search and Filter Bar
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _searchController,
                    decoration: InputDecoration(
                      hintText: 'Search contacts...',
                      prefixIcon: const Icon(Icons.search),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    onChanged: (_) => setState(() {}),
                  ),
                ),
                const SizedBox(width: 8),
                PopupMenuButton<ContactFilter>(
                  icon: const Icon(Icons.filter_alt),
                  onSelected: (filter) => setState(() => _currentFilter = filter),
                  itemBuilder: (context) => [
                    const PopupMenuItem(
                      value: ContactFilter.all,
                      child: Text('All Contacts'),
                    ),
                    const PopupMenuItem(
                      value: ContactFilter.customers,
                      child: Text('Customers Only'),
                    ),
                    const PopupMenuItem(
                      value: ContactFilter.suppliers,
                      child: Text('Suppliers Only'),
                    ),
                    const PopupMenuItem(
                      value: ContactFilter.doctors,
                      child: Text('Doctors Only'),
                    ),
                  ],
                ),
              ],
            ),
          ),

          // Filter Chip
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Row(
              children: [
                Chip(
                  label: Text('${filteredContacts.length} contacts'),
                  backgroundColor: Colors.blue[50],
                ),
                const SizedBox(width: 8),
                if (_currentFilter != ContactFilter.all)
                  Chip(
                    label: Text(
                      _currentFilter.toString().split('.').last,
                      style: TextStyle(color: _getFilterColor(_currentFilter)),
                    ),
                    backgroundColor: _getFilterColor(_currentFilter).withOpacity(0.1),
                  ),
              ],
            ),
          ),

          // Contacts List
          Expanded(
            child: ListView.separated(
              padding: const EdgeInsets.all(8),
              itemCount: filteredContacts.length,
              separatorBuilder: (context, index) => const Divider(height: 1),
              itemBuilder: (context, index) => _buildContactCard(filteredContacts[index]),
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _addNewContact,
        backgroundColor: Colors.blue[600],
        foregroundColor: Colors.white,
        child: const Icon(Icons.add),
      ),
    );
  }

  Widget _buildContactCard(Contact contact) {
    return Card(
      elevation: 1,
      margin: EdgeInsets.zero,
      child: InkWell(
        onTap: () => _viewContactDetails(contact),
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  _buildContactAvatar(contact),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          contact.name,
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          contact.type.toString().split('.').last,
                          style: TextStyle(
                            color: _getTypeColor(contact.type),
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.more_vert),
                    onPressed: () => _showContactOptions(contact),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Row(
                children: [
                  Icon(Icons.phone, size: 16, color: Colors.grey[600]),
                  const SizedBox(width: 8),
                  Text(
                    contact.phone,
                    style: TextStyle(color: Colors.grey[700]),
                  ),
                ],
              ),
              const SizedBox(height: 4),
              Row(
                children: [
                  Icon(Icons.email, size: 16, color: Colors.grey[600]),
                  const SizedBox(width: 8),
                  Text(
                    contact.email,
                    style: TextStyle(color: Colors.grey[700]),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Row(
                children: [
                  Icon(Icons.access_time, size: 16, color: Colors.grey[600]),
                  const SizedBox(width: 8),
                  Text(
                    'Last contact: ${DateFormat('MMM d, y').format(contact.lastContact)}',
                    style: TextStyle(
                      color: Colors.grey[600],
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildContactAvatar(Contact contact) {
    final color = _getTypeColor(contact.type);
    return CircleAvatar(
      backgroundColor: color.withOpacity(0.2),
      child: Icon(
        _getTypeIcon(contact.type),
        color: color,
      ),
    );
  }

  void _viewContactDetails(Contact contact) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(contact.name),
        content: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                leading: _buildContactAvatar(contact),
                title: Text(
                  contact.type.toString().split('.').last,
                  style: TextStyle(color: _getTypeColor(contact.type)),
                ),
              ),
              const Divider(),
              _buildDetailItem(Icons.phone, contact.phone),
              _buildDetailItem(Icons.email, contact.email),
              _buildDetailItem(
                Icons.access_time,
                'Last contacted: ${DateFormat.yMMMd().add_jm().format(contact.lastContact)}',
              ),
              const SizedBox(height: 16),
              const Text(
                'Notes:',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 4),
              Text(contact.notes),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Close'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              _editContact(contact);
            },
            child: const Text('Edit'),
          ),
        ],
      ),
    );
  }

  Widget _buildDetailItem(IconData icon, String text) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        children: [
          Icon(icon, size: 20, color: Colors.grey[600]),
          const SizedBox(width: 12),
          Expanded(child: Text(text)),
        ],
      ),
    );
  }

  void _showContactOptions(Contact contact) {
    showModalBottomSheet(
      context: context,
      builder: (context) => Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          ListTile(
            leading: const Icon(Icons.phone),
            title: const Text('Call'),
            onTap: () {
              Navigator.pop(context);
              // Implement call functionality
            },
          ),
          ListTile(
            leading: const Icon(Icons.email),
            title: const Text('Send Email'),
            onTap: () {
              Navigator.pop(context);
              // Implement email functionality
            },
          ),
          ListTile(
            leading: const Icon(Icons.edit),
            title: const Text('Edit Contact'),
            onTap: () {
              Navigator.pop(context);
              _editContact(contact);
            },
          ),
          ListTile(
            leading: const Icon(Icons.delete, color: Colors.red),
            title: const Text('Delete', style: TextStyle(color: Colors.red)),
            onTap: () {
              Navigator.pop(context);
              _deleteContact(contact.id);
            },
          ),
        ],
      ),
    );
  }

  void _addNewContact() {
    // Implement add new contact functionality
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Add new contact functionality would go here')),
    );
  }

  void _editContact(Contact contact) {
    // Implement edit contact functionality
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Editing ${contact.name}')),
    );
  }

  void _deleteContact(String id) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Contact'),
        content: const Text('Are you sure you want to delete this contact?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              setState(() => _contacts.removeWhere((c) => c.id == id));
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Contact deleted'),
                  backgroundColor: Colors.red,
                ),
              );
            },
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            child: const Text('Delete'),
          ),
        ],
      ),
    );
  }

  Color _getTypeColor(ContactType type) {
    switch (type) {
      case ContactType.customer: return Colors.blue;
      case ContactType.supplier: return Colors.green;
      case ContactType.doctor: return Colors.purple;
      default: return Colors.grey;
    }
  }

  Color _getFilterColor(ContactFilter filter) {
    switch (filter) {
      case ContactFilter.customers: return Colors.blue;
      case ContactFilter.suppliers: return Colors.green;
      case ContactFilter.doctors: return Colors.purple;
      default: return Colors.grey;
    }
  }

  IconData _getTypeIcon(ContactType type) {
    switch (type) {
      case ContactType.customer: return Icons.person;
      case ContactType.supplier: return Icons.local_shipping;
      case ContactType.doctor: return Icons.medical_services;
      default: return Icons.help;
    }
  }

  ContactType _typeFromFilter(ContactFilter filter) {
    switch (filter) {
      case ContactFilter.customers: return ContactType.customer;
      case ContactFilter.suppliers: return ContactType.supplier;
      case ContactFilter.doctors: return ContactType.doctor;
      default: return ContactType.customer;
    }
  }
}

class Contact {
  final String id;
  final String name;
  final ContactType type;
  final String phone;
  final String email;
  final DateTime lastContact;
  final String notes;

  Contact({
    required this.id,
    required this.name,
    required this.type,
    required this.phone,
    required this.email,
    required this.lastContact,
    required this.notes,
  });
}

enum ContactType {
  customer,
  supplier,
  doctor,
}

enum ContactFilter {
  all,
  customers,
  suppliers,
  doctors,
}