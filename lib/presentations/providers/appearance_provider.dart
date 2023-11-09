import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../services/services.dart';

final bottomVisibilityProviderAsync = FutureProvider<bool>((ref) async {
  final bottomVisibility = await PreferencesUser().getValue<bool>('bottomVisibility');
  return bottomVisibility ?? true;
});

final bottomVisibilityProvider = StateProvider<bool>((ref) {
  final asyncValue = ref.watch(bottomVisibilityProviderAsync);
  if (asyncValue is AsyncData<bool>) {
    return asyncValue.value;
  } else {
    return true;
  }
});

final clockVisibilityProviderAsync = FutureProvider<bool>((ref) async {
  final clockVisibility = await PreferencesUser().getValue<bool>('clockVisibility');
  return clockVisibility ?? true;
});

final clockVisibilityProvider = StateProvider<bool>((ref) {
  final asyncValue = ref.watch(clockVisibilityProviderAsync);
  if (asyncValue is AsyncData<bool>) {
    return asyncValue.value;
  } else {
    return true;
  }
});


final categoriesVisibilityProviderAsync = FutureProvider<bool>((ref) async {
  final categoriesVisibility = await PreferencesUser().getValue<bool>('categoriesVisibility');
  return categoriesVisibility ?? true;
});

final categoriesVisibilityProvider = StateProvider<bool>((ref) {
  final asyncValue = ref.watch(categoriesVisibilityProviderAsync);
  if (asyncValue is AsyncData<bool>) {
    return asyncValue.value;
  } else {
    return true;
  }
});

final appBarVisibilityProviderAsync = FutureProvider<bool>((ref) async {
  final appBarVisibility = await PreferencesUser().getValue<bool>('appBarVisibility');
  return appBarVisibility ?? true;
});

final appBarVisibilityProvider = StateProvider<bool>((ref) {
  final asyncValue = ref.watch(appBarVisibilityProviderAsync);
  if (asyncValue is AsyncData<bool>) {
    return asyncValue.value;
  } else {
    return true;
  }
});

final buttonNewNoteVisibilityProviderAsync = FutureProvider<bool>((ref) async {
  final buttonNewNoteVisibility = await PreferencesUser().getValue<bool>('buttonNewNoteVisibility');
  return buttonNewNoteVisibility ?? true;
});

final buttonNewNoteVisibilityProvider = StateProvider<bool>((ref) {
  final asyncValue = ref.watch(buttonNewNoteVisibilityProviderAsync);
  if (asyncValue is AsyncData<bool>) {
    return asyncValue.value;
  } else {
    return true;
  }
});

final buttonActionVisibilityProviderAsync = FutureProvider<bool>((ref) async {
  final buttonActionVisibility = await PreferencesUser().getValue<bool>('buttonActionVisibility');
  return buttonActionVisibility ?? false; // El valor predeterminado se establece en 'false'
});

final buttonActionVisibilityProvider = StateProvider<bool>((ref) {
  final asyncValue = ref.watch(buttonActionVisibilityProviderAsync);
  if (asyncValue is AsyncData<bool>) {
    return asyncValue.value;
  } else {
    return false; // El valor predeterminado se establece en 'false'
  }
});

final buttonMicrophoneVisibilityProviderAsync = FutureProvider<bool>((ref) async {
  final buttonMicrophoneVisibility = await PreferencesUser().getValue<bool>('buttonMicrophoneVisibility');
  return buttonMicrophoneVisibility ?? true; // El valor predeterminado se establece en 'true'
});

final buttonMicrophoneVisibilityProvider = StateProvider<bool>((ref) {
  final asyncValue = ref.watch(buttonMicrophoneVisibilityProviderAsync);
  if (asyncValue is AsyncData<bool>) {
    return asyncValue.value;
  } else {
    return true; // El valor predeterminado se establece en 'true'
  }
});

final openMenuProviderAsync = FutureProvider<bool>((ref) async {
  final openMenu = await PreferencesUser().getValue<bool>('openMenu');
  return openMenu ?? false; // El valor predeterminado se establece en 'false'
});

final openMenuProvider = StateProvider<bool>((ref) {
  final asyncValue = ref.watch(openMenuProviderAsync);
  if (asyncValue is AsyncData<bool>) {
    return asyncValue.value;
  } else {
    return false; // El valor predeterminado se establece en 'false'
  }
});

final buttonPageChangeProviderAsync = FutureProvider<bool>((ref) async {
  final buttonPageChange = await PreferencesUser().getValue<bool>('buttonPageChange');
  return buttonPageChange ?? true; // El valor predeterminado se establece en 'true'
});

final buttonPageChangeProvider = StateProvider<bool>((ref) {
  final asyncValue = ref.watch(buttonPageChangeProviderAsync);
  if (asyncValue is AsyncData<bool>) {
    return asyncValue.value;
  } else {
    return true; // El valor predeterminado se establece en 'true'
  }
});




