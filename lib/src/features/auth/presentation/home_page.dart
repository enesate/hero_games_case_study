import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:hero_games_case_study/src/features/auth/data/auth_repository.dart';
import 'package:hero_games_case_study/src/features/auth/data/hobby_repository.dart';
import 'package:hero_games_case_study/src/features/auth/domain/user_model.dart';
import 'package:hero_games_case_study/src/features/auth/presentation/login_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final AuthRepository authRepository = AuthRepository();
  final HobbyRepository hobbyRepository = HobbyRepository();
  final TextEditingController hobbyController = TextEditingController();
  UserModel? userInfo;
  List<String> hobbies = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _getUserInfo();
    _getHobbies();
  }

  @override
  void dispose() {
    _signOut();
    super.dispose();
  }

  Future<void> _getUserInfo() async {
    try {
      final user = await authRepository.getUserInformation();
      setState(() {
        userInfo = user;
        isLoading =
            false; // Kullanıcı bilgileri başarıyla yüklendiğinde isLoading durumunu false yapın
      });
    } catch (e) {
      // Handle error
      print('Error getting user information: $e');
      setState(() {
        isLoading = false; // Hata oluştuğunda isLoading durumunu false yapın
      });
    }
  }

  Future<void> _getHobbies() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      final result = await hobbyRepository.getHobbies(user.uid);
      setState(() {
        if (result.isEmpty) {
          hobbies = [];
        } else {
          hobbies = result;
        }
      });
    }
  }

  Future<void> _addHobby() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      await hobbyRepository.addHobby(user.uid, hobbyController.text);
      _getHobbies();
      hobbyController.clear();
    }
  }

  Future<void> _signOut() async {
    await FirebaseAuth.instance.signOut().then((value) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => const LoginPage(),
        ),
      );
    });
    // Çıkış yapıldıktan sonra başka bir sayfaya yönlendirme yapılabilir
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Home'),
        actions: <Widget>[
          IconButton(
            icon: const Icon(Icons.exit_to_app),
            onPressed: _signOut,
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: isLoading
            ? const Center(
                child: CircularProgressIndicator(),
              )
            : Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Card(
                    elevation: 4, // Card'ın gölge miktarı
                    child: Padding(
                      padding: const EdgeInsets.all(16.0), // İç boşluğu artırın
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Name: ${userInfo!.name}',
                            style: const TextStyle(
                              fontSize: 18, // Yazı boyutunu ayarlayın
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text(
                            'Email: ${userInfo?.email}',
                            style: const TextStyle(
                              fontSize: 18, // Yazı boyutunu ayarlayın
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text(
                            'Birth Date: ${userInfo?.birthDate}',
                            style: const TextStyle(
                              fontSize: 18, // Yazı boyutunu ayarlayın
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text(
                            'Bio: ${userInfo?.bio}',
                            style: const TextStyle(
                              fontSize: 18, // Yazı boyutunu ayarlayın
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  Row(
                    children: [
                      Expanded(
                        child: TextFormField(
                          controller: hobbyController,
                          decoration: const InputDecoration(
                              border: OutlineInputBorder(),
                              labelText: 'Add Hobby'),
                        ),
                      ),
                      const SizedBox(width: 10),
                      ElevatedButton(
                        onPressed: _addHobby,
                        child: const Text('Add'),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  const Text('Hobbies:',
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                  Expanded(
                    child: ListView.builder(
                      itemCount: hobbies.length,
                      itemBuilder: (context, index) {
                        return Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Container(
                              decoration: BoxDecoration(
                                border: Border.all(
                                  color: Colors.grey, // Border rengi
                                  width: 2.0, // Border kalınlığı
                                ),
                                borderRadius: BorderRadius.circular(
                                    10.0), // Container'ın köşe yarıçapı
                              ),
                              child: ListTile(title: Text(hobbies[index]))),
                        );
                      },
                    ),
                  ),
                ],
              ),
      ),
    );
  }
}
