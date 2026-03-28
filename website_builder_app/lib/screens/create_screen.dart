import 'package:flutter/material.dart';
import '../services/api_service.dart';

class CreateScreen extends StatefulWidget {
  @override
  _CreateScreenState createState() => _CreateScreenState();
}

class _CreateScreenState extends State<CreateScreen> {
  TextEditingController name = TextEditingController();
  TextEditingController email = TextEditingController();
  TextEditingController domain = TextEditingController();
  TextEditingController type = TextEditingController();
  TextEditingController desc = TextEditingController();
  TextEditingController color = TextEditingController();

  String selectedTemplate = "Modern";

  void create(String token) async {
    var res = await ApiService.createRequest(token, {
      "name": name.text,
      "email": email.text,
      "domain": domain.text,
      "business_type": type.text,
      "description": desc.text,
      "color": color.text,
      "template": selectedTemplate,
    });

    Navigator.pushNamed(context, "/preview", arguments: res["id"]);
  }

  @override
  Widget build(BuildContext context) {
    final token = ModalRoute.of(context)!.settings.arguments as String;

    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFF0F2027), Color(0xFF203A43), Color(0xFF2C5364)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: SafeArea(
          child: SingleChildScrollView(
            padding: EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [

                // 🔥 Title
                Text(
                  "Create Your Website 🚀",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 26,
                    fontWeight: FontWeight.bold,
                  ),
                ),

                SizedBox(height: 20),

                _input(name, "Your Name", Icons.person),
                _input(email, "Email", Icons.email),
                _input(domain, "Domain (example.com)", Icons.language),
                _input(type, "Business Type", Icons.business),
                _input(desc, "Description", Icons.description),
                _input(color, "Theme Color (e.g. blue)", Icons.color_lens),

                SizedBox(height: 25),

                // 🔥 Template Selection
                Text(
                  "Choose Template",
                  style: TextStyle(color: Colors.white, fontSize: 18),
                ),

                SizedBox(height: 10),

                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    _templateCard("Modern"),
                    _templateCard("Classic"),
                    _templateCard("Minimal"),
                  ],
                ),

                SizedBox(height: 30),

                // 🚀 Generate Button
                SizedBox(
                  width: double.infinity,
                  height: 50,
                  child: ElevatedButton.icon(
                    icon: Icon(Icons.auto_awesome),
                    label: Text("Generate Website"),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.tealAccent,
                      foregroundColor: Colors.black,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15),
                      ),
                    ),
                    onPressed: () => create(token),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // 🔥 Input Field UI
  Widget _input(TextEditingController controller, String label, IconData icon) {
    return Padding(
      padding: EdgeInsets.only(bottom: 15),
      child: TextField(
        controller: controller,
        style: TextStyle(color: Colors.white),
        decoration: InputDecoration(
          prefixIcon: Icon(icon, color: Colors.white),
          labelText: label,
          labelStyle: TextStyle(color: Colors.white70),
          filled: true,
          fillColor: Colors.white.withOpacity(0.1),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(15),
            borderSide: BorderSide.none,
          ),
        ),
      ),
    );
  }

  // 🔥 Template Card
  Widget _templateCard(String name) {
    bool selected = selectedTemplate == name;

    return GestureDetector(
      onTap: () {
        setState(() {
          selectedTemplate = name;
        });
      },
      child: Container(
        width: 100,
        height: 100,
        decoration: BoxDecoration(
          color: selected ? Colors.teal : Colors.white.withOpacity(0.1),
          borderRadius: BorderRadius.circular(15),
          border: Border.all(
            color: selected ? Colors.tealAccent : Colors.white24,
          ),
        ),
        child: Center(
          child: Text(
            name,
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
    );
  }
}