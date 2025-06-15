enum AddMode {
  desk,
  meetingRoom,
}

enum Type {
  public,
  private;

  String get name => toString().split('.').last;
}

enum Status {
  open,
  close,
  booked;

  String get name => toString().split('.').last;
}
