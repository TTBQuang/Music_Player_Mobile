import 'package:flutter/widgets.dart';

class SizeConfig {
  static late double _screenWidth;
  static late double _screenHeight;

  static double get screenWidth => _screenWidth;
  static double get screenHeight => _screenHeight;

  void init(BuildContext context) {
    _screenWidth = MediaQuery.of(context).size.width;
    _screenHeight = MediaQuery.of(context).size.height;
  }

  static double _getProportionateScreenWidth(double inputWidth) {
    return (inputWidth / 375.0) * _screenWidth;
  }

  static double _getProportionateScreenHeight(double inputHeight) {
    return (inputHeight / 812.0) * _screenHeight;
  }

}

extension SizeExtension on num {
  double get w => SizeConfig._getProportionateScreenWidth(toDouble());
  double get h => SizeConfig._getProportionateScreenHeight(toDouble());
}
