import 'package:flutter/material.dart';
import 'package:report_portal_boom/Components/marks_form.dart';

void showMarksSheet(BuildContext context) {
  showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) {
        return Padding(
          padding: EdgeInsets.only(
              bottom: MediaQuery
                  .of(context)
                  .viewInsets
                  .bottom
          ),
          child: MarksEntryForm(),
        );
      }
  );
}