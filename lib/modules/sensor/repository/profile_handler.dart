import 'dart:convert';

import 'package:rtdb/helpers/shared_preference.dart';
import 'package:rtdb/modules/sensor/models/local_user_profile.dart';

class ProfileHandler {
  static void setProfileDetails(
      String? firstName,
      String? lastName,
      String? age,
      String? weight,
      String? height,
      String deviceName,
      String? restingHr,
      {Gender? gender}) {
    AthleteMetaData athleteMetaData = AthleteMetaData(
        firstName: firstName,
        lastName: lastName,
        age: age,
        height: height,
        weight: weight,
        gender: gender);

    if (StorageManager.getLocalUserProfile() != null) {
      updateProfileDetails(deviceName, athleteMetaData, restingHr: restingHr);
    } else {
      setNewProfileDetails(deviceName, athleteMetaData, restingHr: restingHr);
    }
  }

  static void updateProfileDetails(
      String deviceName, AthleteMetaData athleteMetaData,
      {String? restingHr}) {
    Map<String, dynamic> deviceProfileDetails =
        jsonDecode(StorageManager.getLocalUserProfile()!);

    var deviceDetails = fetchProfileDetails(deviceName);
    if (deviceDetails != null) {
      deviceDetails.athleteMetaData = athleteMetaData;
      deviceProfileDetails[deviceName] = deviceDetails.toJson();
    } else {
      var restingHrValue = "50";
      if (restingHr != null && restingHr != "") {
        restingHrValue = restingHr;
      }
      SessionData sessionData =
          SessionData(restingHr: int.parse(restingHrValue));
      LocalUserProfile localUserProfile = LocalUserProfile(
          athleteMetaData: athleteMetaData, sessionData: sessionData);
      deviceProfileDetails[deviceName] = localUserProfile.toJson();
    }

    StorageManager.setLocalUserProfile(jsonEncode(deviceProfileDetails));
  }

  static void setNewProfileDetails(
      String deviceName, AthleteMetaData athleteMetaData,
      {String? restingHr}) {
    var restingHrValue = "50";
    if (restingHr != null && restingHr != "") {
      restingHrValue = restingHr;
    }
    SessionData sessionData = SessionData(restingHr: int.parse(restingHrValue));
    LocalUserProfile localUserProfile = LocalUserProfile(
        athleteMetaData: athleteMetaData, sessionData: sessionData);
    var profileJson = {deviceName: localUserProfile.toJson()};
    StorageManager.setLocalUserProfile(jsonEncode(profileJson));
  }

  static LocalUserProfile? fetchProfileDetails(String deviceName) {
    if (StorageManager.getLocalUserProfile() != null) {
      Map<String, dynamic> deviceProfileDetails =
          jsonDecode(StorageManager.getLocalUserProfile()!);

      if (deviceProfileDetails.containsKey(deviceName)) {
        LocalUserProfile localUserProfile =
            LocalUserProfile.fromJson(deviceProfileDetails[deviceName]);
        return localUserProfile;
      } else {
        return null;
      }
    } else {
      return null;
    }
  }

  static void setSessionDetails(
      LocalUserProfile? localUserProfile, String deviceName) {
    if (StorageManager.getLocalUserProfile() != null) {
      Map<String, dynamic> deviceProfileDetails =
          jsonDecode(StorageManager.getLocalUserProfile()!);
      deviceProfileDetails[deviceName] = localUserProfile?.toJson();
      StorageManager.setLocalUserProfile(jsonEncode(deviceProfileDetails));
    } else {
      var profileJson = {deviceName: localUserProfile?.toJson()};
      StorageManager.setLocalUserProfile(jsonEncode(profileJson));
    }
  }
}
