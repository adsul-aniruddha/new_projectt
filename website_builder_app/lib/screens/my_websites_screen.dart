import 'package:flutter/material.dart';
import '../services/api_service.dart';
import 'package:url_launcher/url_launcher.dart';

class MyWebsitesScreen extends StatefulWidget {
  @override
  _MyWebsitesScreenState createState() => _MyWebsitesScreenState();
}

class _MyWebsitesScreenState extends State<MyWebsitesScreen> {
  List websites = [];
  bool loading = true;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final token = ModalRoute.of(context)!.settings.arguments as String;
    fetch(token);
  }

  void fetch(String token) async {
    var res = await ApiService.getMyWebsites(token);
    setState(() {
      websites = res;
      loading = false;
    });
  }

  void openSite(int id) async {
    final url = Uri.parse("http://127.0.0.1:8081/site/$id");
    await launchUrl(url);
  }

  @override
  Widget build(BuildContext context) {
    final token = ModalRoute.of(context)!.settings.arguments as String;

    return Scaffold(
      appBar: AppBar(title: Text("My Websites 🌐")),
      body: loading
          ? Center(child: CircularProgressIndicator())
          : websites.isEmpty
              ? Center(child: Text("No websites yet 😢"))
              : ListView.builder(
                  itemCount: websites.length,
                  itemBuilder: (context, index) {
                    var site = websites[index];

                    return Container(
                      margin: EdgeInsets.all(10),
                      padding: EdgeInsets.all(15),
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [Colors.blueGrey, Colors.black87],
                        ),
                        borderRadius: BorderRadius.circular(15),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [

                          // 🔥 Name
                          Text(
                            site["name"] ?? "No Name",
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),

                          SizedBox(height: 5),

                          // 🔥 Type
                          Text(
                            site["business_type"] ?? "",
                            style: TextStyle(color: Colors.white70),
                          ),

                          SizedBox(height: 10),

                          // 🔥 Buttons Row
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [

                              // 🌐 OPEN
                              ElevatedButton.icon(
                                icon: Icon(Icons.open_in_browser),
                                label: Text("Open"),
                                onPressed: () => openSite(site["id"]),
                              ),

                              // ✏️ EDIT
                              ElevatedButton.icon(
                                icon: Icon(Icons.edit),
                                label: Text("Edit"),
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.orange,
                                ),
                                onPressed: () {
                                  Navigator.pushNamed(
                                    context,
                                    "/edit",
                                    arguments: {
                                      "token": token,
                                      "site": site
                                    },
                                  );
                                },
                              ),
                            ],
                          ),
                        ],
                      ),
                    );
                  },
                ),
    );
  }
}