import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class ConfigurationPage extends StatefulWidget {
  const ConfigurationPage({super.key});

  @override
  State<ConfigurationPage> createState() => _ConfigurationPageState();
}

class _ConfigurationPageState extends State<ConfigurationPage> {
  final _formKey = GlobalKey<FormState>();
  bool _notificationsEnabled = true;
  String _selectedLanguage = 'English';
  String _businessName = 'City Pharmacy';
  String _businessId = 'PH-123456';
  String _ownerName = 'Dr. John Smith';
  String _ownerEmail = 'john.smith@pharmacy.com';
  String _phoneNumber = '+1 (555) 123-4567';
  double _taxRate = 7.5;

  // Pages Management
  final List<SystemPage> _pages = [
    SystemPage(id: 'P001', name: 'Dashboard', route: '/dashboard', isActive: true),
    SystemPage(id: 'P002', name: 'Inventory', route: '/inventory', isActive: true),
    SystemPage(id: 'P003', name: 'Sales', route: '/sales', isActive: true),
    SystemPage(id: 'P004', name: 'Reports', route: '/reports', isActive: true),
    SystemPage(id: 'P005', name: 'Customers', route: '/customers', isActive: false),
  ];
  final TextEditingController _pageNameController = TextEditingController();
  final TextEditingController _pageRouteController = TextEditingController();
  bool _pageActiveStatus = true;
  String? _editingPageId;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blue.withOpacity(0.01),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Settings > System Configuration',
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.grey[700],
                    fontWeight: FontWeight.w500,
                  ),
                ),
                ElevatedButton.icon(
                  onPressed: _saveSettings,
                  icon: const Icon(Icons.save, size: 18),
                  label: const Text('Save All'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue[600],
                    foregroundColor: Colors.white,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              'Manage business information and system configuration',
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey[600],
              ),
            ),
            const SizedBox(height: 20),

            // Business Branding Section
            _buildSectionTitle('Business Branding'),
            Card(
              elevation: 3,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      TextFormField(
                        decoration: const InputDecoration(
                          labelText: 'Business Name',
                          border: OutlineInputBorder(),
                        ),
                        initialValue: _businessName,
                        onChanged: (value) => _businessName = value,
                        validator: (value) => value!.isEmpty ? 'Required' : null,
                      ),
                      const SizedBox(height: 12),
                      TextFormField(
                        decoration: const InputDecoration(
                          labelText: 'Business ID',
                          border: OutlineInputBorder(),
                        ),
                        initialValue: _businessId,
                        onChanged: (value) => _businessId = value,
                      ),
                      const SizedBox(height: 12),
                      TextFormField(
                        decoration: const InputDecoration(
                          labelText: 'Owner Name',
                          border: OutlineInputBorder(),
                        ),
                        initialValue: _ownerName,
                        onChanged: (value) => _ownerName = value,
                      ),
                      const SizedBox(height: 12),
                      TextFormField(
                        decoration: const InputDecoration(
                          labelText: 'Owner Email',
                          border: OutlineInputBorder(),
                        ),
                        initialValue: _ownerEmail,
                        keyboardType: TextInputType.emailAddress,
                        onChanged: (value) => _ownerEmail = value,
                        validator: (value) =>
                        !value!.contains('@') ? 'Invalid email' : null,
                      ),
                      const SizedBox(height: 12),
                      TextFormField(
                        decoration: const InputDecoration(
                          labelText: 'Phone Number',
                          border: OutlineInputBorder(),
                        ),
                        initialValue: _phoneNumber,
                        keyboardType: TextInputType.phone,
                        onChanged: (value) => _phoneNumber = value,
                      ),
                    ],
                  ),
                ),
              ),
            ),
            const SizedBox(height: 20),

            // System Configuration
            _buildSectionTitle('System Configuration'),
            Card(
              elevation: 3,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    SwitchListTile(
                      title: const Text('Enable Notifications'),
                      value: _notificationsEnabled,
                      activeColor: Colors.blue[600],
                      onChanged: (value) =>
                          setState(() => _notificationsEnabled = value),
                    ),
                    const SizedBox(height: 12),
                    DropdownButtonFormField<String>(
                      decoration: const InputDecoration(
                        labelText: 'Language',
                        border: OutlineInputBorder(),
                      ),
                      value: _selectedLanguage,
                      items: ['English', 'Spanish', 'French', 'Arabic']
                          .map((lang) => DropdownMenuItem(
                        value: lang,
                        child: Text(lang),
                      ))
                          .toList(),
                      onChanged: (value) =>
                          setState(() => _selectedLanguage = value!),
                    ),
                    const SizedBox(height: 12),
                    TextFormField(
                      decoration: const InputDecoration(
                        labelText: 'Tax Rate (%)',
                        border: OutlineInputBorder(),
                      ),
                      keyboardType: TextInputType.number,
                      inputFormatters: [
                        FilteringTextInputFormatter.allow(RegExp(r'^\d+\.?\d{0,2}')),
                      ],
                      initialValue: _taxRate.toString(),
                      onChanged: (value) =>
                      _taxRate = double.tryParse(value) ?? 0.0,
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 20),

            // Pages Management
            _buildSectionTitle('Pages Management'),
            Card(
              elevation: 3,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: DataTable(
                        columns: const [
                          DataColumn(label: Text('ID')),
                          DataColumn(label: Text('Page Name')),
                          DataColumn(label: Text('Route')),
                          DataColumn(label: Text('Status')),
                          DataColumn(label: Text('Actions')),
                        ],
                        rows: _pages.map((page) => DataRow(
                          cells: [
                            DataCell(Text(page.id)),
                            DataCell(Text(page.name)),
                            DataCell(Text(page.route)),
                            DataCell(
                              Chip(
                                label: Text(
                                  page.isActive ? 'Active' : 'Inactive',
                                  style: TextStyle(
                                    color: page.isActive
                                        ? Colors.green[800]
                                        : Colors.red[800],
                                  ),
                                ),
                                backgroundColor: page.isActive
                                    ? Colors.green[50]
                                    : Colors.red[50],
                              ),
                            ),
                            DataCell(Row(
                              children: [
                                IconButton(
                                  icon: const Icon(Icons.edit, size: 20),
                                  color: Colors.blue[600],
                                  onPressed: () => _editPage(page),
                                ),
                                IconButton(
                                  icon: const Icon(Icons.delete, size: 20),
                                  color: Colors.red[600],
                                  onPressed: () => _deletePage(page.id),
                                ),
                              ],
                            )),
                          ],
                        )).toList(),
                      ),
                    ),
                    const SizedBox(height: 16),
                    ElevatedButton.icon(
                      onPressed: _showAddPageDialog,
                      icon: const Icon(Icons.add),
                      label: const Text('Add New Page'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.green[600],
                        foregroundColor: Colors.white,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.only(left: 8.0, bottom: 8.0),
      child: Text(
        title,
        style: TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.bold,
          color: Colors.blue[600],
        ),
      ),
    );
  }

  void _saveSettings() {
    if (_formKey.currentState!.validate()) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('All settings saved successfully'),
          backgroundColor: Colors.green,
        ),
      );
    }
  }

  void _showAddPageDialog() {
    _pageNameController.clear();
    _pageRouteController.clear();
    _pageActiveStatus = true;
    _editingPageId = null;

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(_editingPageId == null ? 'Add New Page' : 'Edit Page'),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextFormField(
                controller: _pageNameController,
                decoration: const InputDecoration(
                  labelText: 'Page Name',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _pageRouteController,
                decoration: const InputDecoration(
                  labelText: 'Route Path',
                  border: OutlineInputBorder(),
                  prefixText: '/',
                ),
              ),
              const SizedBox(height: 12),
              SwitchListTile(
                title: const Text('Active Status'),
                value: _pageActiveStatus,
                onChanged: (value) =>
                    setState(() => _pageActiveStatus = value),
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: _savePage,
            child: const Text('Save'),
          ),
        ],
      ),
    );
  }

  void _savePage() {
    if (_pageNameController.text.isEmpty ||
        _pageRouteController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please fill all fields'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    setState(() {
      if (_editingPageId == null) {
        // Add new page
        _pages.add(SystemPage(
          id: 'P${(_pages.length + 1).toString().padLeft(3, '0')}',
          name: _pageNameController.text,
          route: '/${_pageRouteController.text}',
          isActive: _pageActiveStatus,
        ));
      } else {
        // Update existing page
        final index = _pages.indexWhere((p) => p.id == _editingPageId);
        if (index != -1) {
          _pages[index] = SystemPage(
            id: _editingPageId!,
            name: _pageNameController.text,
            route: '/${_pageRouteController.text}',
            isActive: _pageActiveStatus,
          );
        }
      }
    });

    Navigator.pop(context);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(_editingPageId == null
            ? 'Page added successfully'
            : 'Page updated successfully'),
        backgroundColor: Colors.green,
      ),
    );
  }

  void _editPage(SystemPage page) {
    _pageNameController.text = page.name;
    _pageRouteController.text = page.route.substring(1);
    _pageActiveStatus = page.isActive;
    _editingPageId = page.id;
    _showAddPageDialog();
  }

  void _deletePage(String pageId) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Page'),
        content: const Text('Are you sure you want to delete this page?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              setState(() {
                _pages.removeWhere((p) => p.id == pageId);
              });
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Page deleted successfully'),
                  backgroundColor: Colors.green,
                ),
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
            ),
            child: const Text('Delete'),
          ),
        ],
      ),
    );
  }
}

class SystemPage {
  final String id;
  final String name;
  final String route;
  final bool isActive;

  SystemPage({
    required this.id,
    required this.name,
    required this.route,
    required this.isActive,
  });
}