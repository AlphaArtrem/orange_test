import 'package:logger/logger.dart';
import 'package:orange_test/business/api_helper.dart';
import 'package:orange_test/data/standard_unit_rates/standard_unit_rates.dart';
import 'package:orange_test/data/static/api_constants.dart';

class RatesAPI {
  static final Logger _logger = Logger();

  static Future<StandardUnitRates> getStandardUnitRates(
      {String url = ApiConstants.standardUnitRates}) async {
    try {
      Map<String, dynamic> apiResponse = await APIHelper.get(url);
      return StandardUnitRates.fromJson(apiResponse);
    } catch (e) {
      _logger.d(e.toString());
      rethrow;
    }
  }
}
