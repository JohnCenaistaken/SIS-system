import 'package:flutter/material.dart';

import '../features/show_marks_sheet.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  // Function to Create Dashboard Cards
  Widget _buildCard(String title, String description, {VoidCallback? onTap}) {
    return InkWell(
      onTap: onTap,
      child: Card(
        elevation: 4,
        child: Padding(
          padding: EdgeInsets.all(16),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(title, style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              SizedBox(height: 8),
              Text(description, textAlign: TextAlign.center),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Home'),
        centerTitle: true,
      ),
      floatingActionButton: FloatingActionButton(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Icon(Icons.picture_as_pdf),
        ),
        onPressed: () {
          showMarksSheet(context);
        },
      ),
      body: Column(
        children: [
          // Header Section
          Container(
            height: 200,
            width: double.infinity,
            decoration: BoxDecoration(
              gradient: LinearGradient(colors: [Colors.blue, Colors.white]),
            ),
            child: Center(
              child: Text(
                "Success is built one report at a time.\nLet’s start today!",
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Colors.white),
                textAlign: TextAlign.center,
              ),
            ),
          ),
          // Dashboard Cards
          Expanded(
            child: GridView.count(
              crossAxisCount: 2,
              padding: EdgeInsets.all(16),
              children: [
                _buildCard("👨‍🏫 Teachers", "Enter Marks & Generate Reports"),
                _buildCard("📚 Students", "View Report Cards & Track Progress"),
                _buildCard("👨‍👩‍👧 Parents", "Monitor Your Child’s Performance"),
              ],
            ),
          ),
          // Footer
          Padding(
            padding: EdgeInsets.all(16),
            child: Text(
              "Education is growth. Keep pushing forward!",
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
            ),
          ),
        ],
      ),
    );
  }
}