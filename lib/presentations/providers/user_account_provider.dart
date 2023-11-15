import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:recuerda_facil/features/auth/domain/entities/user_account.dart';
import 'package:recuerda_facil/services/user_services.dart';


final userProviderr = StreamProvider.family<UserAccount?, String>((ref, uid) {
  return getUserStream(uid);
});