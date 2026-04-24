import 'package:flutter/material.dart';
import 'new_site_screen.dart';
import 'templates_screen.dart';
import 'analytics_screen.dart';
import 'settings_screen.dart';
import '../services/website_api.dart';  // 👈 NEW API SERVICE

class DashboardScreen extends StatefulWidget {
  @override
  _DashboardScreenState createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  int _selectedIndex = 0;
  List<Map<String, dynamic>> _websites = [];  // 👈 REAL DATA
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _loadWebsites();  // 👈 AUTO LOAD ON START
  }

  // 👈 BACKEND INTEGRATION
  Future<void> _loadWebsites() async {
    setState(() => _isLoading = true);
    try {
      final websites = await WebsiteApi.getWebsites();
      setState(() {
        _websites = websites;
      });
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('✅ Loaded ${_websites.length} websites'))
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('⚠️ ${_websites.length} mock sites (API offline)'))
        );
      }
    } finally {
      setState(() => _isLoading = false);
    }
  }

  Future<void> _createQuickSite() async {
    try {
      final result = await WebsiteApi.createWebsite(
        name: 'Quick Site ${DateTime.now().millisecondsSinceEpoch}',
        description: 'Created from Dashboard',
      );
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('🚀 Created: ${result['id']}'), backgroundColor: Colors.green),
      );
      _loadWebsites();  // Refresh list
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('❌ $e'), backgroundColor: Colors.red),
      );
    }
  }

  void _showPreview(String siteId) async {
    try {
      final preview = await WebsiteApi.getPreview(siteId);
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Text('Preview'),
          content: SingleChildScrollView(child: Text(preview)),
          actions: [
            TextButton(onPressed: () => Navigator.pop(context), child: Text('Close'))
          ],
        ),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Preview error: $e')),
      );
    }
  }

  void _navigateToNewSite() {
    Navigator.push(context, MaterialPageRoute(builder: (context) => NewSiteScreen()));
  }

  void _navigateToTemplates() {
    Navigator.push(context, MaterialPageRoute(builder: (context) => TemplatesScreen()));
  }

  void _navigateToAnalytics() {
    Navigator.push(context, MaterialPageRoute(builder: (context) => AnalyticsScreen()));
  }

  void _navigateToSettings() {
    Navigator.push(context, MaterialPageRoute(builder: (context) => SettingsScreen()));
  }

  void _onItemTapped(int index) {
    setState(() => _selectedIndex = index);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Website Builder', style: TextStyle(fontWeight: FontWeight.bold)),
        backgroundColor: Colors.blue[700],
        elevation: 0,
        actions: [
          IconButton(
            icon: Icon(Icons.refresh),
            onPressed: _loadWebsites,  // 👈 REFRESH BUTTON
          ),
          IconButton(icon: Icon(Icons.notifications), onPressed: () {}),
        ],
      ),
      body: RefreshIndicator(  // 👈 PULL TO REFRESH
        onRefresh: _loadWebsites,
        child: SingleChildScrollView(
          physics: AlwaysScrollableScrollPhysics(),
          padding: EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Welcome Card
              Card(
                elevation: 4,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                child: Padding(
                  padding: EdgeInsets.all(20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Welcome back!', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
                      SizedBox(height: 8),
                      Text('Backend Connected: ${_websites.length} sites', style: TextStyle(fontSize: 16, color: Colors.green)),
                    ],
                  ),
                ),
              ),
              SizedBox(height: 24),
              
              // Quick Actions
              Text('Quick Actions', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
              SizedBox(height: 16),
              GridView.count(
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                crossAxisCount: 2,
                crossAxisSpacing: 16,
                mainAxisSpacing: 16,
                children: [
                  _buildActionCard(Icons.add, 'New Site', Colors.green, _navigateToNewSite),
                  _buildActionCard(Icons.format_shapes, 'Templates', Colors.orange, _navigateToTemplates),
                  _buildActionCard(Icons.analytics, 'Analytics', Colors.blue, _navigateToAnalytics),
                  _buildActionCard(Icons.bolt, 'Quick Site', Colors.purple, _createQuickSite),  // 👈 NEW!
                ],
              ),
              SizedBox(height: 24),
              
              // Recent Sites (REAL DATA!)
              Text('Recent Sites (${_websites.length})', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
              SizedBox(height: 16),
              _isLoading
                  ? Center(child: CircularProgressIndicator())
                  : _websites.isEmpty
                      ? Card(
                          child: ListTile(
                            leading: Icon(Icons.web_outlined),
                            title: Text('No sites yet'),
                            subtitle: Text('Create your first website!'),
                          ),
                        )
                      : ListView.builder(
                          shrinkWrap: true,
                          physics: NeverScrollableScrollPhysics(),
                          itemCount: _websites.length,
                          itemBuilder: (context, index) {
                            final site = _websites[index];
                            return Card(
                              margin: EdgeInsets.only(bottom: 12),
                              child: ListTile(
                                leading: CircleAvatar(
                                  backgroundColor: Colors.blue[100],
                                  child: Icon(Icons.web, color: Colors.blue),
                                ),
                                title: Text(site['name'] ?? 'Untitled'),
                                subtitle: Text('${site['status'] ?? 'unknown'} • ${site['created_at'] ?? ''}'),
                                trailing: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    IconButton(
                                      icon: Icon(Icons.preview, color: Colors.green),
                                      onPressed: () => _showPreview(site['id']),
                                    ),
                                    IconButton(
                                      icon: Icon(Icons.delete, color: Colors.red),
                                      onPressed: () => _deleteSite(site['id']),
                                    ),
                                  ],
                                ),
                              ),
                            );
                          },
                        ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
        selectedItemColor: Colors.blue,
        items: [
          BottomNavigationBarItem(icon: Icon(Icons.dashboard), label: 'Dashboard'),
          BottomNavigationBarItem(icon: Icon(Icons.explore), label: 'Projects'),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profile'),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _navigateToNewSite,
        backgroundColor: Colors.green,
        child: Icon(Icons.add),
        tooltip: 'New Website',
      ),
    );
  }

  Future<void> _deleteSite(String siteId) async {
    // Add DELETE API call here later
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('🗑️ Delete $siteId'), backgroundColor: Colors.red),
    );
  }

  Widget _buildActionCard(IconData icon, String title, Color color, VoidCallback onTap) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: onTap,
        child: Padding(
          padding: EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                padding: EdgeInsets.all(16),
                decoration: BoxDecoration(color: color.withOpacity(0.1), shape: BoxShape.circle),
                child: Icon(icon, size: 32, color: color),
              ),
              SizedBox(height: 12),
              Text(title, style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            ],
          ),
        ),
      ),
    );
  }
}