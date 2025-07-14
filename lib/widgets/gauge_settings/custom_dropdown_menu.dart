import 'package:flutter/material.dart';

class CustomDropdownMenu extends StatelessWidget {
  const CustomDropdownMenu({
    super.key,
    required this.workingList,
    required this.currentItem,
    required this.updateContent,
  });

  final List<String> workingList;
  final String currentItem;
  final ValueChanged<String> updateContent;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return DropdownButton<String>(
      value: currentItem,
      icon: const Icon(Icons.arrow_downward),
      style: isDark
          ? TextStyle(fontSize: 24, fontFamily: 'Marty')
          : TextStyle(fontSize: 24, fontFamily: 'Marty', color: Colors.black),
      elevation: 16,
      onChanged: (String? newValue) {
        if (newValue != null) updateContent(newValue);
      },
      items: workingList.map<DropdownMenuItem<String>>((String option) {
        return DropdownMenuItem<String>(value: option, child: Text(option));
      }).toList(),
    );
  }
}
