import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:logger/logger.dart';
import 'package:orange_test/business/rates_api.dart';
import 'package:orange_test/data/standard_unit_rates/standard_unit_rates.dart';

part 'graph_event.dart';
part 'graph_state.dart';

class GraphBloc extends Bloc<GraphEvent, GraphState> {
  static final Logger _logger = Logger();
  GraphBloc({StandardUnitRates? standardUnitRates})
      : super(GraphState(
            showGraphValues: ShowGraphValues.All,
            firstBarIndex: 0,
            numberOfBarsToShow: 10,
            isLoading: standardUnitRates != null ? false : true,
            tappedBarIndex: 0,
            standardUnitRates: standardUnitRates)) {
    on<GetGraphData>(_getGraphData);
    on<ShowAllData>(_showAllData);
    on<ShowLowestPrice>(_showLowestPrice);
    on<ShowFourHourConsecutiveLowestPrice>(_showFourHourConsecutiveLowestPrice);
    on<ShowPreviousPage>(_showPreviousPage);
    on<ShowNextPage>(_showNextPage);
    on<UpdateTouchedBarIndex>(((event, emit) =>
        emit(state.copyWith(tappedBarIndex: event.touchedIndex))));
  }

  void _getGraphData(GetGraphData event, Emitter emit) async {
    try {
      StandardUnitRates standardUnitRates =
          await RatesAPI.getStandardUnitRates();
      emit(state.copyWith(
          standardUnitRates: standardUnitRates, isLoading: false));
    } catch (e) {
      _logger.d(e);
    }
  }

  void _showAllData(GraphEvent event, Emitter emit) {
    emit(state.copyWith(
        showGraphValues: ShowGraphValues.All,
        numberOfBarsToShow: 10,
        tappedBarIndex: 0));
  }

  void _showLowestPrice(ShowLowestPrice event, Emitter emit) {
    emit(state.copyWith(
        numberOfBarsToShow: 10, showGraphValues: ShowGraphValues.Lowest));
    if (state.standardUnitRates!.lowestIndex < 4) {
      emit(state.copyWith(
          firstBarIndex: 0,
          tappedBarIndex: state.standardUnitRates!.lowestIndex));
    } else {
      emit(state.copyWith(
          firstBarIndex: state.standardUnitRates!.lowestIndex - 4,
          tappedBarIndex: 4));
    }
  }

  void _showFourHourConsecutiveLowestPrice(
      ShowFourHourConsecutiveLowestPrice event, Emitter emit) {
    emit(state.copyWith(
        numberOfBarsToShow: 8,
        showGraphValues: ShowGraphValues.ConsecutiveFourHourLowest,
        firstBarIndex: state.standardUnitRates!.consecutiveLowestFirstIndex,
        tappedBarIndex: 0));
  }

  void _showPreviousPage(GraphEvent event, Emitter emit) {
    _showAllData(event, emit);
    if (state.firstBarIndex - state.numberOfBarsToShow >= 0) {
      emit(state.copyWith(
          firstBarIndex: state.firstBarIndex - state.numberOfBarsToShow));
    } else {
      emit(state.copyWith(firstBarIndex: 0));
    }
  }

  void _showNextPage(GraphEvent event, Emitter emit) {
    _showAllData(event, emit);
    if (state.firstBarIndex + state.numberOfBarsToShow <
        state.standardUnitRates!.rates.length) {
      emit(state.copyWith(
          firstBarIndex: state.firstBarIndex + state.numberOfBarsToShow));
    } else {
      emit(state.copyWith(
          firstBarIndex: state.standardUnitRates!.rates.length -
              state.numberOfBarsToShow));
    }
  }
}
