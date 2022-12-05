/// athlete_meta_data : {"user_name":"Naveen","age":"23","height":"181","weight":"80","gender":"male"}
/// layout_info : {"priority":"card_hidden"}

class LocalUserProfile {
  LocalUserProfile({this.athleteMetaData, this.layoutInfo, this.sessionData});

  LocalUserProfile.fromJson(dynamic json) {
    athleteMetaData = json['athlete_meta_data'] != null
        ? AthleteMetaData.fromJson(json['athlete_meta_data'])
        : null;
    layoutInfo = json['layout_info'] != null
        ? LayoutInfo.fromJson(json['layout_info'])
        : null;
    sessionData = json['session_data'] != null
        ? SessionData.fromJson(json['session_data'])
        : null;
  }

  AthleteMetaData? athleteMetaData;
  LayoutInfo? layoutInfo;
  SessionData? sessionData;
  LocalUserProfile copyWith({
    AthleteMetaData? athleteMetaData,
    LayoutInfo? layoutInfo,
    SessionData? sessionData,
  }) =>
      LocalUserProfile(
          athleteMetaData: athleteMetaData ?? this.athleteMetaData,
          layoutInfo: layoutInfo ?? this.layoutInfo,
          sessionData: sessionData ?? this.sessionData);

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    if (athleteMetaData != null) {
      map['athlete_meta_data'] = athleteMetaData?.toJson();
    }
    if (layoutInfo != null) {
      map['layout_info'] = layoutInfo?.toJson();
    }
    if (sessionData != null) {
      map['session_data'] = sessionData?.toJson();
    }
    return map;
  }
}

/// priority : "card_hidden"

class LayoutInfo {
  LayoutInfo({this.priority, this.rank});

  LayoutInfo.fromJson(dynamic json) {
    priority = fetchCardPriority(json['priority']);
    rank = json['rank'];
  }

  CardPriority fetchCardPriority(String priority) {
    switch (priority) {
      case "cardHidden":
        return CardPriority.cardHidden;
      case "cardDeleted":
        return CardPriority.cardDeleted;
      case "cardVisible":
        return CardPriority.cardVisible;
      default:
        return CardPriority.cardVisible;
    }
  }

  CardPriority? priority;
  int? rank;

  LayoutInfo copyWith({CardPriority? priority, int? rank}) => LayoutInfo(
        priority: priority ?? this.priority,
        rank: rank ?? this.rank,
      );

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['priority'] = priority?.name;
    map['rank'] = rank;
    return map;
  }
}

/// user_name : "Naveen"
/// age : "23"
/// height : "181"
/// weight : "80"
/// gender : "male"

class AthleteMetaData {
  AthleteMetaData({
    this.firstName,
    this.lastName,
    this.age,
    this.height,
    this.weight,
    this.gender,
  });

  AthleteMetaData.fromJson(dynamic json) {
    firstName = json['first_name'];
    lastName = json['last_name'];
    age = json['age'];
    height = json['height'];
    weight = json['weight'];
    gender = IGender.fetchGender(json['gender']);
  }

  String? firstName;
  String? lastName;
  String? age;
  String? height;
  String? weight;
  Gender? gender;

  AthleteMetaData copyWith({
    String? firstName,
    String? lastName,
    String? age,
    String? height,
    String? weight,
    Gender? gender,
  }) =>
      AthleteMetaData(
        firstName: firstName ?? this.firstName,
        lastName: lastName ?? this.lastName,
        age: age ?? this.age,
        height: height ?? this.height,
        weight: weight ?? this.weight,
        gender: gender ?? this.gender,
      );

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['first_name'] = firstName;
    map['last_name'] = lastName;
    map['age'] = age;
    map['height'] = height;
    map['weight'] = weight;
    map['gender'] = gender?.name;
    return map;
  }
}

class SessionData {
  SessionData(
      {this.sessionStopTime,
      this.timeZone,
      this.restingHr,
      this.appVersion,
      this.firmwareVersion,
      this.dateTime});

  SessionData.fromJson(dynamic json) {
    sessionStopTime = json['session_stop_time'];
    timeZone = json['time_zone'];
    restingHr = json['resting_hr'];
    appVersion = json['app_version'];
    firmwareVersion = json['firmware_version'];
    dateTime = json['date_time'];
  }

  int? sessionStopTime;
  String? timeZone;
  int? restingHr;
  String? firmwareVersion;
  String? appVersion;
  String? dateTime;

  SessionData copyWith(
          {int? sessionStopTime,
          String? timeZone,
          int? restingHr,
          String? firmwareVersion,
          String? appVersion,
          String? dateTime}) =>
      SessionData(
        sessionStopTime: sessionStopTime ?? this.sessionStopTime,
        timeZone: timeZone ?? this.timeZone,
        restingHr: restingHr ?? this.restingHr,
        firmwareVersion: firmwareVersion ?? this.firmwareVersion,
        appVersion: appVersion ?? this.appVersion,
        dateTime: dateTime ?? this.dateTime,
      );

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['session_stop_time'] = sessionStopTime;
    map['time_zone'] = timeZone;
    map['resting_hr'] = restingHr;
    map['app_version'] = appVersion;
    map['firmware_version'] = firmwareVersion;
    map['date_time'] = dateTime;
    return map;
  }
}

enum Gender { male, female, other }

extension IGender on Gender {
  static Gender fetchGender(String? gender) {
    switch (gender) {
      case "Male":
        return Gender.male;
      case "Female":
        return Gender.female;
      case "Other":
        return Gender.other;
      default:
        return Gender.male;
    }
  }

  static int fetchGenderIndex(Gender gender) {
    switch (gender) {
      case Gender.male:
        return 0;
      case Gender.female:
        return 1;
      case Gender.other:
        return 2;
    }
  }
}

enum CardPriority { cardHidden, cardDeleted, cardVisible }

extension ICardPriority on CardPriority {
  CardPriority fetchCardPriority(String priority) {
    switch (priority) {
      case "cardHidden":
        return CardPriority.cardHidden;
      case "cardDeleted":
        return CardPriority.cardDeleted;
      case "cardVisible":
        return CardPriority.cardVisible;
      default:
        return CardPriority.cardVisible;
    }
  }
}
