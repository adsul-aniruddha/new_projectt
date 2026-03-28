import 'package:flutter/material.dart';

class DashboardScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final token = ModalRoute.of(context)!.settings.arguments;

    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,

        // 🔥 Background Gradient
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Color(0xFF141E30),
              Color(0xFF243B55),
            ],
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

                // 🔥 Header
                Text(
                  "Dashboard",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                  ),
                ),

                SizedBox(height: 5),

                Text(
                  "Welcome back 👋",
                  style: TextStyle(color: Colors.white70),
                ),

                SizedBox(height: 30),

                // 🔥 Grid Menu
                Expanded(
                  child: GridView.count(
                    crossAxisCount: 2,
                    crossAxisSpacing: 15,
                    mainAxisSpacing: 15,
                    children: [

                      // 🔥 Create Website
                      _buildCard(
                        icon: Icons.web,
                        title: "Create Website",
                        color: Colors.blueAccent,
                        onTap: () {
                          Navigator.pushNamed(
                            context,
                            "/create",
                            arguments: token,
                          );
                        },
                      ),

                      // 🔥 My Websites
                      _buildCard(
                        icon: Icons.language,
                        title: "My Websites",
                        color: Colors.green,
                        onTap: () {},
                      ),

                      // 🔥 Analytics
                      _buildCard(
                        icon: Icons.bar_chart,
                        title: "Analytics",
                        color: Colors.orange,
                        onTap: () {},
                      ),

                      // 🔥 Settings
                      _buildCard(
                        icon: Icons.settings,
                        title: "Settings",
                        color: Colors.purple,
                        onTap: () {},
                      ),
                    ],
                  ),
                ),

                // 🔥 Logout Button
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

  // 🔥 Reusable Card Widget
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
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }
}