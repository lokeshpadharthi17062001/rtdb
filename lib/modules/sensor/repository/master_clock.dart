class MasterClock {
  static final MasterClock _client = MasterClock._internal();

  factory MasterClock() {
    return _client;
  }

  MasterClock._internal();

  static MasterClock get instance => _client;

  DateTime? _initialTime;

  bool isInitialTimeSet = false;

  ///This method is used for setting the initialTime for the appTimer
  void setInitialTime() {
    if (!isInitialTimeSet) {
      _initialTime = DateTime.now();
      isInitialTimeSet = true;
    }
  }

  DateTime? getInitialTime() {
    return _initialTime;
  }
}
