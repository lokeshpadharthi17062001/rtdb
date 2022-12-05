import 'dart:convert';

import 'package:rtdb/helpers/shared_preference.dart';
import 'package:rtdb/modules/sensor/models/live_view_data.dart';

enum LayoutStatus { emptyCard, runningCard, offlineCard, notRunningCard }

class LayoutModel {
  LiveViewData? liveViewData;
  String? offlineDeviceName;
  LayoutStatus layoutStatus;
  LayoutModel(
      {this.liveViewData,
      this.layoutStatus = LayoutStatus.emptyCard,
      this.offlineDeviceName});
}

const layoutGridLength = 12;

class LayoutHandler {
  static final LayoutHandler _client = LayoutHandler._internal();

  factory LayoutHandler() {
    return _client;
  }

  static LayoutHandler get instance => _client;

  List<int> rankList =
      List<int>.generate(layoutGridLength, (index) => index + 1);

  var knownDevicesList = List<LayoutModel>.generate(layoutGridLength,
      (index) => LayoutModel(layoutStatus: LayoutStatus.emptyCard));

  LayoutHandler._internal() {
    knownDevicesList = List<LayoutModel>.generate(
        layoutGridLength, (index) => fetchLayoutModel(index));
  }

  void initializeDeviceList() {
    knownDevicesList = List<LayoutModel>.generate(layoutGridLength,
        (index) => LayoutModel(layoutStatus: LayoutStatus.emptyCard));
  }

  LayoutModel fetchLayoutModel(int index) {
    var storedDeviceLayout = fetchDeviceLayout();
    if (storedDeviceLayout != null) {
      if (isRankExists(storedDeviceLayout, index)) {
        Iterable<String> deviceName = storedDeviceLayout.keys
            .where((k) => storedDeviceLayout[k] == index);
        return LayoutModel(
            layoutStatus: LayoutStatus.offlineCard,
            offlineDeviceName: deviceName.first);
      } else {
        return LayoutModel(layoutStatus: LayoutStatus.emptyCard);
      }
    } else {
      return LayoutModel(layoutStatus: LayoutStatus.emptyCard);
    }
  }

  void setDeviceLayout(String deviceName, int rank) {
    var storedDeviceLayout = fetchDeviceLayout();

    if (storedDeviceLayout != null) {
      updateDeviceLayout(deviceName, rank, storedDeviceLayout);
    } else {
      insertNewLayout(deviceName, rank);
    }
  }

  void updateDeviceLayout(
      String deviceName, int rank, Map<String, dynamic> storedDeviceLayout) {
    var layout = storedDeviceLayout;
    if (isRankExists(layout, rank)) {
      Iterable<String> device = layout.keys.where((k) => layout[k] == rank);
      layout.remove(device.first);
    }

    layout[deviceName] = rank;
    StorageManager.setDevicesLayout(jsonEncode(layout));
  }

  void removeLayout(int rank) {
    var layout = fetchDeviceLayout()!;

    if (isRankExists(layout, rank)) {
      Iterable<String> device = layout.keys.where((k) => layout[k] == rank);
      layout.remove(device.first);
    }

    StorageManager.setDevicesLayout(jsonEncode(layout));
  }

  void insertNewLayout(String deviceName, int rank) {
    var layout = {deviceName: rank};
    StorageManager.setDevicesLayout(jsonEncode(layout));
  }

  bool isRankExists(Map<String, dynamic> layoutDetails, int rank) {
    return layoutDetails.containsValue(rank);
  }

  Map<String, dynamic>? fetchDeviceLayout() {
    if (StorageManager.getDeviceLayout() != null) {
      Map<String, dynamic> layout =
          jsonDecode(StorageManager.getDeviceLayout()!);
      return layout;
    } else {
      return null;
    }
  }

  void resetKnownDevices() {
    knownDevicesList = List<LayoutModel>.generate(
        layoutGridLength, (index) => fetchLayoutModel(index));
  }
}
