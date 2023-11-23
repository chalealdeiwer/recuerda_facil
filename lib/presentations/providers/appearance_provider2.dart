import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:recuerda_facil/services/preferences_user.dart';

final preferencesProvider =
    StateNotifierProvider<AppearanceNotifier, AppearanceState>(
        (ref) => AppearanceNotifier());

class AppearanceNotifier extends StateNotifier<AppearanceState> {
  AppearanceNotifier() : super(AppearanceState()) {
    checkPreferences();
  }

  void checkPreferences() async {
    //is dark mode
    final isDarkmode = await PreferencesUser().getValue<bool>('isDarkmode');
    isDarkmode ?? false;
    state = state.copyWith(isDarkMode: isDarkmode);
    //customBackground
    final customBackground =
        await PreferencesUser().getValue<bool>('customBackground');
    customBackground ?? false;
    state = state.copyWith(customBackground: customBackground);
    //selectedColor
    final selectedColor =
        await PreferencesUser().getValue<int>('selectedColor');
    selectedColor ?? 0;
    state = state.copyWith(selectedColor: selectedColor);
    //bottomVisibility
    final bottomVisibility =
        await PreferencesUser().getValue<bool>('bottomVisibility');
    bottomVisibility ?? false;
    state = state.copyWith(bottomVisibility: bottomVisibility);
    //clockVisibility
    final clockVisibility =
        await PreferencesUser().getValue<bool>('clockVisibility');
    clockVisibility ?? true;
    state = state.copyWith(clockVisibility: clockVisibility);
    //categoriesVisibility
    final categoriesVisibility =
        await PreferencesUser().getValue<bool>('categoriesVisibility');
    categoriesVisibility ?? true;
    state = state.copyWith(categoriesVisibility: categoriesVisibility);
    //appBarVisibility
    final appBarVisibility =
        await PreferencesUser().getValue<bool>('appBarVisibility');
    appBarVisibility ?? false;
    state = state.copyWith(appBarVisibility: appBarVisibility);
    //buttonNewNoteVisibility
    final buttonNewNoteVisibility =
        await PreferencesUser().getValue<bool>('buttonNewNoteVisibility');
    buttonNewNoteVisibility ?? true;
    state = state.copyWith(buttonNewNoteVisibility: buttonNewNoteVisibility);
    //buttonActionVisibility
    final buttonActionVisibility =
        await PreferencesUser().getValue<bool>('buttonActionVisibility');
    buttonActionVisibility ?? false;
    state = state.copyWith(buttonActionVisibility: buttonActionVisibility);
    //buttonMicrophoneVisibility
    final buttonMicrophoneVisibility =
        await PreferencesUser().getValue<bool>('buttonMicrophoneVisibility');
    buttonMicrophoneVisibility ?? true;
    state = state.copyWith(buttonMicrophoneVisibility: buttonMicrophoneVisibility);
  }

  //dark mode
  void changeIsDarkMode(bool isDarkMode) {
    PreferencesUser().setValue<bool>('isDarkmode', isDarkMode);
    state = state.copyWith(isDarkMode: isDarkMode);
  }

  //customBackground
  void changeCustomBackground(bool customBackground) {
    PreferencesUser().setValue<bool>('customBackground', customBackground);
    state = state.copyWith(customBackground: customBackground);
  }

  //selectedColor
  void changeSelectedColor(int selectedColor) {
    PreferencesUser().setValue<int>('selectedColor', selectedColor);
    state = state.copyWith(selectedColor: selectedColor);
  }

  //bottomVisibility
  void changeBottomVisibility(bool bottomVisibility) {
    PreferencesUser().setValue<bool>('bottomVisibility', bottomVisibility);
    state = state.copyWith(bottomVisibility: bottomVisibility);
  }

  //clockVisibility
  void changeClockVisibility(bool clockVisibility) {
    PreferencesUser().setValue<bool>('clockVisibility', clockVisibility);
    state = state.copyWith(clockVisibility: clockVisibility);
  }

  //categoriesVisibility
  void changeCategoriesVisibility(bool categoriesVisibility) {
    PreferencesUser()
        .setValue<bool>('categoriesVisibility', categoriesVisibility);
    state = state.copyWith(categoriesVisibility: categoriesVisibility);
  }

  //appBarVisibility
  void changeAppBarVisibility(bool appBarVisibility) {
    PreferencesUser().setValue<bool>('appBarVisibility', appBarVisibility);
    state = state.copyWith(appBarVisibility: appBarVisibility);
  }

