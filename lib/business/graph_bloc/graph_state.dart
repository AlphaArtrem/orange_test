part of 'graph_bloc.dart';

enum ShowGraphValues {
  // ignore: constant_identifier_names
  All,
  // ignore: constant_identifier_names
  Lowest,
  // ignore: constant_identifier_names
  Highest,
  // ignore: constant_identifier_names
  ConsecutiveFourHourLowest,
}

class GraphState extends Equatable {
  final int numberOfBarsToShow, firstBarIndex;
  final StandardUnitRates? standardUnitRates;
  final ShowGraphValues showGraphValues;
  final bool isLoading;
  final int tappedBarIndex;

  int barIndexToRatesIndex(int i) {
    return firstBarIndex + i;
  }

  const GraphState(
      {required this.showGraphValues,
      this.standardUnitRates,
      required this.firstBarIndex,
      required this.numberOfBarsToShow,
      required this.isLoading,
      required this.tappedBarIndex});

  GraphState copyWith(
      {int? numberOfBarsToShow,
      int? firstBarIndex,
      StandardUnitRates? standardUnitRates,
      ShowGraphValues? showGraphValues,
      bool? isLoading,
      int? tappedBarIndex}) {
    return GraphState(
        showGraphValues: showGraphValues ?? this.showGraphValues,
        standardUnitRates: standardUnitRates ?? this.standardUnitRates,
        firstBarIndex: firstBarIndex ?? this.firstBarIndex,
        numberOfBarsToShow: numberOfBarsToShow ?? this.numberOfBarsToShow,
        isLoading: isLoading ?? this.isLoading,
        tappedBarIndex: tappedBarIndex ?? this.tappedBarIndex);
  }

  @override
  List<Object?> get props => [
        numberOfBarsToShow,
        firstBarIndex,
        standardUnitRates,
        showGraphValues,
        isLoading,
        tappedBarIndex
      ];
}
