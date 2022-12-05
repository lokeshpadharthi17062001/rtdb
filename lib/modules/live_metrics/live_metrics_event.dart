part of 'live_metrics_bloc.dart';

abstract class LiveMetricsEvent extends Equatable {
  const LiveMetricsEvent();
}

class LiveMetricsSensorSearchEvent extends LiveMetricsEvent {
  final String deviceName;
  const LiveMetricsSensorSearchEvent({required this.deviceName});

  @override
  List<Object> get props => [deviceName];
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
