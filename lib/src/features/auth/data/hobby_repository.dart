import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:hero_games_case_study/src/features/auth/domain/base_hobby_repository.dart';

class HobbyRepository implements BaseHobbyRepository {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  @override
  Future<void> addHobby(String userId, String hobby) async {
    try {
      await _firestore.collection('users').doc(userId).update({
        'hobbies': FieldValue.arrayUnion([hobby]),
      });
    } catch (e) {
      throw Exception('Error adding hobby: $e');
    }
  }

  @override
  Future<List<String>> getHobbies(String userId) async {
    try {
      final documentSnapshot =
          await _firestore.collection('users').doc(userId).get();
      final userData = documentSnapshot.data() as Map<String, dynamic>;
      if (userData.containsKey('hobbies')) {
        return List<String>.from(userData['hobbies']);
      } else {
        return [];
      }
    } catch (e) {
      throw Exception('Error getting hobbies: $e');
    }
  }
}
