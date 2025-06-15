enum SpaceType {
  desk,
  meetingRoom;
}

extension SpaceTypeToString on SpaceType {
  String get name {
    switch (this) {
      case SpaceType.desk:
        return 'desk';
      case SpaceType.meetingRoom:
        return 'meeting_room';
    }
  }
}

SpaceType parseSpaceType(String value) {
  final lower = value.toLowerCase();
  if (lower == 'desk') return SpaceType.desk;
  if (lower == 'meetingroom' || lower == 'meeting_room' || lower == 'meeting room') {
    return SpaceType.meetingRoom;
  }
  return SpaceType.desk;
}