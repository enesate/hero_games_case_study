import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:hero_games_case_study/src/features/auth/domain/base_auth_repository.dart';
import 'package:hero_games_case_study/src/features/auth/domain/user_model.dart';

class AuthRepository implements BaseAuthRepository {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  @override
  Future<void> signInWithEmailAndPassword(String email, String password) async {
    try {
      await _auth.signInWithEmailAndPassword(email: email, password: password);
    } catch (e) {
      throw Exception('Error signing in: $e');
    }
  }

  @override
  Future<void> registerWithEmailAndPassword(String name, String email,
      String password, String birthDate, String bio) async {
    try {
      await _auth.createUserWithEmailAndPassword(
          email: email, password: password);

      // Firestore'a kullanıcı bilgilerini kaydet
      await _firestore.collection('users').doc(_auth.currentUser!.uid).set({
        'name': name,
        'email': email,
        'birthDate': birthDate,
        'bio': bio,
        'hobbies': [],
      });
    } catch (e) {
      throw Exception('Error registering user: $e');
    }
  }

  @override
  Future<UserModel> getUserInformation() async {
    try {
      final user = _auth.currentUser;
      final userData =
          await _firestore.collection('users').doc(user!.uid).get();

      return UserModel(
        name: userData['name'],
        email: userData['email'],
        birthDate: userData['birthDate'],
        bio: userData['bio'],
      );
    } catch (e) {
      throw Exception('Error getting user information: $e');
    }
  }
}
