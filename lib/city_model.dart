import 'package:flutter/foundation.dart';

class CityModel extends ChangeNotifier {
  String _selectedCity = "Kuala Lumpur";

  String get selectedCity => _selectedCity;

  void setCity(String city) {
    _selectedCity = city;
    notifyListeners();
  }
}
