import 'package:flutter/material.dart';

class DashboardPage extends StatelessWidget {
  const DashboardPage({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header Section
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Dashboard',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'A quick data overview of inventory',
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey[600],
                    ),
                  ),
                ],
              ),
              ElevatedButton.icon(
                onPressed: () {
                  // Add download report functionality
                },
                icon: const Icon(Icons.download, size: 18),
                label: const Text('Download Report'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 12,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),

          // Top 4 Cards - Inventory Overview
          SizedBox(
            height: 180,
            child: Row(
              children: [
                _buildStatusCard(
                  icon: Icons.inventory,
                  title: "Inventory Status",
                  status: "Good",
                  color: Colors.green,
                  value: "1,245 Items",
                  actionText: "View Inventory Report",
                ),
                const SizedBox(width: 16),
                _buildStatusCard(
                  icon: Icons.attach_money,
                  title: "Revenue",
                  status: "+12.5%",
                  color: Colors.blue,
                  value: "\$24,568",
                  actionText: "View Financial Report",
                ),
                const SizedBox(width: 16),
                _buildStatusCard(
                  icon: Icons.medical_services,
                  title: "Medicine Available",
                  status: "85%",
                  color: Colors.teal,
                  value: "1,058 Items",
                  actionText: "View Stock Report",
                ),
                const SizedBox(width: 16),
                _buildStatusCard(
                  icon: Icons.warning,
                  title: "Medicine Shortage",
                  status: "Critical",
                  color: Colors.orange,
                  value: "42 Items",
                  actionText: "View Shortage List",
                ),
              ],
            ),
          ),
          const SizedBox(height: 30),

          // Middle 2 Cards - Inventory & Sales
          Row(
            children: [
              Expanded(
                child: _buildDataCard(
                  title: "Inventory Overview",
                  items: [
                    DataItem("Total Medicines", "1,245", Colors.blue),
                    DataItem("Medicine Groups", "58", Colors.teal),
                  ],
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: _buildDataCard(
                  title: "Quick Reports",
                  items: [
                    DataItem("Medicines Sold", "328", Colors.purple),
                    DataItem("Invoices Generated", "142", Colors.orange),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 30),

          // Bottom 2 Cards - Pharmacy & Customers
          Row(
            children: [
              Expanded(
                child: _buildDataCard(
                  title: "My Pharmacy",
                  items: [
                    DataItem("Total Suppliers", "24", Colors.indigo),
                    DataItem("Total Users", "8", Colors.red),
                  ],
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: _buildDataCard(
                  title: "Customers",
                  items: [
                    DataItem("Total Customers", "1,842", Colors.green),
                    DataItem("Frequent Item", "Paracetamol", Colors.deepOrange),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // Status Card Widget (same as before)
  Widget _buildStatusCard({
    required IconData icon,
    required String title,
    required String status,
    required Color color,
    required String value,
    required String actionText,
  }) {
    return Expanded(
      child: Card(
        elevation: 1,
        child: Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: color.withOpacity(0.5), width: 2),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.1),
                blurRadius: 10,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.all(16),
                child: Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: color.withOpacity(0.1),
                        shape: BoxShape.circle,
                      ),
                      child: Icon(icon, color: color, size: 24),
                    ),
                    const SizedBox(width: 12),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          status,
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                            color: color,
                          ),
                        ),
                        Text(
                          title,
                          style: const TextStyle(
                            fontSize: 12,
                            color: Colors.grey,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Text(
                  value,
                  style: const TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                ),
              ),
              const Spacer(),
              Container(
                padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
                decoration: BoxDecoration(
                  color: color.withOpacity(0.2),
                  borderRadius: const BorderRadius.only(
                    bottomLeft: Radius.circular(6),
                    bottomRight: Radius.circular(6),
                  ),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      actionText,
                      style: TextStyle(
                        fontSize: 12,
                        color: color,
                      ),
                    ),
                    Icon(Icons.chevron_right, color: color, size: 20),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Data Card Widget (same as before)
  Widget _buildDataCard({
    required String title,
    required List<DataItem> items,
  }) {
    return Card(
      elevation: 5,
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: Colors.grey.withOpacity(0.3)),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                  ),
                  TextButton(
                    onPressed: () {},
                    child: const Text(
                      "Go to Configuration",
                      style: TextStyle(fontSize: 12),
                    ),
                  ),
                ],
              ),
            ),
            const Divider(height: 1, color: Colors.grey),
            Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: items.map((item) => Column(
                  children: [
                    Text(
                      item.value,
                      style: TextStyle(
                        fontSize: item.value.length > 6 ? 20 : 28,
                        fontWeight: FontWeight.bold,
                        color: item.color,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      item.label,
                      style: const TextStyle(
                        fontSize: 12,
                        color: Colors.grey,
                      ),
                    ),
                  ],
                )).toList(),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class DataItem {
  final String label;
  final String value;
  final Color color;

  DataItem(this.label, this.value, this.color);
}