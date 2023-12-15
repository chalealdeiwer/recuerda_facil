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
    appBarVisibility ?? true;
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
    //buttonPageChange
    final buttonPageChange =
        await PreferencesUser().getValue<bool>('buttonPageChange');
    buttonPageChange ?? true;
    state = state.copyWith(buttonPageChange: buttonPageChange);
    //openMenu
    final openMenu = await PreferencesUser().getValue<bool>('openMenu');
    openMenu ?? false;
    state = state.copyWith(openMenu: openMenu);
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
  //buttonPageChange
  void changeButtonPageChange(bool buttonPageChange) {
    PreferencesUser().setValue<bool>('buttonPageChange', buttonPageChange);
    state = state.copyWith(buttonPageChange: buttonPageChange);
  }
  //openMenu
  void changeOpenMenu(bool openMenu) {
    PreferencesUser().setValue<bool>('openMenu', openMenu);
    state = state.copyWith(openMenu: openMenu);
  }

  void appearanceDefault() {
    changeIsDarkMode(false);
    changeCustomBackground(false);
    changeSelectedColor(0);
    changeBottomVisibility(false);
    changeClockVisibility(true);
    changeCategoriesVisibility(true);
    changeAppBarVisibility(true);
    changeButtonNewNoteVisibility(true);
    changeButtonActionVisibility(false);
    changeButtonMicrophoneVisibility(true);
    changeButtonPageChange(true);
  }

  void appearanceSimple() {
    changeBottomVisibility(false);
    changeClockVisibility(false);
    changeCategoriesVisibility(false);
    changeAppBarVisibility(false);
    changeButtonNewNoteVisibility(true);
    changeButtonActionVisibility(true);
    changeButtonMicrophoneVisibility(true);
    changeButtonPageChange(true);


  }

  void appearanceReduced() {
    changeBottomVisibility(false);
    changeClockVisibility(true);
    changeCategoriesVisibility(true);
    changeAppBarVisibility(true);
    changeButtonNewNoteVisibility(true);
    changeButtonActionVisibility(false);
    changeButtonMicrophoneVisibility(true);
    changeButtonPageChange(true);


  }

  void appearanceComplete() {
    
    changeBottomVisibility(true);
    changeClockVisibility(true);
    changeCategoriesVisibility(true);
    changeAppBarVisibility(true);
    changeButtonNewNoteVisibility(true);
    changeButtonActionVisibility(false);
    changeButtonMicrophoneVisibility(true);
    changeButtonPageChange(true);


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
  //button de pagina
  final bool  openMenu;
  final bool buttonPageChange;

  AppearanceState({
    this.isDarkMode = false,
    this.customBackground = false,
    this.selectedColor = 0,
    this.bottomVisibility = false,
    this.clockVisibility = true,
    this.categoriesVisibility = true,
    this.appBarVisibility = true,
    this.buttonNewNoteVisibility = true,
    this.buttonActionVisibility = false,
    this.buttonMicrophoneVisibility = true,
    this.buttonPageChange = true,
    this.openMenu = false,
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
    bool? buttonPageChange,
    bool? openMenu,
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
        buttonPageChange: buttonPageChange ?? this.buttonPageChange,
        openMenu: openMenu ?? this.openMenu,
      );
}
