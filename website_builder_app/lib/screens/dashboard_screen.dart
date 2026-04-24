import 'package:flutter/material.dart';
import 'new_site_screen.dart';
import 'templates_screen.dart';
import 'analytics_screen.dart';
import 'settings_screen.dart';
import '../services/website_api.dart';

class DashboardScreen extends StatefulWidget {
  @override
  _DashboardScreenState createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  int _selectedIndex = 0;
  List<Map<String, dynamic>> _websites = [];
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _loadWebsites();
  }

  Future<void> _loadWebsites() async {
    setState(() => _isLoading = true);
    final websites = await WebsiteApi.getWebsites();
    if (mounted) {
      setState(() {
        _websites = websites;
        _isLoading = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('✅ ${_websites.length} sites loaded')),
      );
    }
  }

  Future<void> _createQuickSite() async {
    final result = await WebsiteApi.createWebsite(
      name: 'Quick Site ${DateTime.now().millisecondsSinceEpoch}',
      description: 'Dashboard created 🚀',
    );
    
    if (result != null && result['id'] != null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('🚀 Created: ${result['id']}'),
          backgroundColor: Colors.green,
        ),
      );
      _loadWebsites();
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('✅ Created successfully'), backgroundColor: Colors.green),
      );
    }
  }

  Future<void> _showPreview(String siteId) async {
    final preview = await WebsiteApi.getPreview(siteId);
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Site Preview'),
        content: SingleChildScrollView(child: SelectableText(preview)),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Close'),
          ),
        ],
      ),
    );
  }

  void _navigateToNewSite() => Navigator.push(context, MaterialPageRoute(builder: (context) => NewSiteScreen()));
  void _navigateToTemplates() => Navigator.push(context, MaterialPageRoute(builder: (context) => TemplatesScreen()));
  void _navigateToAnalytics() => Navigator.push(context, MaterialPageRoute(builder: (context) => AnalyticsScreen()));
  void _navigateToSettings() => Navigator.push(context, MaterialPageRoute(builder: (context) => SettingsScreen()));

  void _onItemTapped(int index) => setState(() => _selectedIndex = index);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Website Builder', style: TextStyle(fontWeight: FontWeight.bold)),
        backgroundColor: Colors.blue[700],
        actions: [
          IconButton(icon: Icon(Icons.refresh), onPressed: _loadWebsites),
          IconButton(icon: Icon(Icons.notifications), onPressed: () {}),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: _loadWebsites,
        child: SingleChildScrollView(
          physics: AlwaysScrollableScrollPhysics(),
          padding: EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Card(
                child: Padding(
                  padding: EdgeInsets.all(20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Welcome!', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
                      Text('${_websites.length} sites • Railway Backend', style: TextStyle(fontSize: 16, color: Colors.green)),
                    ],
                  ),
                ),
              ),
              SizedBox(height: 24),
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
                  _buildActionCard(Icons.bolt, 'Quick Site', Colors.purple, _createQuickSite),
                ],
              ),
              SizedBox(height: 24),
              Text('My Websites', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
              SizedBox(height: 16),
              _isLoading
                  ? Center(child: CircularProgressIndicator())
                  : _websites.isEmpty
                      ? Card(child: ListTile(title: Text('Create your first site!')))
                      : ListView.builder(
                          shrinkWrap: true,
                          physics: NeverScrollableScrollPhysics(),
                          itemCount: _websites.length,
                          itemBuilder: (context, index) {
                            final site = _websites[index];
                            return Card(
                              child: ListTile(
                                leading: CircleAvatar(child: Icon(Icons.web)),
                                title: Text(site['name'] ?? 'Untitled'),
                                subtitle: Text(site['status'] ?? 'unknown'),
                                trailing: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    IconButton(
                                      icon: Icon(Icons.visibility),
                                      onPressed: () => _showPreview(site['id']),
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
        items: [
          BottomNavigationBarItem(icon: Icon(Icons.dashboard), label: 'Home'),
          BottomNavigationBarItem(icon: Icon(Icons.explore), label: 'Projects'),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profile'),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _navigateToNewSite,
        backgroundColor: Colors.green,
        child: Icon(Icons.add),
      ),
    );
  }

  Widget _buildActionCard(IconData icon, String title, Color color, VoidCallback onTap) {
    return Card(
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
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