import 'package:flutter/material.dart';

import '../features/generate_pdf.dart';

class MarksEntryForm extends StatefulWidget {
  @override
  _MarksEntryFormState createState() => _MarksEntryFormState();
}

class _MarksEntryFormState extends State<MarksEntryForm> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _marksController = TextEditingController();
  final TextEditingController _averageController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(16),
      child: Form(
        key: _formKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              "Enter Student's Marks",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 10),
            TextFormField(
              controller: _marksController,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(labelText: "Student's Marks"),
              validator: (value) {
                if (value == null || value.isEmpty) return "Enter marks";
                return null;
              },
            ),
            TextFormField(
              controller: _averageController,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(labelText: "Class Average"),
              validator: (value) {
                if (value == null || value.isEmpty) return "Enter class average";
                return null;
              },
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                if (_formKey.currentState!.validate()) {
                  // Handle data submission
                  String marks = _marksController.text;
                  String average = _averageController.text;

                  // Close bottom sheet
                  Navigator.pop(context);

                  // Call function to generate PDF with entered data
                  generatePdf(marks, average);
                }
              },
              child: Text("Generate PDF"),
            ),
          ],
        ),
      ),
    );
  }
}