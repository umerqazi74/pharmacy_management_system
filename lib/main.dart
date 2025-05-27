import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:pharmacy_management/application_setting_page.dart';
import 'package:pharmacy_management/payment_report_page.dart';
import 'package:pharmacy_management/quick_sale_page.dart';
import 'package:pharmacy_management/returns_page.dart';
import 'package:pharmacy_management/sales_history.dart';
import 'package:pharmacy_management/sales_report_page.dart';
import 'package:pharmacy_management/technical_help_page.dart';

import 'chat_with_visitors_page.dart';
import 'configuration_page.dart';
import 'contact_management_page.dart';
import 'covid19_page.dart';
import 'customer_directory_page.dart';
import 'dashboard_page.dart';
import 'loyalty_program_page.dart';
import 'medicine_groups_page.dart';
import 'medicines_list_page.dart';
import 'new_sales_page.dart';
import 'notification_page.dart';



void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Admin Dashboard',
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.light(
          surface: Colors.white,
          onSurface: Colors.black, // Text color on surfaces
        ),
        cardTheme: CardThemeData(
          color: Colors.white,
          surfaceTintColor: Colors.white,
        ),
        textTheme: TextTheme(
          bodyLarge: TextStyle(color: Colors.black),
          bodyMedium: TextStyle(color: Colors.black),
        ),
      ),
      home: const HomePage(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _selectedIndex = 0;
  String _selectedLanguage = 'English';
  final TextEditingController _searchController = TextEditingController();

  // Updated List of page widgets with new POS pages
  final List<Widget> _pages = [
    const DashboardPage(),
    // POS Pages
    const NewSalePage(),
    const QuickSalePage(),
    const SalesHistoryPage(),
    const ReturnsPage(),
    const CustomerDirectoryPage(),
    const LoyaltyProgramPage(),
    // Existing Pages
    const MedicinesListPage(),
    const MedicineGroupsPage(),
    const SalesReportPage(),
    const PaymentReportPage(),
    const ConfigurationPage(),
    const ContactManagementPage(),
    const NotificationsPage(),
    const ChatWithVisitorsPage(),
    const ApplicationSettingsPage(),
    const Covid19Page(),
    const TechnicalHelpPage(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          // App Bar (unchanged)
          Container(
            height: 60,
            color: Colors.white,
            padding: const EdgeInsets.symmetric(horizontal: 0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  width: 280,
                  color: Colors.black,
                  padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 20),
                  child: Row(
                    children: [
                      Image.asset(
                        'assets/logo.png',
                        height: 50,
                        width: 50,
                      ),
                      const SizedBox(width: 12),
                      const Text(
                        'Pharmacy Management',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 30),
                Container(
                  width: 450,
                  margin: const EdgeInsets.symmetric(vertical: 8,horizontal: 12),
                  decoration: BoxDecoration(
                    color: Colors.blue.withOpacity(0.09),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: TextField(
                    controller: _searchController,
                    decoration: InputDecoration(
                      prefixIcon: const Icon(Icons.search, color: Colors.grey),
                      hintText: 'Search...',
                      border: InputBorder.none,
                      contentPadding: const EdgeInsets.symmetric(vertical: 12),
                    ),
                  ),
                ),
                const SizedBox(width: 20),
                Container(
                  width: 140,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: DropdownButtonHideUnderline(
                    child: DropdownButton<String>(
                      value: _selectedLanguage,
                      icon: const Icon(Icons.arrow_drop_down, color: Colors.grey),
                      isExpanded: true,
                      items: <String>['English', 'Spanish', 'French', 'Arabic']
                          .map((String value) {
                        return DropdownMenuItem<String>(
                          value: value,
                          child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 16),
                            child: Row(
                              children: [
                                const Icon(Icons.translate, color: Colors.black87, size: 20),
                                const SizedBox(width: 8),
                                Text(value,style: TextStyle(color: Colors.black87),),
                              ],
                            ),
                          ),
                        );
                      }).toList(),
                      onChanged: (String? newValue) {
                        setState(() {
                          _selectedLanguage = newValue!;
                        });
                      },
                    ),
                  ),
                ),
                const SizedBox(width: 20),
                Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Icon(Icons.sunny,color: CupertinoColors.systemYellow,),
                        SizedBox(width: 10,),
                        Text("Good morning",style: TextStyle(color: Colors.black),)
                      ],
                    ),
                    SizedBox(
                      width: 250,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        mainAxisSize: MainAxisSize.max,
                        children: [
                          Text(
                            '14 January,  2025.    22:43:00',
                            style: const TextStyle(color: Colors.black),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),

          Expanded(
            child: Row(
              children: [
                // Sidebar
                Container(
                  width: 280,
                  color: Colors.grey[850],
                  child: Column(
                    children: [
                      // User profile tile
                      ListTile(
                        leading: Image.asset('assets/profile.png'),
                        title: const Text(
                          'salman.ui',
                          style: TextStyle(color: Colors.white),
                        ),
                        subtitle: const Text(
                          'super admin',
                          style: TextStyle(color: Colors.green, fontSize: 12),
                        ),
                        trailing: IconButton(
                          icon: const Icon(Icons.more_vert, color: Colors.white),
                          onPressed: () {},
                        ),
                      ),

                      // Updated Sidebar menu items with POS expansion tile
                      Expanded(
                        child: SingleChildScrollView(
                          child: Column(
                            children: [
                              _buildMenuItem(
                                index: 0,
                                icon: Icons.dashboard,
                                title: 'Dashboard',
                              ),

                              // New POS Expansion Tile (added at the top for quick access)
                              ExpansionTile(
                                leading: const Icon(Icons.point_of_sale, color: Colors.white, size: 24),
                                title: const Text('POS', style: TextStyle(color: Colors.white, fontSize: 14)),
                                children: [
                                  _buildMenuItem(
                                    index: 1,
                                    icon: Icons.add_shopping_cart,
                                    title: 'New Sale',
                                    indent: 16,
                                  ),
                                  _buildMenuItem(
                                    index: 2,
                                    icon: Icons.flash_on,
                                    title: 'Quick Sale',
                                    indent: 16,
                                  ),
                                  _buildMenuItem(
                                    index: 3,
                                    icon: Icons.history,
                                    title: 'Sales History',
                                    indent: 16,
                                  ),
                                  _buildMenuItem(
                                    index: 4,
                                    icon: Icons.assignment_return,
                                    title: 'Returns',
                                    indent: 16,
                                  ),
                                  _buildMenuItem(
                                    index: 5,
                                    icon: Icons.people,
                                    title: 'Customer Directory',
                                    indent: 16,
                                  ),
                                  _buildMenuItem(
                                    index: 6,
                                    icon: Icons.card_giftcard,
                                    title: 'Loyalty Program',
                                    indent: 16,
                                  ),
                                ],
                              ),

                              // Existing Expansion Tiles
                              ExpansionTile(
                                leading: const Icon(Icons.inventory, color: Colors.white, size: 24),
                                title: const Text('Inventory', style: TextStyle(color: Colors.white, fontSize: 14)),
                                children: [
                                  _buildMenuItem(
                                    index: 7,
                                    icon: Icons.medication,
                                    title: 'List of Medicines',
                                    indent: 16,
                                  ),
                                  _buildMenuItem(
                                    index: 8,
                                    icon: Icons.medication_outlined,
                                    title: 'Medicine Groups',
                                    indent: 16,
                                  ),
                                ],
                              ),

                              ExpansionTile(
                                leading: const Icon(Icons.assessment, color: Colors.white, size: 24),
                                title: const Text('Reports', style: TextStyle(color: Colors.white, fontSize: 14)),
                                children: [
                                  _buildMenuItem(
                                    index: 9,
                                    icon: Icons.bar_chart,
                                    title: 'Sales Reports',
                                    indent: 16,
                                  ),
                                  _buildMenuItem(
                                    index: 10,
                                    icon: Icons.payment,
                                    title: 'Payment Reports',
                                    indent: 16,
                                  ),
                                ],
                              ),

                              _buildMenuItem(
                                index: 11,
                                icon: Icons.settings,
                                title: 'Configuration',
                              ),

                              const Divider(height: 20, thickness: 1),

                              _buildMenuItem(
                                index: 12,
                                icon: Icons.contacts,
                                title: 'Contact Management',
                              ),
                              _buildMenuItem(
                                index: 13,
                                icon: Icons.notifications,
                                title: 'Notifications',
                              ),
                              _buildMenuItem(
                                index: 14,
                                icon: Icons.chat,
                                title: 'Chat with Visitors',
                              ),

                              const Divider(height: 20, thickness: 1),

                              _buildMenuItem(
                                index: 15,
                                icon: Icons.settings_applications,
                                title: 'Application Settings',
                              ),
                              _buildMenuItem(
                                index: 16,
                                icon: Icons.medical_services,
                                title: 'COVID-19',
                              ),
                              _buildMenuItem(
                                index: 17,
                                icon: Icons.support,
                                title: 'Get Technical Help',
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                // Main content area
                Expanded(
                  child: Container(
                    padding: EdgeInsets.only(top: 10),
                    decoration:  BoxDecoration(
                      color: Colors.blue.withOpacity(0.05),
                    ),
                    child: _pages[_selectedIndex],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMenuItem({
    required int index,
    required IconData icon,
    required String title,
    double indent = 0,
  }) {
    return Padding(
      padding: EdgeInsets.only(left: indent, right: 0, top: 4, bottom: 4),
      child: Container(
        decoration: BoxDecoration(
          color: _selectedIndex == index
              ? Colors.green.withOpacity(0.6)
              : Colors.transparent,
        ),
        child: ListTile(
          leading: Icon(icon, color: Colors.white, size: 24),
          title: Text(
            title,
            style: TextStyle(
              color: Colors.white,
              fontSize: 14,
              fontWeight: _selectedIndex == index
                  ? FontWeight.w500
                  : FontWeight.normal,
            ),
          ),
          contentPadding: const EdgeInsets.symmetric(horizontal: 12),
          dense: true,
          onTap: () {
            setState(() {
              _selectedIndex = index;
            });
          },
        ),
      ),
    );
  }
}
