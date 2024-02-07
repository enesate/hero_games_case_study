import 'package:hero_games_case_study/src/features/auth/domain/user_model.dart';

abstract class BaseAuthRepository {
  Future<void> signInWithEmailAndPassword(String email, String password);
  Future<void> registerWithEmailAndPassword(
      String name, String email, String password, String birthDate, String bio);
  Future<UserModel> getUserInformation();
}
