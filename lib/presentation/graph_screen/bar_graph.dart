part of 'graph_screen.dart';

class _BarGraph extends StatefulWidget {
  const _BarGraph({Key? key}) : super(key: key);

  @override
  State<_BarGraph> createState() => _BarGraphState();
}

class _BarGraphState extends State<_BarGraph> {
  final Duration _animDuration = const Duration(milliseconds: 250);
  late final GraphBloc _graphBloc;

  @override
  void initState() {
    super.initState();
    _graphBloc = BlocProvider.of<GraphBloc>(context);
  }

  @override
  Widget build(BuildContext context) {
    Widget barChart = BarChart(
      _mainBarData(),
      swapAnimationDuration: _animDuration,
    );
    return MediaQuery.of(context).orientation == Orientation.portrait
        ? SizedBox(
            height: MediaQuery.of(context).size.height * .5,
            child: barChart,
          )
        : barChart;
  }

  BarChartData _mainBarData() {
    AxisTitles doNotShowTiles = AxisTitles(
      sideTitles: SideTitles(showTitles: false),
    );
    return BarChartData(
      barTouchData: BarTouchData(
        touchTooltipData: BarTouchTooltipData(
            tooltipBgColor: CustomColors.kDialogueBackgroundColor,
            getTooltipItem: _getBarToolTip),
        touchCallback: _onBarTouched,
      ),
      titlesData: FlTitlesData(
        show: true,
        rightTitles: doNotShowTiles,
        topTitles: doNotShowTiles,
        bottomTitles: doNotShowTiles,
        leftTitles: AxisTitles(
          sideTitles: SideTitles(
              showTitles: true,
              getTitlesWidget: (y, _) => Text(
                    y.toStringAsFixed(0),
                    style: const TextStyle(color: CustomColors.kTextColor),
                  )),
        ),
      ),
      borderData: FlBorderData(
        show: false,
      ),
      barGroups: _getBars(),
      gridData: FlGridData(show: false),
    );
  }

  BarTooltipItem _getBarToolTip(BarChartGroupData group, int groupIndex,
      BarChartRodData rod, int rodIndex) {
    int index = _graphBloc.state.barIndexToRatesIndex(groupIndex);
    RateData rateData = _graphBloc.state.standardUnitRates!.rates[index];
    return BarTooltipItem(
      """${rateData.validFromDate} """
      """${rateData.validFromTime.format(context)} - """
      """${rateData.validToDate} """
      """${rateData.validToTime.format(context)}\n""",
      const TextStyle(
        color: CustomColors.kTextColor,
        fontWeight: FontWeight.bold,
        fontSize: 18,
      ),
      children: <TextSpan>[
        TextSpan(
          text: rateData.valueIncVat.toString(),
          style: const TextStyle(
            color: CustomColors.kTextHighlighted,
            fontSize: 16,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }

  void _onBarTouched(FlTouchEvent event, BarTouchResponse? barTouchResponse) {
    if (!event.isInterestedForInteractions ||
        barTouchResponse == null ||
        barTouchResponse.spot == null) {
      return;
    }
    _graphBloc.add(UpdateTouchedBarIndex(
        touchedIndex: barTouchResponse.spot!.touchedBarGroupIndex));
  }

  List<BarChartGroupData> _getBars() {
    int numberOfBars;
    if (_graphBloc.state.barIndexToRatesIndex(_graphBloc.state.numberOfBarsToShow) <
        _graphBloc.state.standardUnitRates!.rates.length) {
      numberOfBars = _graphBloc.state.numberOfBarsToShow;
    } else {
      numberOfBars = _graphBloc.state.standardUnitRates!.rates.length -
          _graphBloc.state.firstBarIndex;
    }
    return List.generate(numberOfBars, (i) {
      bool isTouched = i == _graphBloc.state.tappedBarIndex;
      double value = _graphBloc.state.standardUnitRates!
          .rates[_graphBloc.state.barIndexToRatesIndex(i)].valueIncVat;
      double maxValue = _graphBloc
              .state
              .standardUnitRates!
              .rates[_graphBloc.state.standardUnitRates!.highestIndex]
              .valueIncVat +
          20;

      return BarChartGroupData(
        x: i,
        barRods: [
          BarChartRodData(
            toY: isTouched ? value + 1 : value,
            color: isTouched
                ? CustomColors.kSecondaryColor
                : CustomColors.kSecondaryColorContrast,
            width: 20,
            borderSide: isTouched
                ? const BorderSide(
                    color: CustomColors.kSecondaryColor, width: 1)
                : const BorderSide(
                    color: CustomColors.kSecondaryColorContrast, width: 0),
            backDrawRodData: BackgroundBarChartRodData(
              show: true,
              toY: maxValue,
              color: CustomColors.kPrimaryColorContrast,
            ),
          ),
        ],
        showingTooltipIndicators: const [],
      );
    });
  }
}
