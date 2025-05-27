import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

class Covid19Page extends StatefulWidget {
  const Covid19Page({super.key});

  @override
  State<Covid19Page> createState() => _Covid19PageState();
}

class _Covid19PageState extends State<Covid19Page> {
  final List<CovidTest> _tests = [
    CovidTest(
      id: 'CT-1001',
      patient: 'John Smith',
      testDate: DateTime.now().subtract(const Duration(days: 3)),
      result: 'Positive',
      variant: 'Omicron',
      status: 'Completed',
    ),
    CovidTest(
      id: 'CT-1002',
      patient: 'Maria Garcia',
      testDate: DateTime.now().subtract(const Duration(days: 2)),
      result: 'Negative',
      variant: '',
      status: 'Completed',
    ),
    CovidTest(
      id: 'CT-1003',
      patient: 'Robert Johnson',
      testDate: DateTime.now().subtract(const Duration(days: 1)),
      result: 'Pending',
      variant: '',
      status: 'Processing',
    ),
  ];

  final List<VaccinationRecord> _vaccinations = [
    VaccinationRecord(
      id: 'VAC-2001',
      patient: 'John Smith',
      vaccine: 'Pfizer-BioNTech',
      dose: 1,
      date: DateTime.now().subtract(const Duration(days: 30)),
      nextDose: DateTime.now().add(const Duration(days: 30)),
    ),
    VaccinationRecord(
      id: 'VAC-2002',
      patient: 'Maria Garcia',
      vaccine: 'Moderna',
      dose: 2,
      date: DateTime.now().subtract(const Duration(days: 15)),
      nextDose: null,
    ),
  ];

  final List<CovidStat> _stats = [
    CovidStat(day: 'Mon', cases: 12, tests: 45),
    CovidStat(day: 'Tue', cases: 18, tests: 52),
    CovidStat(day: 'Wed', cases: 15, tests: 48),
    CovidStat(day: 'Thu', cases: 22, tests: 60),
    CovidStat(day: 'Fri', cases: 25, tests: 65),
  ];

  @override
  Widget build(BuildContext context) {
    final positiveTests = _tests.where((t) => t.result == 'Positive').length;
    final negativeTests = _tests.where((t) => t.result == 'Negative').length;
    final pendingTests = _tests.where((t) => t.result == 'Pending').length;

    return Scaffold(
      backgroundColor: Colors.grey[50],
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
                  'Health > COVID-19 Management',
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.grey[700],
                    fontWeight: FontWeight.w500,
                  ),
                ),
                ElevatedButton.icon(
                  onPressed: _addNewTest,
                  icon: const Icon(Icons.add, size: 18),
                  label: const Text('New Test'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue[600],
                    foregroundColor: Colors.white,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              'Track tests, vaccinations, and community statistics',
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey[600],
              ),
            ),
            const SizedBox(height: 20),

