import 'package:flutter/material.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({Key? key}) : super(key: key);

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _fade;

  bool notifications = true;
  bool darkMode = false;
  bool rememberMe = false;
  String units = "Metric"; // or "Imperial"

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this, duration: Duration(milliseconds: 500));
    _fade = CurvedAnimation(parent: _controller, curve: Curves.easeIn);
    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _save() {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text("Settings saved ✅")),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: Text("Settings"),
        backgroundColor: Colors.redAccent,
      ),
      body: FadeTransition(
        opacity: _fade,
        child: ListView(
          padding: EdgeInsets.all(16),
          children: [
            _sectionTitle("Preferences"),
            Card(
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
              elevation: 4,
              child: Column(
                children: [
                  SwitchListTile(
                    title: Text("Notifications"),
                    value: notifications,
                    onChanged: (v) => setState(() => notifications = v),
                    secondary: Icon(Icons.notifications_active, color: Colors.redAccent),
                  ),
                  Divider(height: 1),
                  SwitchListTile(
                    title: Text("Dark Mode (local)"),
                    value: darkMode,
                    onChanged: (v) => setState(() => darkMode = v),
                    secondary: Icon(Icons.dark_mode, color: Colors.redAccent),
                  ),
                  Divider(height: 1),
                  SwitchListTile(
                    title: Text("Remember Me"),
                    value: rememberMe,
                    onChanged: (v) => setState(() => rememberMe = v),
                    secondary: Icon(Icons.remember_me, color: Colors.redAccent),
                  ),
                ],
              ),
            ),
            SizedBox(height: 16),
            _sectionTitle("Units"),
            Card(
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
              elevation: 4,
              child: ListTile(
                leading: Icon(Icons.straighten, color: Colors.redAccent),
                title: Text("Measurement Units"),
                subtitle: Text(units),
                trailing: DropdownButton<String>(
                  value: units,
                  items: const [
                    DropdownMenuItem(value: "Metric", child: Text("Metric (kg, cm)")),
                    DropdownMenuItem(value: "Imperial", child: Text("Imperial (lb, in)")),
                  ],
                  onChanged: (v) => setState(() => units = v ?? units),
                ),
              ),
            ),
            SizedBox(height: 16),
            _sectionTitle("Account"),
            Card(
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
              elevation: 4,
              child: Column(
                children: [
                  ListTile(
                    leading: Icon(Icons.password, color: Colors.redAccent),
                    title: Text("Change Password"),
                    onTap: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text("Change Password tapped")),
                      );
                    },
                  ),
                  Divider(height: 1),
                  ListTile(
                    leading: Icon(Icons.delete_forever, color: Colors.redAccent),
                    title: Text("Delete Account"),
                    onTap: () async {
                      final confirm = await showDialog<bool>(
                        context: context,
                        builder: (_) => AlertDialog(
                          title: Text("Delete Account"),
                          content: Text("This action cannot be undone. Proceed?"),
                          actions: [
                            TextButton(onPressed: () => Navigator.pop(context, false), child: Text("Cancel")),
                            ElevatedButton(
                              style: ElevatedButton.styleFrom(backgroundColor: Colors.redAccent),
                              onPressed: () => Navigator.pop(context, true),
                              child: Text("Delete"),
                            ),
                          ],
                        ),
                      );
                      if (confirm == true) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text("Account deletion requested")),
                        );
                      }
                    },
                  ),
                ],
              ),
            ),
            SizedBox(height: 24),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.redAccent,
                padding: EdgeInsets.symmetric(vertical: 14),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
              ),
              onPressed: _save,
              child: Text("Save Settings", style: TextStyle(color: Colors.white)),
            ),
          ],
        ),
      ),
      // Optional local dark mode preview using Theme widget
      backgroundColor: darkMode ? Colors.grey.shade900 : theme.scaffoldBackgroundColor,
    );
  }

  Widget _sectionTitle(String text) => Padding(
    padding: const EdgeInsets.only(bottom: 8),
    child: Text(text, style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
  );
}