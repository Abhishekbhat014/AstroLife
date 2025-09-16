import 'package:flutter/material.dart';
import 'package:astro_life/utils/session_manager.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0;

  void _onItemTapped(int index) {
    setState(() => _selectedIndex = index);
    switch (_selectedIndex) {
      case 1:
        setState(() {});
        break;
      case 2:
        
        break;
      case 3:
        // AddKundaliScreen();
        break;
      case 4:
        // ProfileScreen();
        break;
      default:
        HomeScreen();
    }
  }

  @override
  Widget build(BuildContext context) {
    final user = SessionManager.currentUser;

    return Scaffold(
      appBar: AppBar(title: const Text("AstroLife")),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Hi ${user?.firstName ?? "User"}, How can I help you today?",
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 24),

            // 🔮 Astrology Info Container
            GestureDetector(
              onTap: () {
                // TODO: Navigate to InfoPage
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text("Navigate to Astrology Info Page"),
                  ),
                );
              },
              child: Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.deepPurple.shade50,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.deepPurple.shade200),
                ),
                child: Row(
                  children: const [
                    Icon(Icons.auto_awesome, color: Colors.deepPurple),
                    SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        "Learn about Astrology basics, planets, and predictions.",
                        style: TextStyle(fontSize: 16),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),

      // ✅ Bottom Navigation
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
        selectedItemColor: Colors.deepPurple,
        unselectedItemColor: Colors.grey,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: "Home"),
          BottomNavigationBarItem(
            icon: Icon(Icons.star_border_purple500),
            label: "Features",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.file_copy_rounded),
            label: "Add Kundali",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person_off_outlined),
            label: "profile",
          ),
        ],
      ),
    );
  }
}
