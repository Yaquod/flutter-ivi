import 'package:flutter/foundation.dart';

class TripProvider extends ChangeNotifier {
  final String _passengerName = 'Ahmed';
  double _fareUsd = 45.0;
  int _etaMin = 18;

  String get passengerName => _passengerName;
  double get fareUsd => _fareUsd;
  int get etaMin => _etaMin;

  void updateEta(int etaMin) {
    _etaMin = etaMin;
    notifyListeners();
  }

  void updateFare(double fare) {
    _fareUsd = fare;
    notifyListeners();
  }
}
