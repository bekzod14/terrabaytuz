import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:terrabayt_uz/data/models/category_data.dart';
import 'package:terrabayt_uz/resources/colors.dart';

class FilterDialog extends StatefulWidget {
  final Function(int? id) onSaved;
  final CategoryData categogry;

  const FilterDialog(this.onSaved, this.categogry, {Key? key})
      : super(key: key);

  @override
  State<FilterDialog> createState() => _FilterDialogState();
}

class _FilterDialogState extends State<FilterDialog> {
  int? _selectedCategory = null;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
          borderRadius: BorderRadius.only(
              topLeft: Radius.circular(12), topRight: Radius.circular(12)),
          color: Colors.white),
      child: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Text(
                  "Saralash",
                  style: TextStyle(
                      color: Colors.black, fontWeight: FontWeight.bold),
                ),
                ElevatedButton.icon(
                  onPressed: () => {print("Reset")},
                  icon: const Icon(Icons.delete_outline),
                  label: const Text(
                    "O'chirish",
                    style: TextStyle(color: Colors.white),
                  ),
                  style: ButtonStyle(
                      backgroundColor:
                          MaterialStateProperty.all(AppColors.primary)),
                )
              ],
            ),
            const Text("Bo'yicha saralash"),
            Container(),
            MaterialButton(
                onPressed: () => {widget.onSaved(_selectedCategory)},
                child: const Text(
                  "Saqlash",
                  style: TextStyle(
                      color: Colors.black, fontWeight: FontWeight.bold),
                ))
          ],
        ),
      ),
    );
  }
}
