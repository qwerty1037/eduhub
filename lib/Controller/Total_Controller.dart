import 'package:fluent_ui/fluent_ui.dart';

import 'package:get/get.dart';

///전역변수처럼 사용되는 변수들을 모아두는 컨트롤러
class TotalController extends GetxController {
  bool isLoginSuccess = false;

  Color? mainColor;
  AccentColor activeColor = Colors.blue;

  bool isDark = false;

//  Iterable<ThemeExtension<dynamic>>? extensions,
//     Brightness? brightness,
//     VisualDensity? visualDensity,
//     Typography? typography,
//     String? fontFamily,
//     AccentColor? accentColor,
//     Color? activeColor,
//     Color? inactiveColor,
//     Color? inactiveBackgroundColor,
//     Color? scaffoldBackgroundColor,
//     Color? acrylicBackgroundColor,
//     Color? micaBackgroundColor,
//     Color? shadowColor,
//     Color? menuColor,
//     Color? cardColor,

//     ButtonThemeData? buttonTheme,
//     CheckboxThemeData? checkboxTheme,
//     ChipThemeData? chipTheme,
//     ToggleSwitchThemeData? toggleSwitchTheme,
//     IconThemeData? iconTheme,
//     NavigationPaneThemeData? navigationPaneTheme,
//     RadioButtonThemeData? radioButtonTheme,
//     ToggleButtonThemeData? toggleButtonTheme,
//     SliderThemeData? sliderTheme,
//     InfoBarThemeData? infoBarTheme,

  ///isLoginSuccess 값을 뒤집는 함수
  void reverseLoginState() {
    isLoginSuccess = !isLoginSuccess;
    update();
  }
}
