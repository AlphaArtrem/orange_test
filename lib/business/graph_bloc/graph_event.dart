part of 'graph_bloc.dart';

class GraphEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class GetGraphData extends GraphEvent {
  @override
  List<Object?> get props => [];
}

class ShowAllData extends GraphEvent {
  @override
  List<Object?> get props => [];
}

class ShowLowestPrice extends GraphEvent {
  @override
  List<Object?> get props => [];
}

class ShowFourHourConsecutiveLowestPrice extends GraphEvent {
  @override
  List<Object?> get props => [];
}

class ShowPreviousPage extends GraphEvent {
  @override
  List<Object?> get props => [];
}

class ShowNextPage extends GraphEvent {
  @override
  List<Object?> get props => [];
}

class UpdateTouchedBarIndex extends GraphEvent {
  final int touchedIndex;
  UpdateTouchedBarIndex({required this.touchedIndex});
  @override
  List<Object?> get props => [touchedIndex];
}
