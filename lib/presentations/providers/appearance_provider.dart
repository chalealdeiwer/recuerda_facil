import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../services/services.dart';


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




