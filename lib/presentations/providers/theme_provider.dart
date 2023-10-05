import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:recuerda_facil/config/theme/app_theme.dart';

final isDarkmodeProvider = StateProvider((ref) => false);
final customBackground= StateProvider((ref) => false);
//Listado de colores inmutable


final colorListProvider= Provider((ref) => colorList);
final opacityProvider = StateNotifierProvider<OpacityNotifier, double>((ref) {
  return OpacityNotifier();
});

//un simple entero
final selectedIndexColorProvider= StateProvider((ref) => 0);
//un objeto de tipo AppTheme(custom)
final themeNotifierProvider = StateNotifierProvider<ThemeNotifier,AppTheme>((ref) => ThemeNotifier());
class ThemeNotifier extends StateNotifier<AppTheme> {
  //State= estado = new appTheme
  ThemeNotifier() : super(AppTheme());
  void updateTheme(AppTheme theme) {
    state = theme;
  }
  void toogleDarkMode(){
    state= state.copyWith(isDarkMode: !state.isDarkMode);
  }
  void changeColorIndex(int colorIndex){
    state= state.copyWith(selectedColor: colorIndex);
  }
}
class OpacityNotifier extends StateNotifier<double> {
  OpacityNotifier() : super(0.5);  // Inicializa con opacidad completa

  void updateOpacity(double value) {
    state = value;
  }
}