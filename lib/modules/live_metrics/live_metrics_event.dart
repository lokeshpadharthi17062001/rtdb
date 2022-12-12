part of 'live_metrics_bloc.dart';

abstract class LiveMetricsEvent extends Equatable {
  const LiveMetricsEvent();
}

class LiveMetricsSensorLiveViewEvent extends LiveMetricsEvent {
  const LiveMetricsSensorLiveViewEvent();

  @override
  List<Object> get props => [];
}

class LiveMetricsSensorStopEvent extends LiveMetricsEvent {
  const LiveMetricsSensorStopEvent();

  @override
  List<Object> get props => [];
}

class LiveMetricsSensorRescanEvent extends LiveMetricsEvent {
  const LiveMetricsSensorRescanEvent();

  @override
  List<Object> get props => [];
}
class BluetoothTurnedOffEvent extends LiveMetricsEvent {
  const BluetoothTurnedOffEvent();

  @override
  List<Object> get props => [];
}

class LocationTurnedOffEvent extends LiveMetricsEvent {
  const LocationTurnedOffEvent();

  @override
  List<Object> get props => [];
}
class BleErrorEvent extends LiveMetricsEvent {
  const BleErrorEvent();

  @override
  List<Object> get props => [];
}
class GatewayCreateEvent extends LiveMetricsEvent {
  const GatewayCreateEvent();

  @override
  List<Object> get props => [];
}