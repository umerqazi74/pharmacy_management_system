import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class ApplicationSettingsPage extends StatefulWidget {
  const ApplicationSettingsPage({super.key});

  @override
  State<ApplicationSettingsPage> createState() => _ApplicationSettingsPageState();
}

class _ApplicationSettingsPageState extends State<ApplicationSettingsPage> {
  bool _darkModeEnabled = false;
  bool _notificationsEnabled = true;
  bool _autoBackupEnabled = true;
  String _selectedLanguage = 'English';
  String _selectedTheme = 'System Default';
  String _backupFrequency = 'Daily';
  String _dateFormat = 'MM/dd/yyyy';
  String _timeFormat = '12-hour';
  double _fontSize = 14.0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        title: const Text('Application Settings'),
        actions: [
          IconButton(
            icon: const Icon(Icons.save),
            onPressed: _saveSettings,
            tooltip: 'Save Settings',
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Appearance Section
            _buildSectionHeader('Appearance Settings', Icons.palette),
            Card(
              elevation: 2,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    SwitchListTile(
                      title: const Text('Dark Mode'),
                      value: _darkModeEnabled,
                      onChanged: (value) => setState(() => _darkModeEnabled = value),
                      secondary: const Icon(Icons.dark_mode),
                    ),
                    const Divider(),
                    ListTile(
                      leading: const Icon(Icons.style),
                      title: const Text('Theme'),
                      subtitle: Text(_selectedTheme),
                      onTap: () => _showThemeSelector(),
                    ),
                    const Divider(),
                    ListTile(
                      leading: const Icon(Icons.text_fields),
                      title: const Text('Font Size'),
                      subtitle: Slider(
                        value: _fontSize,
                        min: 12.0,
                        max: 18.0,
                        divisions: 6,
                        label: _fontSize.toStringAsFixed(0),
                        onChanged: (value) => setState(() => _fontSize = value),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 20),

            // Language & Regional
            _buildSectionHeader('Language & Regional', Icons.language),
            Card(
              elevation: 2,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    ListTile(
                      leading: const Icon(Icons.translate),
                      title: const Text('Application Language'),
                      subtitle: Text(_selectedLanguage),
                      onTap: () => _showLanguageSelector(),
                    ),
                    const Divider(),
                    ListTile(
                      leading: const Icon(Icons.date_range),
                      title: const Text('Date Format'),
                      subtitle: Text(_dateFormat),
                      onTap: () => _showDateFormatSelector(),
                    ),
                    const Divider(),
                    ListTile(
                      leading: const Icon(Icons.access_time),
                      title: const Text('Time Format'),
                      subtitle: Text(_timeFormat),
                      onTap: () => _showTimeFormatSelector(),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 20),

            // Notifications
            _buildSectionHeader('Notifications', Icons.notifications),
            Card(
              elevation: 2,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    SwitchListTile(
                      title: const Text('Enable Notifications'),
                      value: _notificationsEnabled,
                      onChanged: (value) => setState(() => _notificationsEnabled = value),
                      secondary: const Icon(Icons.notifications_active),
                    ),
                    const Divider(),
                    ListTile(
                      leading: const Icon(Icons.notification_important),
                      title: const Text('Notification Sound'),
                      subtitle: const Text('Default'),
                      onTap: () {},
                    ),
                    const Divider(),
                    ListTile(
                      leading: const Icon(Icons.vibration),
                      title: const Text('Vibration'),
                      subtitle: const Text('Enabled'),
                      onTap: () {},
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 20),

            // Data Management
            _buildSectionHeader('Data Management', Icons.storage),
            Card(
              elevation: 2,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    SwitchListTile(
                      title: const Text('Automatic Backups'),
                      value: _autoBackupEnabled,
                      onChanged: (value) => setState(() => _autoBackupEnabled = value),
                      secondary: const Icon(Icons.backup),
                    ),
                    const Divider(),
                    ListTile(
                      leading: const Icon(Icons.calendar_today),
                      title: const Text('Backup Frequency'),
                      subtitle: Text(_backupFrequency),
                      onTap: () => _showBackupFrequencySelector(),
                    ),
                    const Divider(),
                    ListTile(
                      leading: const Icon(Icons.cloud_upload),
                      title: const Text('Backup Location'),
                      subtitle: const Text('Local Storage'),
                      onTap: () {},
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 20),

            // Advanced Settings
            _buildSectionHeader('Advanced Settings', Icons.settings),
            Card(
              elevation: 2,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    ListTile(
                      leading: const Icon(Icons.bug_report),
                      title: const Text('Diagnostics'),
                      subtitle: const Text('Send error reports automatically'),
                      trailing: Switch(
                        value: true,
                        onChanged: (value) {},
                      ),
                    ),
                    const Divider(),
                    ListTile(
                      leading: const Icon(Icons.update),
                      title: const Text('Check for Updates'),
                      subtitle: const Text('Last checked: Today'),
                      onTap: _checkForUpdates,
                    ),
                    const Divider(),
                    ListTile(
                      leading: const Icon(Icons.restart_alt),
                      title: const Text('Reset All Settings'),
                      onTap: _confirmResetSettings,
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionHeader(String title, IconData icon) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        children: [
          Icon(icon, size: 20, color: Colors.blue[600]),
          const SizedBox(width: 8),
          Text(
            title,
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Colors.blue[600],
            ),
          ),
        ],
      ),
    );
  }

  void _saveSettings() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Settings saved successfully'),
        backgroundColor: Colors.green,
      ),
    );
  }

  void _showThemeSelector() {
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            RadioListTile(
              title: const Text('System Default'),
              value: 'System Default',
              groupValue: _selectedTheme,
              onChanged: (value) {
                setState(() => _selectedTheme = value.toString());
                Navigator.pop(context);
              },
            ),
            RadioListTile(
              title: const Text('Light Theme'),
              value: 'Light Theme',
              groupValue: _selectedTheme,
              onChanged: (value) {
                setState(() => _selectedTheme = value.toString());
                Navigator.pop(context);
              },
            ),
            RadioListTile(
              title: const Text('Dark Theme'),
              value: 'Dark Theme',
              groupValue: _selectedTheme,
              onChanged: (value) {
                setState(() => _selectedTheme = value.toString());
                Navigator.pop(context);
              },
            ),
          ],
        );
      },
    );
  }

  void _showLanguageSelector() {
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            RadioListTile(
              title: const Text('English'),
              value: 'English',
              groupValue: _selectedLanguage,
              onChanged: (value) {
                setState(() => _selectedLanguage = value.toString());
                Navigator.pop(context);
              },
            ),
            RadioListTile(
              title: const Text('Spanish'),
              value: 'Spanish',
              groupValue: _selectedLanguage,
              onChanged: (value) {
                setState(() => _selectedLanguage = value.toString());
                Navigator.pop(context);
              },
            ),
            RadioListTile(
              title: const Text('French'),
              value: 'French',
              groupValue: _selectedLanguage,
              onChanged: (value) {
                setState(() => _selectedLanguage = value.toString());
                Navigator.pop(context);
              },
            ),
          ],
        );
      },
    );
  }

  void _showDateFormatSelector() {
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            RadioListTile(
              title: const Text('MM/dd/yyyy'),
              value: 'MM/dd/yyyy',
              groupValue: _dateFormat,
              onChanged: (value) {
                setState(() => _dateFormat = value.toString());
                Navigator.pop(context);
              },
            ),
            RadioListTile(
              title: const Text('dd/MM/yyyy'),
              value: 'dd/MM/yyyy',
              groupValue: _dateFormat,
              onChanged: (value) {
                setState(() => _dateFormat = value.toString());
                Navigator.pop(context);
              },
            ),
            RadioListTile(
              title: const Text('yyyy-MM-dd'),
              value: 'yyyy-MM-dd',
              groupValue: _dateFormat,
              onChanged: (value) {
                setState(() => _dateFormat = value.toString());
                Navigator.pop(context);
              },
            ),
          ],
        );
      },
    );
  }

  void _showTimeFormatSelector() {
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            RadioListTile(
              title: const Text('12-hour'),
              value: '12-hour',
              groupValue: _timeFormat,
              onChanged: (value) {
                setState(() => _timeFormat = value.toString());
                Navigator.pop(context);
              },
            ),
            RadioListTile(
              title: const Text('24-hour'),
              value: '24-hour',
              groupValue: _timeFormat,
              onChanged: (value) {
                setState(() => _timeFormat = value.toString());
                Navigator.pop(context);
              },
            ),
          ],
        );
      },
    );
  }

  void _showBackupFrequencySelector() {
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            RadioListTile(
              title: const Text('Daily'),
              value: 'Daily',
              groupValue: _backupFrequency,
              onChanged: (value) {
                setState(() => _backupFrequency = value.toString());
                Navigator.pop(context);
              },
            ),
            RadioListTile(
              title: const Text('Weekly'),
              value: 'Weekly',
              groupValue: _backupFrequency,
              onChanged: (value) {
                setState(() => _backupFrequency = value.toString());
                Navigator.pop(context);
              },
            ),
            RadioListTile(
              title: const Text('Monthly'),
              value: 'Monthly',
              groupValue: _backupFrequency,
              onChanged: (value) {
                setState(() => _backupFrequency = value.toString());
                Navigator.pop(context);
              },
            ),
          ],
        );
      },
    );
  }

  void _checkForUpdates() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Checking for updates...'),
        duration: Duration(seconds: 2),
      ),
    );
  }

  void _confirmResetSettings() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Reset All Settings?'),
        content: const Text('This will restore all settings to their default values.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Settings reset to defaults'),
                  backgroundColor: Colors.green,
                ),
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
            ),
            child: const Text('Reset'),
          ),
        ],
      ),
    );
  }
}