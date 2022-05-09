import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:orange_test/business/graph_bloc/graph_bloc.dart';
import 'package:orange_test/data/standard_unit_rates/standard_unit_rates.dart';
import 'package:orange_test/presentation/graph_screen/graph_screen.dart';

void main() {
  const Map<String, dynamic> json = {
    "count": 93835,
    "next":
        "https://api.octopus.energy/v1/products/AGILE-18-02-21/electricity-tariffs/E-1R-AGILE-18-02-21-A/standard-unit-rates/?page=2",
    "previous": null,
    "results": [
      {
        "value_exc_vat": 12.98,
        "value_inc_vat": 13.629,
        "valid_from": "2022-05-09T21:30:00Z",
        "valid_to": "2022-05-09T22:00:00Z"
      },
      {
        "value_exc_vat": 21.0,
        "value_inc_vat": 22.05,
        "valid_from": "2022-05-09T21:00:00Z",
        "valid_to": "2022-05-09T21:30:00Z"
      },
      {
        "value_exc_vat": 21.0,
        "value_inc_vat": 22.05,
        "valid_from": "2022-05-09T20:30:00Z",
        "valid_to": "2022-05-09T21:00:00Z"
      },
      {
        "value_exc_vat": 29.58,
        "value_inc_vat": 31.059,
        "valid_from": "2022-05-09T20:00:00Z",
        "valid_to": "2022-05-09T20:30:00Z"
      },
      {
        "value_exc_vat": 18.9,
        "value_inc_vat": 19.845,
        "valid_from": "2022-05-09T19:30:00Z",
        "valid_to": "2022-05-09T20:00:00Z"
      },
      {
        "value_exc_vat": 18.9,
        "value_inc_vat": 19.845,
        "valid_from": "2022-05-09T19:00:00Z",
        "valid_to": "2022-05-09T19:30:00Z"
      },
      {
        "value_exc_vat": 17.22,
        "value_inc_vat": 18.081,
        "valid_from": "2022-05-09T18:30:00Z",
        "valid_to": "2022-05-09T19:00:00Z"
      },
      {
        "value_exc_vat": 24.86,
        "value_inc_vat": 26.103,
        "valid_from": "2022-05-09T18:00:00Z",
        "valid_to": "2022-05-09T18:30:00Z"
      },
      {
        "value_exc_vat": 33.33,
        "value_inc_vat": 34.9965,
        "valid_from": "2022-05-09T17:30:00Z",
        "valid_to": "2022-05-09T18:00:00Z"
      },
      {
        "value_exc_vat": 33.33,
        "value_inc_vat": 34.9965,
        "valid_from": "2022-05-09T17:00:00Z",
        "valid_to": "2022-05-09T17:30:00Z"
      },
      {
        "value_exc_vat": 33.33,
        "value_inc_vat": 34.9965,
        "valid_from": "2022-05-09T16:30:00Z",
        "valid_to": "2022-05-09T17:00:00Z"
      },
      {
        "value_exc_vat": 33.33,
        "value_inc_vat": 34.9965,
        "valid_from": "2022-05-09T16:00:00Z",
        "valid_to": "2022-05-09T16:30:00Z"
      },
      {
        "value_exc_vat": 33.33,
        "value_inc_vat": 34.9965,
        "valid_from": "2022-05-09T15:30:00Z",
        "valid_to": "2022-05-09T16:00:00Z"
      },
      {
        "value_exc_vat": 31.56,
        "value_inc_vat": 33.138,
        "valid_from": "2022-05-09T15:00:00Z",
        "valid_to": "2022-05-09T15:30:00Z"
      },
      {
        "value_exc_vat": 19.95,
        "value_inc_vat": 20.9475,
        "valid_from": "2022-05-09T14:30:00Z",
        "valid_to": "2022-05-09T15:00:00Z"
      }
    ]
  };

  test('Standard unit rates parsing test', () {
    final StandardUnitRates standardUnitRates =
        StandardUnitRates.fromJson(json);
    expect(standardUnitRates.count, 93835, reason: "Count doesn't match");
    expect(standardUnitRates.rates[standardUnitRates.lowestIndex].valueIncVat,
        13.629,
        reason: "Lowest price doesn't match");
    expect(standardUnitRates.rates[standardUnitRates.highestIndex].valueIncVat,
        34.9965,
        reason: "Highest price doesn't match");
    expect(
        standardUnitRates
            .rates[standardUnitRates.consecutiveLowestFirstIndex].valueIncVat,
        13.629,
        reason: "Consecutive 4 hour lowest price first value doesn't match");
  });

  testWidgets('Graph screen smoke test', (WidgetTester tester) async {
    //Graph bloc with predefined standard unit rates data as
    // we can't make API call during tests
    final StandardUnitRates standardUnitRates =
        StandardUnitRates.fromJson(json);
    final GraphBloc graphBloc = GraphBloc(standardUnitRates: standardUnitRates);

    // Build our app and trigger a frame.
    await tester.pumpWidget(MaterialApp(
        home: GraphScreen(
      graphBloc: graphBloc,
    )));

    //Wait for all frames to load
    await tester.pumpAndSettle(const Duration(seconds: 1));

    // Verify data controls
    expect(find.text('All'), findsOneWidget,
        reason: "Couldn't find the 'All' tab");
    expect(find.text('30m Lowest'), findsOneWidget,
        reason: "Couldn't find the '30m Lowest' tab");
    expect(find.text('4h Lowest'), findsOneWidget,
        reason: "Couldn't find the '4h Lowest' tab");

    // Test data controls
    await tester.tap(find.text('30m Lowest'));
    await tester.pump();
    expect(graphBloc.state.showGraphValues, ShowGraphValues.Lowest,
        reason: "Couldn't switch to '30m Lowest' tab");

    await tester.tap(find.text('All'));
    await tester.pump();
    expect(graphBloc.state.showGraphValues, ShowGraphValues.All,
        reason: "Couldn't switch to 'All' tab");

    await tester.tap(find.text('4h Lowest'));
    await tester.pump();
    expect(graphBloc.state.showGraphValues,
        ShowGraphValues.ConsecutiveFourHourLowest,
        reason: "Couldn't switch to '4h Lowest' tab");
    expect(graphBloc.state.numberOfBarsToShow, 8,
        reason: """Max bars to be shown should be 8 in"""
            """"${ShowGraphValues.ConsecutiveFourHourLowest} mode""");

    //Verify details section
    expect(find.text('Valid To'), findsOneWidget,
        reason: "Couldn't find the 'Valid To'' heading");
    expect(find.text('Valid From'), findsOneWidget,
        reason: "Couldn't find the 'Valid From'' heading");
    expect(find.text('Value'), findsOneWidget,
        reason: "Couldn't find the 'Value' heading");

    // Verify chart controls
    expect(find.text('Next'), findsOneWidget,
        reason: "Couldn't find the 'Next' option");
    expect(find.text('Last'), findsNothing,
        reason: "Couldn't find the 'Last' option");
    await tester.tap(find.text('Next'));
    await tester.pump();
    expect(find.text('Last'), findsOneWidget,
        reason: "Couldn't find the 'Last' option");
  });
}
