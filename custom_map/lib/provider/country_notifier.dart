import 'package:collection/collection.dart';
import 'package:custom_map/model/county_continent_model/country_continent_list.dart';
import 'package:custom_map/model/county_continent_model/country_continent_model.dart';
import 'package:custom_map/model/model.dart';
import 'package:flutter/material.dart';

class CountryNotifier extends ChangeNotifier {
  ///selected country add into this list
  final List<Model> _data = [
    const Model(country: '', state: '', color: Colors.green),
  ];

  List<Model> get dataList => _data;

  final List<Map<String, dynamic>> newContinentList = countryContinentList;

  List<Map<String, dynamic>> countryContinentMapList = [];

  Map<String, List<CountryContinentModel>> _groupedCountries = {};

  Map<String, List<CountryContinentModel>> get groupedCountries => _groupedCountries;

  ///get countries from json response
  Future<void> getCountries() async {
    try {
      List<Map<String, dynamic>> jsonList = newContinentList;

      List<CountryContinentModel> elements = jsonList.map((json) => CountryContinentModel.fromJson(json)).toList();

      ///group of  CountryContinent
      _groupedCountries = groupBy(elements, (CountryContinentModel value) => value.continent ?? '');

      notifyListeners();
    } on Exception catch (e, st) {
      debugPrint('ERROR$e');
      debugPrint('StackTrace$st');
    }
  }

  void onTapCallBack({required Model model}) async {
    try {
      final tempList = _data.where((element) => element.country == model.country).toList();

      await Future.delayed(
        const Duration(milliseconds: 200),
      );
      if (tempList.isNotEmpty) {
        _data.removeWhere((element) => element.country == model.country);
      } else {
        _data.add(model);
      }

      notifyListeners();
    } catch (e, st) {
      debugPrint('Error $e');
      debugPrint('Stack Trace $st');
    }
  }
}
