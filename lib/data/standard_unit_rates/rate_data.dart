part of 'standard_unit_rates.dart';

class RateData extends Equatable{
  late final double _valueExcVat;
  late final double _valueIncVat;
  late final DateTime _validFrom;
  late final DateTime _validTo;

  double get valueExcVat => _valueExcVat;
  double get valueIncVat => _valueIncVat;
  DateTime get validFrom => _validFrom;
  DateTime get validTo => _validTo;
  String get validFromDate => validFrom.toString().split(' ').first;
  String get validToDate => validTo.toString().split(' ').first;
  TimeOfDay get validFromTime => TimeOfDay.fromDateTime(validFrom);
  TimeOfDay get validToTime => TimeOfDay.fromDateTime(validTo);


  RateData(
      {required double valueExcVat,
      required double valueIncVat,
      required DateTime validFrom,
      required DateTime validTo}){
    _validFrom = validFrom;
    _validTo = validTo;
    _valueExcVat = valueExcVat;
    _valueIncVat = valueIncVat;
  }

  RateData.fromJson(Map<String, dynamic> json) {
    _valueExcVat = json['value_exc_vat'];
    _valueIncVat = json['value_inc_vat'];
    _validFrom = DateTime.parse(json['valid_from']);
    _validTo = DateTime.parse(json['valid_to']);
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    data['value_exc_vat'] = _valueExcVat;
    data['value_inc_vat'] = _valueIncVat;
    data['valid_from'] = _validFrom.toIso8601String();
    data['valid_to'] = _validTo.toIso8601String();
    return data;
  }

  @override
  List<Object?> get props => [_valueIncVat, _valueIncVat, _validFrom, _validTo];
}