  //buttonNewNoteVisibility
  void changeButtonNewNoteVisibility(bool buttonNewNoteVisibility) {
    PreferencesUser()
        .setValue<bool>('buttonNewNoteVisibility', buttonNewNoteVisibility);
    state = state.copyWith(buttonNewNoteVisibility: buttonNewNoteVisibility);
  }

  //buttonActionVisibility
  void changeButtonActionVisibility(bool buttonActionVisibility) {
    PreferencesUser()
        .setValue<bool>('buttonActionVisibility', buttonActionVisibility);
    state = state.copyWith(buttonActionVisibility: buttonActionVisibility);
  }
  //buttonMicrophoneVisibility
  void changeButtonMicrophoneVisibility(bool buttonMicrophoneVisibility) {
    PreferencesUser()
        .setValue<bool>('buttonMicrophoneVisibility', buttonMicrophoneVisibility);
    state = state.copyWith(buttonMicrophoneVisibility: buttonMicrophoneVisibility);
  }

  void appearanceDefault() {
    changeIsDarkMode(false);
    changeCustomBackground(false);
    changeSelectedColor(0);
    changeBottomVisibility(false);
    changeClockVisibility(true);
    changeCategoriesVisibility(true);
    changeAppBarVisibility(false);
    changeButtonNewNoteVisibility(true);
    changeButtonActionVisibility(true);
    changeButtonMicrophoneVisibility(true);
  }

  void appearanceSimple() {
    changeBottomVisibility(false);
    changeClockVisibility(false);
    changeCategoriesVisibility(false);
    changeAppBarVisibility(false);
    changeButtonNewNoteVisibility(true);
    changeButtonActionVisibility(true);
    changeButtonMicrophoneVisibility(true);

  }

  void appearanceReduced() {
    changeBottomVisibility(false);
    changeClockVisibility(true);
    changeCategoriesVisibility(true);
    changeAppBarVisibility(false);
    changeButtonNewNoteVisibility(true);
    changeButtonActionVisibility(true);
    changeButtonMicrophoneVisibility(true);

  }

  void appearanceComplete() {
    
    changeBottomVisibility(true);
    changeClockVisibility(true);
    changeCategoriesVisibility(true);
    changeAppBarVisibility(true);
    changeButtonNewNoteVisibility(true);
    changeButtonActionVisibility(false);
    changeButtonMicrophoneVisibility(true);

  }
}

class AppearanceState {
  //appearance colors
  final bool isDarkMode;
  final bool customBackground;
  final int selectedColor;
  //appearance buttons
  final bool bottomVisibility;
  final bool clockVisibility;
  final bool categoriesVisibility;
  final bool appBarVisibility;
  final bool buttonNewNoteVisibility;
  final bool buttonActionVisibility;
  final bool buttonMicrophoneVisibility;

  AppearanceState({
    this.isDarkMode = false,
    this.customBackground = false,
    this.selectedColor = 0,
    this.bottomVisibility = false,
    this.clockVisibility = true,
    this.categoriesVisibility = true,
    this.appBarVisibility = false,
    this.buttonNewNoteVisibility = true,
    this.buttonActionVisibility = false,
    this.buttonMicrophoneVisibility = true,
  });

  AppearanceState copyWith({
    bool? isDarkMode,
    bool? customBackground,
    int? selectedColor,
    bool? bottomVisibility,
    bool? clockVisibility,
    bool? categoriesVisibility,
    bool? appBarVisibility,
    bool? buttonNewNoteVisibility,
    bool? buttonActionVisibility,
    bool? buttonMicrophoneVisibility,
  }) =>
      AppearanceState(
        isDarkMode: isDarkMode ?? this.isDarkMode,
        customBackground: customBackground ?? this.customBackground,
        selectedColor: selectedColor ?? this.selectedColor,
        bottomVisibility: bottomVisibility ?? this.bottomVisibility,
        clockVisibility: clockVisibility ?? this.clockVisibility,
        categoriesVisibility: categoriesVisibility ?? this.categoriesVisibility,
        appBarVisibility: appBarVisibility ?? this.appBarVisibility,
        buttonNewNoteVisibility:
            buttonNewNoteVisibility ?? this.buttonNewNoteVisibility,
        buttonActionVisibility:
            buttonActionVisibility ?? this.buttonActionVisibility,
        buttonMicrophoneVisibility: buttonMicrophoneVisibility?? this.buttonMicrophoneVisibility,
      );
}
