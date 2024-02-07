abstract class BaseHobbyRepository {
  Future<void> addHobby(String userId, String hobby);
  Future<List<String>> getHobbies(String userId);
}
