import 'package:flutter/material.dart';
import 'package:front_mobile/widgets/equipment_picker.dart';
import 'package:provider/provider.dart';

import '../models/space_provider.dart';
import '../models/desk.dart';
import '../models/meeting_room.dart';
import '../widgets/floor_map_widget.dart' as floorMapWidget;
import '../widgets/space_enum.dart' as spaceEnum;

class FloorMapScreen extends StatefulWidget {
  const FloorMapScreen({super.key});

  @override
  State<FloorMapScreen> createState() => _FloorMapScreenState();
}

class _FloorMapScreenState extends State<FloorMapScreen> {
  floorMapWidget.AddMode _addMode = floorMapWidget.AddMode.none;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<SpaceProvider>(context, listen: false).fetchSpaces();
    });
  }

  void _showBookingDialog({required String spaceLabel}) async {
    final bookForController = TextEditingController();
    DateTime selectedDate = DateTime.now();
    TimeOfDay fromTime = TimeOfDay.now();
    TimeOfDay toTime = TimeOfDay.now();

    await showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setState) => AlertDialog(
          title: Text('Book $spaceLabel'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: bookForController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(labelText: 'Book For (User ID)'),
              ),
              const SizedBox(height: 10),
              ListTile(
                title: Text("Date: ${selectedDate.toLocal().toString().split(' ')[0]}"),
                trailing: const Icon(Icons.calendar_today),
                onTap: () async {
                  final date = await showDatePicker(
                    context: context,
                    initialDate: selectedDate,
                    firstDate: DateTime.now(),
                    lastDate: DateTime(2100),
                  );
                  if (date != null) {
                    setState(() => selectedDate = date);
                  }
                },
              ),
              ListTile(
                title: Text("From: ${fromTime.format(context)}"),
                trailing: const Icon(Icons.access_time),
                onTap: () async {
                  final time = await showTimePicker(
                    context: context,
                    initialTime: fromTime,
                  );
                  if (time != null) {
                    setState(() => fromTime = time);
                  }
                },
              ),
              ListTile(
                title: Text("To: ${toTime.format(context)}"),
                trailing: const Icon(Icons.access_time),
                onTap: () async {
                  final time = await showTimePicker(
                    context: context,
                    initialTime: toTime,
                  );
                  if (time != null) {
                    setState(() => toTime = time);
                  }
                },
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                // You can handle sending booking info to backend here
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Booking Confirmed')),
                );
              },
              child: const Text('Confirm'),
            ),
          ],
        ),
      ),
    );
  }

  void _showAddDialog(double x, double y, floorMapWidget.AddMode mode) async {
    final nameController = TextEditingController();
    final sizeController = TextEditingController();
    spaceEnum.Type selectedType = spaceEnum.Type.private;
    List<String> selectedEquipment = [];

    if (mode == floorMapWidget.AddMode.desk) {
      final id = DateTime.now().microsecondsSinceEpoch % 1000000000;
      final newDesk = Desk(
        id: id,
        checkinReference: id.toString(),
        x: x,
        y: y,
        floorId: 1,
      );
      Provider.of<SpaceProvider>(context, listen: false).addDesk(newDesk);
      return;
    }

    await showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setState) => AlertDialog(
          title: const Text("Add Meeting Room"),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: nameController,
                decoration: const InputDecoration(labelText: "Name"),
              ),
              TextField(
                controller: sizeController,
                decoration: const InputDecoration(labelText: "Size"),
                keyboardType: TextInputType.number,
              ),
              const SizedBox(height: 10),
              DropdownButton<spaceEnum.Type>(
                value: selectedType,
                onChanged: (value) => setState(() => selectedType = value!),
                items: spaceEnum.Type.values.map((type) => DropdownMenuItem(
                  value: type,
                  child: Text(type.name),
                )).toList(),
              ),
              const SizedBox(height: 10),
              ElevatedButton(
                onPressed: () async {
                  final result = await showEquipmentPicker(
                    context: context,
                    selectedItems: selectedEquipment,
                  );
                  setState(() => selectedEquipment = result);
                },
                child: const Text("Pick Equipment"),
              ),
              Wrap(
                spacing: 4,
                children: selectedEquipment.map((e) => Chip(label: Text(e))).toList(),
              )
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text("Cancel"),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                final name = nameController.text;
                final size = int.tryParse(sizeController.text) ?? 0;
                final newRoom = MeetingRoom(
                  id: DateTime.now().millisecondsSinceEpoch,
                  name: name,
                  size: size,
                  equipmentAvailable: selectedEquipment,
                  type: selectedType,
                  status: spaceEnum.Status.open,
                  x: x,
                  y: y,
                  floorId: 1,
                );
                Provider.of<SpaceProvider>(context, listen: false).addMeetingRoom(newRoom);
              },
              child: const Text("Add"),
            )
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final spaceProvider = Provider.of<SpaceProvider>(context);
    final desks = spaceProvider.desks;
    final meetingRooms = spaceProvider.meetingRooms;

    return Scaffold(
      appBar: AppBar(
        title: const Text("Floor Map"),
        actions: [
          PopupMenuButton<floorMapWidget.AddMode>(
            icon: const Icon(Icons.add),
            onSelected: (mode) => setState(() => _addMode = mode),
            itemBuilder: (context) => const [
              PopupMenuItem(
                value: floorMapWidget.AddMode.desk,
                child: Text('Add Desk'),
              ),
              PopupMenuItem(
                value: floorMapWidget.AddMode.meetingRoom,
                child: Text('Add Meeting Room'),
              ),
            ],
          ),
          if (_addMode != floorMapWidget.AddMode.none)
            IconButton(
              icon: const Icon(Icons.close),
              onPressed: () => setState(() => _addMode = floorMapWidget.AddMode.none),
            ),
        ],
      ),
      body: FloorMapBody(
        desks: desks,
        meetingRooms: meetingRooms,
        addMode: _addMode,
        onAddSpace: _showAddDialog,
        onBook: _showBookingDialog,
      ),
    );
  }
}

class FloorMapBody extends StatelessWidget {
  final List<Desk> desks;
  final List<MeetingRoom> meetingRooms;
  final floorMapWidget.AddMode addMode;
  final void Function(double x, double y, floorMapWidget.AddMode mode) onAddSpace;
  final void Function({required String spaceLabel}) onBook;

  const FloorMapBody({
    super.key,
    required this.desks,
    required this.meetingRooms,
    required this.addMode,
    required this.onAddSpace,
    required this.onBook,
  });

  @override
  Widget build(BuildContext context) {
    return desks.isEmpty && meetingRooms.isEmpty
        ? const Center(child: CircularProgressIndicator())
        : SizedBox.expand(
            child: floorMapWidget.FloorMapWidget(
              desks: desks,
              meetingRooms: meetingRooms,
              addMode: addMode,
              onAddSpace: onAddSpace,
              onDeskTapped: (desk) => onBook(spaceLabel: 'Desk ${desk.id}'),
              onMeetingRoomTapped: (room) => onBook(spaceLabel: 'Room ${room.name}'),
            ),
          );
  }
}
