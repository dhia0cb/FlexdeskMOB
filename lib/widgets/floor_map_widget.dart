import 'package:flutter/material.dart';
import 'package:front_mobile/models/desk.dart';
import 'package:front_mobile/models/meeting_room.dart';
import '../widgets/space_enum.dart';
import 'package:front_mobile/widgets/status_badge.dart';
import 'package:provider/provider.dart';
import '../models/space_provider.dart';

enum AddMode { none, desk, meetingRoom }

class FloorMapWidget extends StatelessWidget {
  final List<Desk> desks;
  final List<MeetingRoom> meetingRooms;

  final AddMode addMode;
  final Function(double x, double y, AddMode mode)? onAddSpace;
  final Function(double x, double y)? onMapTapped;
  final Function(Desk desk) onDeskTapped;
  final Function(MeetingRoom room) onMeetingRoomTapped;

  const FloorMapWidget({
    super.key,
    required this.desks,
    required this.meetingRooms,
    this.addMode = AddMode.none,
    this.onAddSpace,
    this.onMapTapped,
    required this.onDeskTapped,
    required this.onMeetingRoomTapped,
  });

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: Stack(
          alignment: Alignment.topLeft,
          children: [
            Image.asset(
              "assets/images/floor_plan.png",
              width: 800,
              height: 600,
              fit: BoxFit.cover,
            ),
            ..._buildOverlays(context),
            if (addMode != AddMode.none && onAddSpace != null)
              Positioned.fill(
                child: GestureDetector(
                  behavior: HitTestBehavior.translucent,
                  onTapUp: (details) {
                    onAddSpace!(details.localPosition.dx, details.localPosition.dy, addMode);
                  },
                ),
              ),
            if (addMode == AddMode.none && onMapTapped != null)
              Positioned.fill(
                child: GestureDetector(
                  behavior: HitTestBehavior.translucent,
                  onTapUp: (details) {
                    onMapTapped!(details.localPosition.dx, details.localPosition.dy);
                  },
                ),
              ),
          ],
        ),
      ),
    );
  }

  List<Widget> _buildOverlays(BuildContext context) {
    List<Widget> overlays = [];
    Provider.of<SpaceProvider>(context);

    for (var desk in desks) {
      if (desk.x != null && desk.y != null) {
        final isBooked = desk.status == Status.booked;
        overlays.add(Positioned(
          left: desk.x!,
          top: desk.y!,
          child: GestureDetector(
            onTap: () => onDeskTapped(desk),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 20,
                  height: 20,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: isBooked
                        ? Colors.red.withAlpha((0.7 * 255).toInt())
                        : Colors.green.withAlpha((0.7 * 255).toInt()),
                    border: Border.all(color: Colors.white, width: 2),
                  ),
                ),
                StatusBadge(
                  status: desk.status.name,
                ),
              ],
            ),
          ),
        ));
      }
    }

    for (var room in meetingRooms) {
      if (room.x != null && room.y != null) {
        final isBooked = room.status == Status.booked;
        overlays.add(Positioned(
          left: room.x!,
          top: room.y!,
          child: GestureDetector(
            onTap: () => onMeetingRoomTapped(room),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 20,
                  height: 20,
                  decoration: BoxDecoration(
                    shape: BoxShape.rectangle,
                    color: isBooked
                        ? Colors.red.withAlpha((0.7 * 255).toInt())
                        : Colors.green.withAlpha((0.7 * 255).toInt()),
                    border: Border.all(color: Colors.white, width: 2),
                  ),
                ),
                StatusBadge(
                  status: room.status.name,
                ),
              ],
            ),
          ),
        ));
      }
    }

    return overlays;
  }
}
