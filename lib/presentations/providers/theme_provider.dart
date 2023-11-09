
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:recuerda_facil/config/theme/app_theme.dart';
import 'package:recuerda_facil/services/preferences_user.dart';
import 'package:shared_preferences/shared_preferences.dart';

final isDarkmodeProviderAsync = FutureProvider<bool>((ref) async {
  final isDarkmode = await PreferencesUser().getValue<bool>('isDarkmode');
  return isDarkmode ?? false; // El valor predeterminado se establece en 'false'
});

final isDarkmodeProvider = StateProvider<bool>((ref) {
  final asyncValue = ref.watch(isDarkmodeProviderAsync);
  if (asyncValue is AsyncData<bool>) {
    return asyncValue.value;
  } else {
    return false; // El valor predeterminado se establece en 'false'
  }
});

final customBackgroundAsync = FutureProvider<bool>((ref) async {
  final customBackground = await PreferencesUser().getValue<bool>('customBackground');
  return customBackground ?? false; // El valor predeterminado se establece en 'false'
});

final customBackground = StateProvider<bool>((ref) {
  final asyncValue = ref.watch(customBackgroundAsync);
  if (asyncValue is AsyncData<bool>) {
    return asyncValue.value;
  } else {
    return false; // El valor predeterminado se establece en 'false'
  }
});
//Listado de colores inmutable
final selectedColorProviderAsync = FutureProvider<int>((ref) async {
  final prefs = await SharedPreferences.getInstance();
  final selectedColor = prefs.getInt('selectedColor') ?? 0; // Valor predeterminado
  return selectedColor;
});

final selectedColorProvider = StateProvider<int>((ref) {
  final asyncValue = ref.watch(selectedColorProviderAsync);
  if (asyncValue is AsyncData<int>) {
    return asyncValue.value;
  } else {
    return 0; // Valor predeterminado
  }
});

final colorListProvider= Provider((ref) => colorList);

final opacityProvider = StateNotifierProvider<OpacityNotifier, double>((ref) {
  return OpacityNotifier();
});

//un objeto de tipo AppTheme(custom)
final themeNotifierProvider = StateNotifierProvider<ThemeNotifier,AppTheme>((ref) => ThemeNotifier(selectedColor: ref.watch(selectedColorProvider), isDarkMode: ref.watch(isDarkmodeProvider)));

class ThemeNotifier extends StateNotifier<AppTheme> {
  final int selectedColor;
  final bool isDarkMode;
  
  //State= estado = new appTheme
  ThemeNotifier({required this.selectedColor, required this.isDarkMode}) : super(AppTheme(selectedColor: selectedColor, isDarkMode: isDarkMode));
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