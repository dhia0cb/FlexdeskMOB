import 'package:flutter/material.dart';

Future<List<String>> showEquipmentPicker({
  required BuildContext context,
  required List<String> selectedItems,
}) async {
  final List<String> allEquipment = [
    "Projector",
    "TV",
    "Whiteboard",
    "Phone",
    "Conference Phone",
  ];

  final Set<String> selectedSet = selectedItems.toSet();

  return await showDialog<List<String>>(
    context: context,
    builder: (context) {
      return StatefulBuilder(
        builder: (context, setState) {
          return AlertDialog(
            title: const Text("Select Equipment"),
            content: SingleChildScrollView(
              child: Column(
                children: allEquipment.map((item) {
                  return CheckboxListTile(
                    title: Text(item),
                    value: selectedSet.contains(item),
                    onChanged: (bool? isSelected) {
                      if (isSelected == true) {
                        setState(() => selectedSet.add(item));
                      } else {
                        setState(() => selectedSet.remove(item));
                      }
                    },
                  );
                }).toList(),
              ),
            ),
            actions: [
              TextButton(
                onPressed: Navigator.of(context).pop,
                child: const Text("Done"),
              )
            ],
          );
        },
      );
    },
  ).then((_) => selectedSet.toList());
}