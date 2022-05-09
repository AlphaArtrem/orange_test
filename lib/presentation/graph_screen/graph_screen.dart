import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:orange_test/business/graph_bloc/graph_bloc.dart';
import 'package:orange_test/data/standard_unit_rates/standard_unit_rates.dart';
import 'package:orange_test/data/static/custom_colors.dart';

part 'bar_graph.dart';

class GraphScreen extends StatefulWidget {
  final GraphBloc? graphBloc;
  const GraphScreen({Key? key, this.graphBloc}) : super(key: key);

  @override
  State<StatefulWidget> createState() => GraphScreenState();
}

class GraphScreenState extends State<GraphScreen> {
  static const Map<ShowGraphValues, String> _dataControls = {
    ShowGraphValues.All: 'All',
    ShowGraphValues.Lowest: '30m Lowest',
    ShowGraphValues.ConsecutiveFourHourLowest: '4h Lowest'
  };

  static final Map<ShowGraphValues, GraphEvent> _dataEvents = {
    ShowGraphValues.All: ShowAllData(),
    ShowGraphValues.Lowest: ShowLowestPrice(),
    ShowGraphValues.ConsecutiveFourHourLowest:
        ShowFourHourConsecutiveLowestPrice()
  };

  static final Map<GraphEvent, String> _chartControls = {
    ShowPreviousPage(): 'Last',
    ShowNextPage(): 'Next',
  };

  late final GraphBloc _graphBloc;

  late Size _size;

  @override
  void initState() {
    super.initState();
    if(widget.graphBloc != null){
      _graphBloc = widget.graphBloc!;
    }else{
      _graphBloc = GraphBloc();
      _graphBloc.add(GetGraphData());
    }
  }

  @override
  Widget build(BuildContext context) {
    _size = MediaQuery.of(context).size;
    return Scaffold(
      extendBodyBehindAppBar: true,
      backgroundColor: CustomColors.kPrimaryColor,
      body: SafeArea(
        child: Container(
          height: _size.height,
          width: _size.width,
          padding: const EdgeInsets.all(16),
          child: BlocBuilder<GraphBloc, GraphState>(
            bloc: _graphBloc,
            builder: (context, state) {
              return state.isLoading ? _getLoader() : _getBody();
            },
          ),
        ),
      ),
    );
  }

  Widget _getLoader() {
    return Center(
        child: CircularProgressIndicator(
      strokeWidth: 6.0,
      color: CustomColors.kPrimaryColorContrast,
    ));
  }

  Widget _getBody() {
    Widget graph = BlocProvider<GraphBloc>.value(
      value: _graphBloc,
      child: _BarGraph(),
    );
    return Stack(
      children: [
        if (MediaQuery.of(context).orientation == Orientation.portrait)
          Column(
            children: [
              _getDataControls(),
              const SizedBox(
                height: 25,
              ),
              graph,
              const SizedBox(
                height: 40,
              ),
              _getChartControls(),
              const SizedBox(
                height: 20,
              ),
              Expanded(child: _getDetailsSection())
            ],
          )
        else
          Row(
            children: [
              Expanded(
                  flex: 3,
                  child: Column(
                    children: [
                      _getDataControls(),
                      const SizedBox(
                        height: 20,
                      ),
                      Expanded(
                        child: graph,
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      _getChartControls(),
                    ],
                  )),
              const SizedBox(
                width: 20,
              ),
              Expanded(
                child: _getDetailsSection(),
                flex: 2,
              )
            ],
          ),
      ],
    );
  }

  Widget _getDataControls() {
    return Container(
      height: 40,
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(25.0),
          color: CustomColors.kPrimaryColorContrast,
          border: Border.all(color: CustomColors.kPrimaryColorContrast)),
      child: Row(
        children: List.generate(_dataControls.length, _getDataControl),
      ),
    );
  }

  Expanded _getDataControl(int index) {
    return Expanded(
      child: Container(
        height: 40,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(25.0),
          color: _dataControls.keys.elementAt(index) ==
                  _graphBloc.state.showGraphValues
              ? CustomColors.kPrimaryColor
              : Colors.transparent,
        ),
        child: TextButton(
            onPressed: () =>
                _graphBloc.add(_dataEvents.values.elementAt(index)),
            child: Text(
              _dataControls.values.elementAt(index),
              style: TextStyle(
                  color: _dataControls.keys.elementAt(index) ==
                          _graphBloc.state.showGraphValues
                      ? CustomColors.kTextColor
                      : CustomColors.kPrimaryColor,
                  fontSize: 20.0 * _size.height * 0.001,
                  fontWeight: FontWeight.bold),
            )),
      ),
    );
  }

  Widget _getChartControls() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: List.generate(_chartControls.length, _getChartControl),
    );
  }

  Widget _getChartControl(int index) {
    bool isLandscape =
        MediaQuery.of(context).orientation == Orientation.landscape;
    bool isVisible;
    bool increment = _chartControls.keys.elementAt(index) is ShowNextPage;
    if (increment) {
      isVisible =
          _graphBloc.state.barIndexToRatesIndex(_graphBloc.state.numberOfBarsToShow) <
              _graphBloc.state.standardUnitRates!.rates.length;
    } else {
      isVisible = _graphBloc.state
              .barIndexToRatesIndex(-_graphBloc.state.numberOfBarsToShow) >=
          0;
    }
    return isVisible
        ? MaterialButton(
            padding: const EdgeInsets.all(2.5),
            color: isLandscape
                ? CustomColors.kPrimaryColorContrast
                : Colors.transparent,
            elevation: 0.0,
            onPressed: () =>
                _graphBloc.add(_chartControls.keys.elementAt(index)),
            child: Text(
              _chartControls.values.elementAt(index),
              style: TextStyle(
                color: isLandscape
                    ? CustomColors.kPrimaryColor
                    : CustomColors.kTextColor,
                fontWeight: FontWeight.bold,
                fontSize: 20.0 * _size.height * 0.001,
              ),
            ),
          )
        : const SizedBox();
  }

  Widget _getDetailsSection() {
    RateData rateData = _graphBloc.state.standardUnitRates!.rates[
        _graphBloc.state.barIndexToRatesIndex(_graphBloc.state.tappedBarIndex)];
    return Card(
      color: CustomColors.kPrimaryColorContrast,
      elevation: 2.0,
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisSize: MainAxisSize.max,
          children: [
            _getDetail(
                title: 'Valid From',
                detail: rateData.validFromDate +
                    " " +
                    rateData.validFromTime.format(context)),
            _getDetail(
                title: 'Valid To',
                detail: rateData.validToDate +
                    " " +
                    rateData.validToTime.format(context)),
            _getDetail(title: 'Value', detail: rateData.valueIncVat.toString())
          ],
        ),
      ),
    );
  }

  Widget _getDetail({required String title, required String detail}) {
    return Expanded(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            title,
            style: TextStyle(
                color: CustomColors.kPrimaryColor,
                fontSize: 20.0 * _size.height * 0.001,
                fontWeight: FontWeight.w500),
          ),
          const SizedBox(
            height: 10.0,
          ),
          Flexible(
            child: Text(
              detail,
              style: TextStyle(
                  color: CustomColors.kSecondaryColorContrast,
                  fontSize: 22.0 * _size.height * 0.001,
                  fontWeight: FontWeight.w400),
              textAlign: TextAlign.center,
            ),
          ),
        ],
      ),
    );
  }
}
