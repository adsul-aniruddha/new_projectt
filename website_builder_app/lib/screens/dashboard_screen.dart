import 'package:flutter/material.dart';
import '../services/api_service.dart';

class DashboardScreen extends StatefulWidget {
  @override
  _DashboardScreenState createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  int totalSites = 0;
  int totalViews = 0;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final token = ModalRoute.of(context)!.settings.arguments as String;
    loadData(token);
  }

  void loadData(String token) async {
    var res = await ApiService.getMyWebsites(token);

    int views = 0;
    for (var s in res) {
      views += (s["views"] ?? 0) as int;
    }

    setState(() {
      totalSites = res.length;
      totalViews = views;
    });
  }

  @override
  Widget build(BuildContext context) {
    final token = ModalRoute.of(context)!.settings.arguments as String;

    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFF141E30), Color(0xFF243B55)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: SafeArea(
          child: Padding(
            padding: EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [

                // 🔥 HEADER
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        CircleAvatar(
                          backgroundColor: Colors.teal,
                          child: Icon(Icons.person, color: Colors.white),
                        ),
                        SizedBox(width: 10),
                        Text(
                          "Welcome 👋",
                          style: TextStyle(color: Colors.white),
                        ),
                      ],
                    ),
                    Icon(Icons.notifications, color: Colors.white),
                  ],
                ),

                SizedBox(height: 20),

                // 🔥 TITLE
                Text(
                  "Dashboard",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 26,
                    fontWeight: FontWeight.bold,
                  ),
                ),

                SizedBox(height: 20),

                // 🔥 STATS CARDS
                Row(
                  children: [
                    Expanded(child: _statCard("Websites", totalSites.toString())),
                    SizedBox(width: 10),
                    Expanded(child: _statCard("Views", totalViews.toString())),
                  ],
                ),

                SizedBox(height: 25),

                // 🔥 QUICK ACTIONS
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    _quickBtn(Icons.add, "Create", () {
                      Navigator.pushNamed(context, "/create", arguments: token);
                    }),
                    _quickBtn(Icons.language, "My Sites", () {
                      Navigator.pushNamed(context, "/my-websites", arguments: token);
                    }),
                    _quickBtn(Icons.analytics, "Stats", () {}),
                  ],
                ),

                SizedBox(height: 25),

                // 🔥 GRID MENU
                Expanded(
                  child: GridView.count(
                    crossAxisCount: 2,
                    crossAxisSpacing: 15,
                    mainAxisSpacing: 15,
                    children: [

                      _buildCard(
                        icon: Icons.web,
                        title: "Create Website",
                        color: Colors.blueAccent,
                        onTap: () {
                          Navigator.pushNamed(context, "/create", arguments: token);
                        },
                      ),

                      _buildCard(
                        icon: Icons.language,
                        title: "My Websites",
                        color: Colors.green,
                        onTap: () {
                          Navigator.pushNamed(context, "/my-websites", arguments: token);
                        },
                      ),

                      _buildCard(
                        icon: Icons.bar_chart,
                        title: "Analytics",
                        color: Colors.orange,
                        onTap: () {},
                      ),

                      _buildCard(
                        icon: Icons.settings,
                        title: "Settings",
                        color: Colors.purple,
                        onTap: () {},
                      ),
                    ],
                  ),
                ),

                // 🔥 LOGOUT
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton.icon(
                    icon: Icon(Icons.logout),
                    label: Text("Logout"),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.redAccent,
                      padding: EdgeInsets.symmetric(vertical: 15),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    onPressed: () {
                      Navigator.pushReplacementNamed(context, "/login");
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // 🔥 STAT CARD
  Widget _statCard(String title, String value) {
    return Container(
      padding: EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.1),
        borderRadius: BorderRadius.circular(15),
      ),
      child: Column(
        children: [
          Text(value, style: TextStyle(color: Colors.white, fontSize: 22)),
          SizedBox(height: 5),
          Text(title, style: TextStyle(color: Colors.white70)),
        ],
      ),
    );
  }

  // 🔥 QUICK BUTTON
  Widget _quickBtn(IconData icon, String text, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        children: [
          CircleAvatar(
            backgroundColor: Colors.white.withOpacity(0.1),
            child: Icon(icon, color: Colors.white),
          ),
          SizedBox(height: 5),
          Text(text, style: TextStyle(color: Colors.white70)),
        ],
      ),
    );
  }

  // 🔥 GRID CARD
  Widget _buildCard({
    required IconData icon,
    required String title,
    required Color color,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: color.withOpacity(0.15),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: color.withOpacity(0.4)),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 40, color: color),
            SizedBox(height: 10),
            Text(
              title,
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }
}