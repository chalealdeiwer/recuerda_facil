import 'package:flutter_riverpod/flutter_riverpod.dart';

final categoryProvider = StateProvider<String>((ref) => 'Sin Categoría');
final indexCategoryProvider = StateProvider<int>((ref) => 0);
