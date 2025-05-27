import 'package:flutter/material.dart';



// List of Medicines Page
class MedicinesListPage extends StatefulWidget {
  const MedicinesListPage({super.key});

  @override
  State<MedicinesListPage> createState() => _MedicinesListPageState();
}

class _MedicinesListPageState extends State<MedicinesListPage> {
  bool addMedPage = false;
  bool detailPage = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blue.withOpacity(0.01),
      body:addMedPage?addMedicinePage() :
          detailPage?medDetailPage("Medicine 1"):
      Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header with breadcrumb and add button
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Inventory > List of Medicines (498)',
                  style: TextStyle(
                    fontSize: 20,
                    color: Colors.grey[900],
                    fontWeight: FontWeight.bold
                  ),
                ),
                ElevatedButton.icon(
                  onPressed: () {
                    setState(() {
                      addMedPage = true;
                    });
                  },
                  icon: const Icon(Icons.add, size: 18),
                  label: const Text('Add Item'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.red,
                    foregroundColor: Colors.white,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),

            // Subheading
             Text(
              'List of medicines available for sales',
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey.shade600,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),

            // Search and filter row
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  width: MediaQuery.of(context).size.width/3,
                  margin: const EdgeInsets.symmetric(vertical: 8,horizontal: 12),
                  decoration: BoxDecoration(
                    color: Colors.blue.withOpacity(0.09),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: TextField(
                    decoration: InputDecoration(
                      prefixIcon: const Icon(Icons.search, color: Colors.grey),
                      hintText: 'Search...',
                      border: InputBorder.none,
                      contentPadding: const EdgeInsets.symmetric(vertical: 12),
                    ),
                  ),
                ),
                const SizedBox(width: 16),
                DropdownButton<String>(
                  dropdownColor: Colors.white,
                  hint: const Text('Select Group',style: TextStyle(color: Colors.black),),
                  items: <String>['All', 'Antibiotics', 'Pain Relief', 'Vitamins']
                      .map((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(value,style: TextStyle(color: Colors.black)),
                    );
                  }).toList(),
                  onChanged: (_) {},
                ),
              ],
            ),
            const SizedBox(height: 16),

            // Medicines Table
            Expanded(
              child: Container(
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey,width: 1),
                  borderRadius: BorderRadius.circular(4),
                ),
                child: DataTable(
                  // horizontalMargin: MediaQuery.of(context).size.width/4,
                  columnSpacing: MediaQuery.of(context).size.width/9,

                  columns: const [
                    DataColumn(label: Text('Medicine Name',style: TextStyle(color: Colors.black,fontWeight: FontWeight.bold),)),
                    DataColumn(label: Text('Medicine ID',style: TextStyle(color: Colors.black,fontWeight: FontWeight.bold),)),
                    DataColumn(label: Text('Group Name',style: TextStyle(color: Colors.black,fontWeight: FontWeight.bold),)),
                    DataColumn(label: Text('QTY in Stock',style: TextStyle(color: Colors.black,fontWeight: FontWeight.bold),)),
                    DataColumn(label: Text('Action',style: TextStyle(color: Colors.black,fontWeight: FontWeight.bold),)),
                  ],
                  rows: List<DataRow>.generate(
                    5,
                        (index) => DataRow(
                      cells: [
                        DataCell(Text('Medicine ${index + 1}',style: TextStyle(color: Colors.black),)),
                        DataCell(Text('MED00${index + 1}',style: TextStyle(color: Colors.black),)),
                        DataCell(Text(index % 3 == 0 ? 'Antibiotics' : 'Pain Relief',style: TextStyle(color: Colors.black),)),
                        DataCell(Text('${(index + 1) * 25}',style: TextStyle(color: Colors.black),)),
                        DataCell(
                          IconButton(
                            icon: const Icon(Icons.visibility),
                            onPressed: () {
                              setState(() {
                                detailPage = true;
                              });
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 16),

            // Pagination
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                TextButton(
                  onPressed: () {},
                  child: const Text('Previous'),
                ),
                const SizedBox(width: 8),
                const Text('1'),
                const SizedBox(width: 8),
                TextButton(
                  onPressed: () {},
                  child: const Text('Next'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget medDetailPage(String medicineName){
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header with breadcrumb and edit button
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                GestureDetector(
                  onTap: (){
                    setState(() {
                      addMedPage = false;
                      detailPage = false;
                    });
                  },
                  child: Text(
                    'Inventory > List of Medicines > $medicineName',
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.grey[700],
                    ),
                  ),
                ),
                ElevatedButton.icon(
                  onPressed: () {},
                  icon: const Icon(Icons.edit, size: 18),
                  label: const Text('Edit'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue,
                    foregroundColor: Colors.white,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),

            // Subheading
            const Text(
              'Medicine details',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),

            // Search field
            SizedBox(
              width: 600,
              child: TextField(
                decoration: InputDecoration(
                  hintText: 'Search',
                  prefixIcon: const Icon(Icons.search),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 16),

            // Medicine Info Card
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Expanded(
                  child: Card(
                    color: Colors.white,
                    elevation: 2,
                    shape: RoundedRectangleBorder(
                      side: BorderSide(color: Colors.grey.shade300),
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        children: [
                          const Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                'Medicine',
                                style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16,
                                    color: Colors.black
                                ),
                              ),
                            ],
                          ),
                          const Divider(),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text('Medicine ID: MED00123',
                                    style: TextStyle(
                                        fontSize: 16,
                                        color: Colors.black
                                    ),),
                                  SizedBox(height: 8),
                                  Text('Group: Antibiotics',style: TextStyle(
                                      fontSize: 16,
                                      color: Colors.black
                                  ),),
                                ],
                              ),

                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ),

                // Inventory Card
                Expanded(
                  child: Card(
                    color: Colors.white,
                    elevation: 2,
                    shape: RoundedRectangleBorder(
                      side: BorderSide(color: Colors.grey.shade300),
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        children: [
                          const Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                'Inventory',
                                style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16,
                                    color: Colors.black
                                ),
                              ),
                              Text('Send Stock Request >>',style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 12,
                                  color: Colors.black
                              ),)
                            ],
                          ),
                          const Divider(),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              Column(
                                children: [
                                  const Text(
                                    'Lifetime Supply',
                                    style: TextStyle(fontSize: 12,color: Colors.black),
                                  ),
                                  Text(
                                    '1,250',
                                    style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.blue[700],
                                    ),
                                  ),
                                ],
                              ),
                              Column(
                                children: [
                                  const Text(
                                    'Lifetime Sales',
                                    style: TextStyle(fontSize: 12,color: Colors.black),
                                  ),
                                  Text(
                                    '1,200',
                                    style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.green[700],
                                    ),
                                  ),
                                ],
                              ),
                              Column(
                                children: [
                                  const Text(
                                    'Stock Left',
                                    style: TextStyle(fontSize: 12,color: Colors.black),
                                  ),
                                  Text(
                                    '50',
                                    style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.orange[700],
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 16),

            // How to Use Section
            Card(
              elevation: 2,
              color: Colors.white,
              shape: RoundedRectangleBorder(
                side: BorderSide(color: Colors.grey.shade300),
                borderRadius: BorderRadius.circular(4),
              ),
              child: const Padding(
                padding: EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'How to Use',
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                          color: Colors.black
                      ),
                    ),
                    Divider(),
                    Text(
                      'Take one tablet daily after meals. Do not exceed recommended dosage. '
                          'Consult your doctor if symptoms persist for more than 3 days.',
                      style: TextStyle(color: Colors.black),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),

            // Side Effects Section
            Card(
              elevation: 2,
              color: Colors.white,
              shape: RoundedRectangleBorder(
                side: BorderSide(color: Colors.grey.shade300),
                borderRadius: BorderRadius.circular(4),
              ),
              child: const Padding(
                padding: EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Side Effects',
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                          color: Colors.black
                      ),
                    ),
                    Divider(),
                    Text(
                      'May cause mild stomach upset, nausea, or headache. '
                          'Serious side effects are rare but may include allergic reactions. '
                          'Discontinue use and consult doctor if severe side effects occur.',
                      style: TextStyle(color: Colors.black),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),

            // Delete Button
            OutlinedButton.icon(
              onPressed: () {
                // Add delete confirmation dialog
              },
              icon: const Icon(Icons.delete, color: Colors.red),
              label: const Text(
                'Delete Medicine',
                style: TextStyle(color: Colors.red),
              ),
              style: OutlinedButton.styleFrom(
                side: const BorderSide(color: Colors.red),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget addMedicinePage(){
    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Breadcrumb
          GestureDetector(
            onTap: (){
              setState(() {
                addMedPage = false;
                detailPage = false;
              });

            },
            child: Text(
              'Inventory > List of Medicines > Add New Medicine',
              style: TextStyle(
                fontSize: 16,
                color: Colors.grey[700],
              ),
            ),
          ),
          const SizedBox(height: 8),

          // Subheading
          const Text(
            'All fields are required except optional',
            style: TextStyle(
              fontSize: 14,
              fontStyle: FontStyle.italic,
            ),
          ),
          const SizedBox(height: 16),

          // Medicine Name and ID
          Row(
            children: [
              Expanded(
                child: TextField(
                  decoration: const InputDecoration(
                    labelText: 'Medicine Name',
                    border: OutlineInputBorder(),
                  ),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: TextField(
                  decoration: const InputDecoration(
                    labelText: 'Medicine ID',
                    border: OutlineInputBorder(),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),

          // Medicine Group and Quantity
          Row(
            children: [
              Expanded(
                child: DropdownButtonFormField<String>(
                  decoration: const InputDecoration(
                    labelText: 'Medicine Group',
                    border: OutlineInputBorder(),
                  ),
                  items: <String>['Antibiotics', 'Pain Relief', 'Vitamins']
                      .map((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(value),
                    );
                  }).toList(),
                  onChanged: (_) {},
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: TextField(
                  decoration: const InputDecoration(
                    labelText: 'Quantity',
                    border: OutlineInputBorder(),
                  ),
                  keyboardType: TextInputType.number,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),

          // How to Use
          TextField(
            decoration: const InputDecoration(
              labelText: 'How to Use',
              border: OutlineInputBorder(),
              alignLabelWithHint: true,
            ),
            maxLines: 3,
          ),
          const SizedBox(height: 16),

          // Side Effects
          TextField(
            decoration: const InputDecoration(
              labelText: 'Side Effects',
              border: OutlineInputBorder(),
              alignLabelWithHint: true,
            ),
            maxLines: 3,
          ),
          const SizedBox(height: 24),

          // Save Button
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.blue,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(
                horizontal: 32,
                vertical: 16,
              ),
            ),
            child: const Text('Save Details'),
          ),
        ],
      ),
    );
  }

}

