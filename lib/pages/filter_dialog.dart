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
      height: 400,
      decoration: const BoxDecoration(
          borderRadius: BorderRadius.only(
              topLeft: Radius.circular(12), topRight: Radius.circular(12)),
          color: Colors.white),
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  const Text(
                    "Saralash",
                    style: TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                        fontSize: 24),
                  ),
                  Expanded(child: Container()),
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
              Expanded(child: Container()),
              Container(
                alignment: Alignment.center,
                width: double.infinity,
                height: 50,
                decoration: const BoxDecoration(
                    gradient: LinearGradient(
                        colors: [
                          AppColors.primary,
                          AppColors.redGradientEnd,
                        ],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        tileMode: TileMode.clamp),
                    borderRadius: BorderRadius.all(Radius.circular(25))),
                child: const Text("Saqlash",
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.bold)),
              )
            ],
          ),
        ),
      ),
    );
  }
}
