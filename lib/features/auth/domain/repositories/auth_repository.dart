import 'package:recuerda_facil/models/models.dart';


abstract class AuthRepository{

  Future<UserAccount> login(String email, String password);
  Future<UserAccount> register(String email, String password);
  Future<UserAccount> checkAuthStatus();
  Future<UserAccount>loginWithGoogle();
}