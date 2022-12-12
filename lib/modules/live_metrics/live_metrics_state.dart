part of 'live_metrics_bloc.dart';

abstract class LiveMetricsState extends Equatable {
  const LiveMetricsState();
}

class LiveMetricsInitialState extends LiveMetricsState {
  @override
  List<Object> get props => [];
}

class LiveMetricsSensorLoadingState extends LiveMetricsState {
  final String message;

  const LiveMetricsSensorLoadingState({required this.message});

  @override
  List<Object> get props => [message];
}

class LiveMetricsSensorLiveViewState extends LiveMetricsState {
  @override
  List<Object> get props => [];
}
class BluetoothTurnedOffState extends LiveMetricsState {
  @override
  List<Object> get props => [];
}

class LocationTurnedOffState extends LiveMetricsState {
  @override
  List<Object> get props => [];
}
class BleErrorState extends LiveMetricsState {
  @override
  List<Object> get props => [];
}
class GatewayCreateState extends LiveMetricsState {
  @override
  List<Object> get props => [];
}