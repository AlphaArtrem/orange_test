import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

part 'rate_data.dart';

class StandardUnitRates extends Equatable {
  late final int _count;
  late final String? _next;
  late final String? _previous;
  late final List<RateData> _rates;
  int _highestIndex = 0;
  int _lowestIndex = 0;
  int _consecutiveLowestFirstIndex = 0;

  int get count => _count;
  String? get next => _next;
  String? get previous => _previous;
  List<RateData> get rates => _rates;
  int get highestIndex => _highestIndex;
  int get lowestIndex => _lowestIndex;
  int get consecutiveLowestFirstIndex => _consecutiveLowestFirstIndex;

  StandardUnitRates.fromJson(Map<String, dynamic> json) {
    _count = json['count'];
    _next = json['next'];
    _previous = json['previous'];
    _rates = [];
    List<double> consecutiveSums = [];
    _processUnitRates(json, consecutiveSums);
    _getConsecutiveBest(consecutiveSums);
  }

  void _processUnitRates(Map<String, dynamic> json, List<double> consecutiveSums){
    for (int i = 0; i < json['results'].length; i++) {
      RateData rate = RateData.fromJson(json['results'][i]);
      _rates.add(rate);
      if (rate.valueIncVat <= _rates[_lowestIndex].valueIncVat) {
        _lowestIndex = _rates.length - 1;
      }

      if (rate.valueIncVat >= _rates[_highestIndex].valueIncVat) {
        _highestIndex = _rates.length - 1;
      }

      if (consecutiveSums.isEmpty) {
        consecutiveSums.add(rate.valueIncVat);
      } else {
        consecutiveSums.add((consecutiveSums[i - 1] + rate.valueIncVat));
      }
    }
  }

  void _getConsecutiveBest(List<double> consecutiveSums){
    double lowestConsecutiveSum = double.infinity;
    for (int i = 8; i < _rates.length; i++) {
      double currentSum = consecutiveSums[i] - consecutiveSums[i - 8];
      if (currentSum < lowestConsecutiveSum) {
        lowestConsecutiveSum = currentSum;
        _consecutiveLowestFirstIndex = i - 8;
      }
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    data['count'] = _count;
    data['next'] = _next;
    data['previous'] = _previous;
    data['results'] = _rates.map((v) => v.toJson()).toList();
    return data;
  }

  @override
  List<Object?> get props => [
        _count,
        _next,
        _previous,
        _rates,
        _highestIndex,
        _lowestIndex,
        _consecutiveLowestFirstIndex
      ];
}
