import 'package:flutter/material.dart';

class SettingPage extends StatefulWidget {
  const SettingPage({super.key});

  @override
  State<SettingPage> createState() => _SettingPageState();
}

class _SettingPageState extends State<SettingPage> {
  bool isDarkMode = false; // Track dark mode state

  void toggleDarkMode() {
    setState(() {
      isDarkMode = !isDarkMode;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
  title: Text('Settings'),
  centerTitle: true,
  leading: IconButton(
    icon: Icon(Icons.arrow_back),
    onPressed: () {
      Navigator.pop(context);
    },
  ),
),

      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "General Settings",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            _buildSettingOption(
              title: "Go to Categories",
              icon: Icons.category,
              onTap: () {
                Navigator.of(context).pushNamed('categories');
              },
            ),
            _buildSettingOption(
              title: "Notifications",
              icon: Icons.notifications,
              onTap: () {},
            ),
            _buildSettingOption(
              title: "Dark Mode",
              icon: isDarkMode ? Icons.light_mode : Icons.dark_mode,
              onTap: toggleDarkMode,
            ),
            const Divider(),
            const Text(
              "Account",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            _buildSettingOption(
              title: "Edit Profile",
              icon: Icons.person,
              onTap: () {},
            ),
            _buildSettingOption(
              title: "Log Out",
              icon: Icons.logout,
              onTap: () {},
              color: Colors.red,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSettingOption({
    required String title,
    required IconData icon,
    required VoidCallback onTap,
    Color color = Colors.black,
  }) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: ListTile(
        leading: Icon(icon, color: color),
        title: Text(
          title,
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500, color: color),
        ),
        trailing: const Icon(Icons.arrow_forward_ios, size: 18),
        onTap: onTap,
      ),
    );
  }
}
