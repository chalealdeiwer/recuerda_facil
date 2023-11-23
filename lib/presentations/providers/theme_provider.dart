
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:recuerda_facil/config/theme/app_theme.dart';
import 'package:recuerda_facil/presentations/providers/appearance_provider2.dart';




final colorListProvider= Provider((ref) => colorList);

final opacityProvider = StateNotifierProvider<OpacityNotifier, double>((ref) {
  return OpacityNotifier();
});

//un objeto de tipo AppTheme(custom)
final themeNotifierProvider = StateNotifierProvider<ThemeNotifier,AppTheme>((ref) => 
ThemeNotifier(selectedColor: ref.watch(preferencesProvider).selectedColor, isDarkMode: ref.watch(preferencesProvider).isDarkMode));

class ThemeNotifier extends StateNotifier<AppTheme> {
  final int selectedColor;
  final bool isDarkMode;
  
  //State= estado = new appTheme
  ThemeNotifier({required this.selectedColor, required this.isDarkMode}) : super(AppTheme(selectedColor: selectedColor, isDarkMode: isDarkMode));
  void updateTheme(AppTheme theme) {
    state = theme;
  }
  // void toogleDarkMode(){
  //   state= state.copyWith(isDarkMode: !state.isDarkMode);
  // }
  // void changeColorIndex(int colorIndex){
  //   state= state.copyWith(selectedColor: colorIndex);
  // }
}
class OpacityNotifier extends StateNotifier<double> {
  OpacityNotifier() : super(0.5);  // Inicializa con opacidad completa

  void updateOpacity(double value) {
    state = value;
  }
}