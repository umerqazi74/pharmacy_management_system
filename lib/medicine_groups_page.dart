import 'package:flutter/material.dart';

class MedicineGroupsPage extends StatefulWidget {
  const MedicineGroupsPage({super.key});

  @override
  State<MedicineGroupsPage> createState() => _MedicineGroupsPageState();
}

class _MedicineGroupsPageState extends State<MedicineGroupsPage> {
  final List<MedicineGroup> _groups = [
    MedicineGroup(id: 'GP001', name: 'Antibiotics', medicineCount: 42),
    MedicineGroup(id: 'GP002', name: 'Pain Relief', medicineCount: 35),
    MedicineGroup(id: 'GP003', name: 'Vitamins', medicineCount: 28),
    MedicineGroup(id: 'GP004', name: 'Antihistamines', medicineCount: 15),
    MedicineGroup(id: 'GP005', name: 'Antacids', medicineCount: 12),
  ];

  final _formKey = GlobalKey<FormState>();
  final _groupNameController = TextEditingController();
  bool _showAddForm = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blue.withOpacity(0.01),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header with title and add button
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Inventory > Medicine Groups',
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.grey[700],
                    fontWeight: FontWeight.w500,
                  ),
                ),
                ElevatedButton.icon(
                  onPressed: () {
                    setState(() {
                      _showAddForm = !_showAddForm;
                      if (!_showAddForm) {
                        _groupNameController.clear();
                      }
                    });
                  },
                  icon: Icon(
                    _showAddForm ? Icons.close : Icons.add,
                    size: 18,
                  ),
                  label: Text(_showAddForm ? 'Cancel' : 'Add Group'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: _showAddForm ? Colors.grey[600] : Colors.red[600],
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),

            // Subheader
            Text(
              'Manage medicine categories and groups',
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey[600],
              ),
            ),
            const SizedBox(height: 16),

            // Add Group Form (conditionally shown)
            if (_showAddForm) ...[
              Card(
                elevation: 4,
                color: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Add New Medicine Group',
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 16),
                        TextFormField(
                          controller: _groupNameController,
                          decoration: InputDecoration(
                            labelText: 'Group Name',
                            border: OutlineInputBorder(),
                            prefixIcon: Icon(Icons.category),
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter a group name';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 16),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            TextButton(

                              onPressed: () {
                                setState(() {
                                  _showAddForm = false;
                                  _groupNameController.clear();
                                });
                              },
                              child: const Text('Cancel',style: TextStyle(color: Colors.black87),),
                            ),
                            const SizedBox(width: 8),
                            ElevatedButton(
                              onPressed: () {
                                if (_formKey.currentState!.validate()) {
                                  setState(() {
                                    _groups.add(MedicineGroup(
                                      id: 'GP${_groups.length + 1}'.padLeft(3, '0'),
                                      name: _groupNameController.text,
                                      medicineCount: 0,
                                    ));
                                    _showAddForm = false;
                                    _groupNameController.clear();
                                  });
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                      content: Text('${_groupNameController.text} group added'),
                                      backgroundColor: Colors.green,
                                    ),
                                  );
                                }
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.blue[600],
                                foregroundColor: Colors.white,
                              ),
                              child: const Text('Save Group'),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 16),
            ],

            // Search and filter row
            Row(
              children: [
                Expanded(
                  child: TextField(
                    decoration: InputDecoration(
                      hintText: 'Search medicine groups',
                      prefixIcon: const Icon(Icons.search),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 16),
                DropdownButton<String>(
                  hint: const Text('Sort by',style: TextStyle(color: Colors.black87),),
                  iconDisabledColor: Colors.black87,
                  iconEnabledColor: Colors.black87,
                  elevation: 2,
                  items: const [
                    DropdownMenuItem(value: 'name', child: Text('Name (A-Z)')),
                    DropdownMenuItem(value: 'count', child: Text('Medicine Count')),
                  ],
                  onChanged: (value) {
                    setState(() {
                      if (value == 'name') {
                        _groups.sort((a, b) => a.name.compareTo(b.name));
                      } else if (value == 'count') {
                        _groups.sort((a, b) => b.medicineCount.compareTo(a.medicineCount));
                      }
                    });
                  },
                ),
              ],
            ),
            const SizedBox(height: 16),

            // Groups List
            Expanded(
              child: ListView.separated(
                itemCount: _groups.length,
                separatorBuilder: (context, index) => const Divider(height: 1),
                itemBuilder: (context, index) {
                  final group = _groups[index];
                  return Card(
                    elevation: 1,
                    margin: EdgeInsets.zero,
                    color: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: ListTile(
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 12,
                      ),
                      leading: Container(
                        width: 48,
                        height: 48,
                        decoration: BoxDecoration(
                          color: _getGroupColor(index).withOpacity(0.2),
                          shape: BoxShape.circle,
                        ),
                        child: Icon(
                          Icons.category,
                          color: _getGroupColor(index),
                        ),
                      ),
                      title: Text(
                        group.name,
                        style: const TextStyle(
                          fontWeight: FontWeight.w500,
                          color: Colors.black
                        ),
                      ),
                      subtitle: Text(
                        'ID: ${group.id} • ${group.medicineCount} medicines',
                        style: const TextStyle(
                            fontWeight: FontWeight.w500,
                            color: Colors.black
                        ),
                      ),
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          IconButton(
                            icon: const Icon(Icons.edit, size: 20),
                            color: Colors.blue[600],
                            onPressed: () => _editGroup(group),
                          ),
                          IconButton(
                            icon: const Icon(Icons.delete, size: 20),
                            color: Colors.red[600],
                            onPressed: () => _confirmDelete(group),
                          ),
                        ],
                      ),
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

  Color _getGroupColor(int index) {
    final colors = [
      Colors.blue[600]!,
      Colors.green[600]!,
      Colors.orange[600]!,
      Colors.purple[600]!,
      Colors.teal[600]!,
      Colors.red[600]!,
      Colors.indigo[600]!,
    ];
    return colors[index % colors.length];
  }

  void _editGroup(MedicineGroup group) {
    _groupNameController.text = group.name;
    setState(() {
      _showAddForm = true;
    });
  }

  void _confirmDelete(MedicineGroup group) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Group'),
        content: Text('Are you sure you want to delete ${group.name}?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              setState(() {
                _groups.remove(group);
              });
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('${group.name} group deleted'),
                  backgroundColor: Colors.red,
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

  @override
  void dispose() {
    _groupNameController.dispose();
    super.dispose();
  }
}

class MedicineGroup {
  final String id;
  final String name;
  final int medicineCount;

  MedicineGroup({
    required this.id,
    required this.name,
    required this.medicineCount,
  });
}