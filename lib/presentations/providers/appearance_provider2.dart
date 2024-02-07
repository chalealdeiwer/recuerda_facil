import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
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
    //opacity
    final opacity = await PreferencesUser().getValue<double>('opacity');
    opacity ?? 0.5;
    state = state.copyWith(opacity: opacity);
    //backgroundImage

    final appDocumentsDirectory = await getApplicationDocumentsDirectory();
    const fileName = "custom_background.png";
    final filePath = "${appDocumentsDirectory.path}/$fileName";

    if (await File(filePath).exists()) {
      final Image background = Image.file(File(filePath));
      state = state.copyWith(background: background);
    } else {
      final ByteData data =
          await rootBundle.load("assets/backgrounds/background_5.jpg");
      final Uint8List bytes = data.buffer.asUint8List();
      final Image background = Image.memory(bytes);
      state = state.copyWith(background: background);
    }

    //selectedColor
    final selectedColor =
        await PreferencesUser().getValue<int>('selectedColor');
    selectedColor ?? 0;
    state = state.copyWith(selectedColor: selectedColor);
    //bottomVisibility
    final bottomVisibility =
        await PreferencesUser().getValue<bool>('bottomVisibility');
    bottomVisibility ?? true;
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
    state =
        state.copyWith(buttonMicrophoneVisibility: buttonMicrophoneVisibility);
    //buttonPageChange
    final buttonPageChange =
        await PreferencesUser().getValue<bool>('buttonPageChange');
    buttonPageChange ?? true;
    state = state.copyWith(buttonPageChange: buttonPageChange);
    //openMenu
    final openMenu = await PreferencesUser().getValue<bool>('openMenu');
    openMenu ?? false;
    state = state.copyWith(openMenu: openMenu);
    //notification
    final notification = await PreferencesUser().getValue<bool>('notification');
    notification ?? false;
    state = state.copyWith(notification: notification);
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

  //opacity
  void changeOpacity(double opacity) {
    PreferencesUser().setValue<double>('opacity', opacity);
    state = state.copyWith(opacity: opacity);
  }

  void changeBackground(XFile pickedImage) async {
    // final ImagePicker imagePicker = ImagePicker();
    // final XFile? pickedImage =
    //     await imagePicker.pickImage(source: ImageSource.gallery);

    // if (pickedImage != null) {
    final appDocumentsDirectory = await getApplicationDocumentsDirectory();
    const fileName = "custom_background.png";
    final filePath = "${appDocumentsDirectory.path}/$fileName";

    await pickedImage.saveTo(filePath);
    // final Image image = Image.file(File(filePath),
    //     key: UniqueKey());
    // changeBackground2(image);

    // } else {
    //   final ByteData data =
    //       await rootBundle.load("assets/backgrounds/background_5.jpg");
    //   final Uint8List bytes = data.buffer.asUint8List();
    //   final background = Image.memory(bytes,
    //       key: UniqueKey()); // Añade una clave única al widget Image
    //   changeBackground2(background);
    // }
  }

  void changeBackground2(Image image) {
    state = state.copyWith(background: image);
  }

  void changeBackgroundDefault() async {
    final appDocumentsDirectory = await getApplicationDocumentsDirectory();
    const fileName = "custom_background.png";
    final filePath = "${appDocumentsDirectory.path}/$fileName";

    if (await File(filePath).exists()) {
      await File(filePath).delete();
    } else {
    }
    final ByteData data =
        await rootBundle.load("assets/backgrounds/background_5.jpg");
    final Uint8List bytes = data.buffer.asUint8List();
    final background = Image.memory(bytes,
        key: UniqueKey()); 
    state = state.copyWith(background: background);
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
    PreferencesUser().setValue<bool>(
        'buttonMicrophoneVisibility', buttonMicrophoneVisibility);
    state =
        state.copyWith(buttonMicrophoneVisibility: buttonMicrophoneVisibility);
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
  //notification
  void changeNotification(bool notification) {
    PreferencesUser().setValue<bool>('notification', notification);
    if(notification == false){
      //cancelar notificaciones
      
    }

    
    state = state.copyWith(notification: notification);
  }

  void appearanceDefault() {
    changeIsDarkMode(false);
    changeCustomBackground(false);
    changeSelectedColor(0);
    changeBottomVisibility(true);
    changeClockVisibility(true);
    changeCategoriesVisibility(true);
    changeAppBarVisibility(true);
    changeButtonNewNoteVisibility(true);
    changeButtonActionVisibility(false);
    changeButtonMicrophoneVisibility(true);
    changeButtonPageChange(true);
    changeOpacity(0.5);
    changeBackgroundDefault();
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
    changeOpacity(0.5);
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
    changeOpacity(0.5);
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
    changeOpacity(0.5);
  }
}

class AppearanceState {
  //appearance colors
  final bool isDarkMode;
  final bool customBackground;
  final double opacity;
  final Image background;
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
  final bool openMenu;
  final bool buttonPageChange;
  final bool notification;

  

  AppearanceState({
    this.isDarkMode = false,
    this.customBackground = false,
    this.opacity = 0.5,
    this.background =
        const Image(image: AssetImage("assets/backgrounds/background_5.jpg")),
    this.selectedColor = 0,
    this.bottomVisibility = true,
    this.clockVisibility = true,
    this.categoriesVisibility = true,
    this.appBarVisibility = true,
    this.buttonNewNoteVisibility = true,
    this.buttonActionVisibility = false,
    this.buttonMicrophoneVisibility = true,
    this.buttonPageChange = true,
    this.openMenu = false,
    this.notification = false,
  });

  AppearanceState copyWith({
    bool? isDarkMode,
    bool? customBackground,
    double? opacity,
    Image? background,
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
    bool? notification,
  }) =>
      AppearanceState(
        isDarkMode: isDarkMode ?? this.isDarkMode,
        customBackground: customBackground ?? this.customBackground,
        opacity: opacity ?? this.opacity,
        background: background ?? this.background,
        selectedColor: selectedColor ?? this.selectedColor,
        bottomVisibility: bottomVisibility ?? this.bottomVisibility,
        clockVisibility: clockVisibility ?? this.clockVisibility,
        categoriesVisibility: categoriesVisibility ?? this.categoriesVisibility,
        appBarVisibility: appBarVisibility ?? this.appBarVisibility,
        buttonNewNoteVisibility:
            buttonNewNoteVisibility ?? this.buttonNewNoteVisibility,
        buttonActionVisibility:
            buttonActionVisibility ?? this.buttonActionVisibility,
        buttonMicrophoneVisibility:
            buttonMicrophoneVisibility ?? this.buttonMicrophoneVisibility,
        buttonPageChange: buttonPageChange ?? this.buttonPageChange,
        openMenu: openMenu ?? this.openMenu,
        notification: notification ?? this.notification,
      );
}
