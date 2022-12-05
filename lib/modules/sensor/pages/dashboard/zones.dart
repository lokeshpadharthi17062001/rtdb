enum Zones { zone_0, zone_1, zone_2, zone_3, zone_4, zone_5 }

extension Izones on Zones {
  int get zoneIndex {
    switch (this) {
      case Zones.zone_0:
        return 0;
      case Zones.zone_1:
        return 1;
      case Zones.zone_2:
        return 2;
      case Zones.zone_3:
        return 3;
      case Zones.zone_4:
        return 4;
      case Zones.zone_5:
        return 5;
    }
  }
}
