import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class TechnicalHelpPage extends StatefulWidget {
  const TechnicalHelpPage({super.key});

  @override
  State<TechnicalHelpPage> createState() => _TechnicalHelpPageState();
}

class _TechnicalHelpPageState extends State<TechnicalHelpPage> {
  final List<FAQItem> _faqs = [
    FAQItem(
      question: "How do I reset my password?",
      answer: "Go to Settings > Account > Reset Password. A link will be sent to your registered email.",
    ),
    FAQItem(
      question: "Why is my inventory not syncing?",
      answer: "Check your internet connection and restart the app. If issues persist, contact support.",
    ),
    FAQItem(
      question: "How to update the software?",
      answer: "Updates are automatic. You'll receive a notification when a new version is available.",
    ),
  ];

  bool _isDiagnosing = false;
  String _diagnosisResult = '';

  @override
  Widget build(BuildContext context) {
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
                  'Support > Technical Help',
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.grey[700],
                    fontWeight: FontWeight.w500,
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.refresh),
                  onPressed: _refreshPage,
                  tooltip: 'Refresh',
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              'Get assistance with technical issues and system troubleshooting',
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey[600],
              ),
            ),
            const SizedBox(height: 20),

            // Support Options Cards
            _buildSectionTitle('Support Options'),
            Wrap(
              spacing: 12,
              runSpacing: 12,
              children: [
                _buildSupportOptionCard(
                  icon: Icons.chat,
                  title: 'Live Chat',
                  color: Colors.green[600]!,
                  onTap: () => _launchChatSupport(),
                ),
                _buildSupportOptionCard(
                  icon: Icons.email,
                  title: 'Email Support',
                  color: Colors.blue[600]!,
                  onTap: () => _launchEmailSupport(),
                ),
                _buildSupportOptionCard(
                  icon: Icons.phone,
                  title: 'Call Support',
                  color: Colors.orange[600]!,
                  onTap: () => _launchPhoneSupport(),
                ),
                _buildSupportOptionCard(
                  icon: Icons.video_call,
                  title: 'Video Call',
                  color: Colors.purple[600]!,
                  onTap: () => _launchVideoSupport(),
                ),
              ],
            ),
            const SizedBox(height: 20),

            // System Diagnostics
            _buildSectionTitle('System Diagnostics'),
            Card(
              elevation: 2,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    const Text(
                      'Run diagnostics to check for system issues',
                      style: TextStyle(fontSize: 14),
                    ),
                    const SizedBox(height: 12),
                    ElevatedButton.icon(
                      onPressed: _isDiagnosing ? null : _runDiagnostics,
                      icon: _isDiagnosing
                          ? const SizedBox(
                        width: 16,
                        height: 16,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      )
                          :  Icon(Icons.monitor_heart_outlined),
                      label: Text(_isDiagnosing ? 'Diagnosing...' : 'Start Diagnostics'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blue[600],
                        foregroundColor: Colors.white,
                        minimumSize: const Size(double.infinity, 48),
                      ),
                    ),
                    const SizedBox(height: 12),
                    if (_diagnosisResult.isNotEmpty)
                      Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: _diagnosisResult.contains('No issues')
                              ? Colors.green[50]
                              : Colors.orange[50],
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Row(
                          children: [
                            Icon(
                              _diagnosisResult.contains('No issues')
                                  ? Icons.check_circle
                                  : Icons.warning,
                              color: _diagnosisResult.contains('No issues')
                                  ? Colors.green[600]
                                  : Colors.orange[600],
                            ),
                            const SizedBox(width: 8),
                            Expanded(
                              child: Text(
                                _diagnosisResult,
                                style: TextStyle(
                                  color: Colors.grey[800],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 20),

            // Frequently Asked Questions
            _buildSectionTitle('Frequently Asked Questions'),
            ..._faqs.map((faq) => _buildFAQCard(faq)).toList(),
            const SizedBox(height: 20),

            // Documentation Links
            _buildSectionTitle('Documentation'),
            Card(
              elevation: 2,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildDocumentationLink(
                      'User Manual (PDF)',
                      'https://example.com/manual.pdf',
                    ),
                    _buildDocumentationLink(
                      'Video Tutorials',
                      'https://example.com/tutorials',
                    ),
                    _buildDocumentationLink(
                      'API Documentation',
                      'https://example.com/api-docs',
                    ),
                    _buildDocumentationLink(
                      'Release Notes',
                      'https://example.com/releases',
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 20),

            // System Information
            _buildSectionTitle('System Information'),
            Card(
              elevation: 2,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Table(
                  columnWidths: const {
                    0: FlexColumnWidth(1),
                    1: FlexColumnWidth(2),
                  },
                  children: [
                    _buildSystemInfoRow('App Version', 'v2.3.1 (Build 45)'),
                    _buildSystemInfoRow('Last Updated', 'Oct 15, 2023'),
                    _buildSystemInfoRow('Device Model', 'iPhone 14 Pro'),
                    _buildSystemInfoRow('OS Version', 'iOS 16.4.1'),
                    _buildSystemInfoRow('Database', 'SQLite v3.38.5'),
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

  Widget _buildSupportOptionCard({
    required IconData icon,
    required String title,
    required Color color,
    required VoidCallback onTap,
  }) {
    return SizedBox(
      width: 150,
      child: Card(
        elevation: 2,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(8),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                Icon(icon, size: 32, color: color),
                const SizedBox(height: 8),
                Text(
                  title,
                  style: TextStyle(
                    fontWeight: FontWeight.w500,
                    color: Colors.grey[800],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildFAQCard(FAQItem faq) {
    return Card(
      elevation: 2,
      margin: const EdgeInsets.only(bottom: 12),
      child: ExpansionTile(
        title: Text(
          faq.question,
          style: const TextStyle(fontWeight: FontWeight.w500),
        ),
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
            child: Text(faq.answer),
          ),
        ],
      ),
    );
  }

  Widget _buildDocumentationLink(String title, String url) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: InkWell(
        onTap: () => _launchUrl(url),
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

  TableRow _buildSystemInfoRow(String label, String value) {
    return TableRow(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 8),
          child: Text(
            label,
            style: const TextStyle(fontWeight: FontWeight.w500),
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 8),
          child: Text(value),
        ),
      ],
    );
  }

  Future<void> _launchUrl(String url) async {
    if (await canLaunchUrl(Uri.parse(url))) {
      await launchUrl(Uri.parse(url));
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Could not launch $url'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  void _refreshPage() {
    setState(() {
      _diagnosisResult = '';
    });
  }

  void _runDiagnostics() async {
    setState(() {
      _isDiagnosing = true;
      _diagnosisResult = '';
    });

    // Simulate diagnostics
    await Future.delayed(const Duration(seconds: 2));

    setState(() {
      _isDiagnosing = false;
      _diagnosisResult = 'No issues found. All systems operational.';
      // For testing errors:
      // _diagnosisResult = '3 warnings found: Database connection slow, Cache needs clearing, Update available';
    });
  }

  void _launchChatSupport() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Connecting to live chat support...'),
        backgroundColor: Colors.green,
      ),
    );
  }

  void _launchEmailSupport() {
    _launchUrl('mailto:support@pharmacyapp.com?subject=Technical%20Support');
  }

  void _launchPhoneSupport() {
    _launchUrl('tel:+18005551234');
  }

  void _launchVideoSupport() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Starting video call with support agent...'),
        backgroundColor: Colors.green,
      ),
    );
  }
}

class FAQItem {
  final String question;
  final String answer;

  FAQItem({
    required this.question,
    required this.answer,
  });
}