            // Summary Cards
            SizedBox(
              height: 120,
              child: ListView(
                scrollDirection: Axis.horizontal,
                children: [
                  _buildSummaryCard(
                    title: 'Positive Tests',
                    value: positiveTests.toDouble(),
                    color: Colors.red[600]!,
                    icon: Icons.warning,
                  ),
                  const SizedBox(width: 12),
                  _buildSummaryCard(
                    title: 'Negative Tests',
                    value: negativeTests.toDouble(),
                    color: Colors.green[600]!,
                    icon: Icons.check_circle,
                  ),
                  const SizedBox(width: 12),
                  _buildSummaryCard(
                    title: 'Pending Tests',
                    value: pendingTests.toDouble(),
                    color: Colors.orange[600]!,
                    icon: Icons.pending,
                  ),
                  const SizedBox(width: 12),
                  _buildSummaryCard(
                    title: 'Vaccinations',
                    value: _vaccinations.length.toDouble(),
                    color: Colors.blue[600]!,
                    icon: Icons.medical_services,
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),

            // Statistics Charts
            _buildSectionTitle('Community Statistics'),
            Card(
              elevation: 2,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    SizedBox(
                      height: 250,
                      child: SfCartesianChart(
                        primaryXAxis: CategoryAxis(),
                        series: <CartesianSeries>[
                          ColumnSeries<CovidStat, String>(
                            dataSource: _stats,
                            xValueMapper: (CovidStat stat, _) => stat.day,
                            yValueMapper: (CovidStat stat, _) => stat.cases,
                            name: 'Positive Cases',
                            color: Colors.red[400],
                          ),
                          LineSeries<CovidStat, String>(
                            dataSource: _stats,
                            xValueMapper: (CovidStat stat, _) => stat.day,
                            yValueMapper: (CovidStat stat, _) => stat.tests,
                            name: 'Tests Administered',
                            color: Colors.blue[400],
                            markerSettings: const MarkerSettings(isVisible: true),
                          ),
                        ],
                        legend: const Legend(isVisible: true),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 20),

            // Test Results
            _buildSectionTitle('Recent Test Results'),
            Card(
              elevation: 2,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: DataTable(
                        columns: const [
                          DataColumn(label: Text('Test ID')),
                          DataColumn(label: Text('Patient')),
                          DataColumn(label: Text('Date')),
                          DataColumn(label: Text('Result')),
                          DataColumn(label: Text('Variant')),
                          DataColumn(label: Text('Status')),
                          DataColumn(label: Text('Actions')),
                        ],
                        rows: _tests.map((test) => DataRow(
                          cells: [
                            DataCell(Text(test.id)),
                            DataCell(Text(test.patient)),
                            DataCell(Text(DateFormat('MMM d').format(test.testDate))),
                            DataCell(
                              Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 8,
                                  vertical: 4,
                                ),
                                decoration: BoxDecoration(
                                  color: test.result == 'Positive'
                                      ? Colors.red[50]
                                      : test.result == 'Negative'
                                      ? Colors.green[50]
                                      : Colors.orange[50],
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: Text(
                                  test.result,
                                  style: TextStyle(
                                    color: test.result == 'Positive'
                                        ? Colors.red[800]
                                        : test.result == 'Negative'
                                        ? Colors.green[800]
                                        : Colors.orange[800],
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ),
                            ),
                            DataCell(Text(test.variant.isEmpty ? '-' : test.variant)),
                            DataCell(
                              Chip(
                                label: Text(
                                  test.status,
                                  style: TextStyle(
                                    color: test.status == 'Completed'
                                        ? Colors.green[800]
                                        : Colors.blue[800],
                                  ),
                                ),
                                backgroundColor: test.status == 'Completed'
                                    ? Colors.green[50]
                                    : Colors.blue[50],
                              ),
                            ),
                            DataCell(Row(
                              children: [
                                IconButton(
                                  icon: const Icon(Icons.edit, size: 20),
                                  color: Colors.blue[600],
                                  onPressed: () => _editTest(test),
                                ),
                                IconButton(
                                  icon: const Icon(Icons.delete, size: 20),
                                  color: Colors.red[600],
                                  onPressed: () => _deleteTest(test.id),
                                ),
                              ],
                            )),
                          ],
                        )).toList(),
                      ),
                    ),
                    const SizedBox(height: 12),
                    ElevatedButton.icon(
                      onPressed: _addNewTest,
                      icon: const Icon(Icons.add),
                      label: const Text('Record New Test'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blue[600],
                        foregroundColor: Colors.white,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 20),

            // Vaccination Records
            _buildSectionTitle('Vaccination Records'),
            Card(
              elevation: 2,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: DataTable(
                        columns: const [
                          DataColumn(label: Text('Record ID')),
                          DataColumn(label: Text('Patient')),
                          DataColumn(label: Text('Vaccine')),
                          DataColumn(label: Text('Dose')),
                          DataColumn(label: Text('Date')),
                          DataColumn(label: Text('Next Dose')),
                          DataColumn(label: Text('Actions')),
                        ],
                        rows: _vaccinations.map((vax) => DataRow(
                          cells: [
                            DataCell(Text(vax.id)),
                            DataCell(Text(vax.patient)),
                            DataCell(Text(vax.vaccine)),
                            DataCell(Text('Dose ${vax.dose}')),
                            DataCell(Text(DateFormat('MMM d').format(vax.date))),
                            DataCell(vax.nextDose == null
                                ? const Text('Completed')
                                : Text(DateFormat('MMM d').format(vax.nextDose!))),
                            DataCell(Row(
                              children: [
                                IconButton(
                                  icon: const Icon(Icons.edit, size: 20),
                                  color: Colors.blue[600],
                                  onPressed: () => _editVaccination(vax),
                                ),
                                IconButton(
                                  icon: const Icon(Icons.delete, size: 20),
                                  color: Colors.red[600],
                                  onPressed: () => _deleteVaccination(vax.id),
                                ),
                              ],
                            )),
                          ],
                        )).toList(),
                      ),
                    ),
                    const SizedBox(height: 12),
                    ElevatedButton.icon(
                      onPressed: _addNewVaccination,
                      icon: const Icon(Icons.add),
                      label: const Text('Add Vaccination Record'),
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

            // Resources Section
            _buildSectionTitle('COVID-19 Resources'),
            Card(
              elevation: 2,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Latest Guidelines',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                    const SizedBox(height: 8),
                    _buildResourceItem(
                      'CDC COVID-19 Guidelines',
                      'https://www.cdc.gov/coronavirus',
                    ),
                    _buildResourceItem(
                      'WHO Technical Guidance',
                      'https://www.who.int/emergencies/diseases/novel-coronavirus-2019',
                    ),
                    _buildResourceItem(
                      'Local Health Department',
                      'https://www.localhealth.gov/covid',
                    ),
                    const SizedBox(height: 12),
                    const Text(
                      'Vaccination Information',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                    const SizedBox(height: 8),
                    _buildResourceItem(
                      'Vaccine Types and Efficacy',
                      'https://www.cdc.gov/vaccines/covid-19',
                    ),
                    _buildResourceItem(
                      'Booster Shot Recommendations',
                      'https://www.cdc.gov/vaccines/covid-19/clinical-considerations',
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

  Widget _buildSummaryCard({
    required String title,
    required double value,
    required Color color,
    required IconData icon,
  }) {
    return Card(
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(6),
                  decoration: BoxDecoration(
                    color: color.withOpacity(0.1),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(icon, size: 18, color: color),
                ),
                const SizedBox(width: 12),
                Text(
                  title,
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey[700],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              value.toInt().toString(),
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: color,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildResourceItem(String title, String url) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: InkWell(
        onTap: () => _openUrl(url),
        child: Row(
          children: [
            const Icon(Icons.link, size: 16, color: Colors.blue),
            const SizedBox(width: 8),
            Text(
              title,
              style: const TextStyle(
                color: Colors.blue,
                decoration: TextDecoration.underline,
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _addNewTest() {
    // Implementation would go here
  }

  void _editTest(CovidTest test) {
    // Implementation would go here
  }

  void _deleteTest(String testId) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Test Record'),
        content: const Text('Are you sure you want to delete this test record?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              setState(() {
                _tests.removeWhere((t) => t.id == testId);
              });
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Test record deleted'),
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

  void _addNewVaccination() {
    // Implementation would go here
  }

  void _editVaccination(VaccinationRecord vax) {
    // Implementation would go here
  }

  void _deleteVaccination(String vaxId) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Vaccination Record'),
        content: const Text('Are you sure you want to delete this vaccination record?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              setState(() {
                _vaccinations.removeWhere((v) => v.id == vaxId);
              });
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Vaccination record deleted'),
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

  void _openUrl(String url) {
    // Implementation would use url_launcher package
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Opening: $url'),
        backgroundColor: Colors.blue[600],
      ),
    );
  }
}

class CovidTest {
  final String id;
  final String patient;
  final DateTime testDate;
  final String result;
  final String variant;
  final String status;

  CovidTest({
    required this.id,
    required this.patient,
    required this.testDate,
    required this.result,
    required this.variant,
    required this.status,
  });
}

class VaccinationRecord {
  final String id;
  final String patient;
  final String vaccine;
  final int dose;
  final DateTime date;
  final DateTime? nextDose;

  VaccinationRecord({
    required this.id,
    required this.patient,
    required this.vaccine,
    required this.dose,
    required this.date,
    this.nextDose,
  });
}

class CovidStat {
  final String day;
  final int cases;
  final int tests;

  CovidStat({
    required this.day,
    required this.cases,
    required this.tests,
  });
}