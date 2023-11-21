import 'package:recuerda_facil/features/auth/domain/domain.dart';

import '../../domain/entities/user_account.dart';
import '../datasources/auth_datasource_impl.dart';

class AuthRepositoryImpl extends AuthRepository{

  final AuthDataSource dataSource;

  AuthRepositoryImpl({AuthDataSource? dataSource}):dataSource = dataSource?? AuthDataSourceImpl();
  @override
  Future<UserAccount> checkAuthStatus() {
    return dataSource.checkAuthStatus();
  }

  @override
  Future<UserAccount> login(String email, String password) {
    return dataSource.login(email, password);
  }

  @override
  Future<UserAccount> register(String email, String password) {
    return dataSource.register(email, password);
  }
  
  @override
  Future<UserAccount> loginWithGoogle() {
    return dataSource.loginWithGoogle();
  }
  
  @override
  Future<UserAccount> createUserDefault() {
    return dataSource.createUserDefault();
  }
  
  @override
  Future<UserAccount> createUser(UserAccount user) {
    return dataSource.createUser(user);
  }

}