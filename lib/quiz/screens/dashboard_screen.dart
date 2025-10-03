// lib/screens/dashboard_screen.dart
import 'package:flutter/material.dart';
import '../data/leaderboard_data.dart';
import '../data/quiz_data.dart';
import '../models/quiz_model.dart';
import '../widgets/quiz_card.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  int _bottomNavIndex = 4;
  final Set<String> _completedQuizzes = {};
  int _selectedTabIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      body: Stack(
        children: [
          // <<< WIDGET 1: BACKGROUND IMAGE >>>
          Container(
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage("assets/quiz.png"), // Your image path
                fit: BoxFit.cover, // Make the image cover the entire screen
              ),
            ),
          ),

          // <<< WIDGET 2: FOREGROUND CONTENT >>>
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Column(
                children: [
                  const SizedBox(height: 70),
                  _buildProfileHeader(),
                  const SizedBox(height: 20),
                  _buildTabBar(),
                  const SizedBox(height: 20),
                  Expanded(
                    child: IndexedStack(
                      index: _selectedTabIndex,
                      children: [
                        _buildQuizListView(),
                        _buildBadgesView(),
                        _buildLeaderboardView(),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
      bottomNavigationBar: _buildBottomNavigationBar(),
    );
  }

  Widget _buildQuizListView() {
    return ListView.builder(
      padding: const EdgeInsets.only(top: 4),
      itemCount: quizzes.length,
      itemBuilder: (context, index) {
        final quiz = quizzes[index];
        final isLocked =
            quiz.prerequisiteQuizId != null &&
            !_completedQuizzes.contains(quiz.prerequisiteQuizId);

        return QuizCard(
          quiz: quiz,
          isLocked: isLocked,
          onTap: () {
            print("${quiz.title} button was tapped!");
          },
        );
      },
    );
  }

  // --- THE REST OF THE FILE IS EXACTLY THE SAME ---

  Widget _buildBadgesView() {
    return SingleChildScrollView(
      child: Column(
        children: [
          _buildSectionCard(
            title: 'Your Badges',
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildBadgeChip('SAR Explorer', Icons.satellite_alt),
                _buildBadgeChip('Quick Learner', Icons.flash_on),
              ],
            ),
          ),
          const SizedBox(height: 16),
          _buildSectionCard(
            title: 'Learning Progress',
            child: Column(
              children: [
                _buildProgressRow('SAR Basics', 0.50),
                _buildProgressRow('Disaster Detection', 0.40),
                _buildProgressRow('Earth Monitoring', 0.25),
              ],
            ),
          ),
          const SizedBox(height: 16),
          _buildSectionCard(
            title: 'Statistics',
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildStatItem('0', 'Quizzes Completed'),
                _buildStatItem('5', 'Day Streak'),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLeaderboardView() {
    return ListView.builder(
      itemCount: leaderboardData.length,
      itemBuilder: (context, index) {
        final user = leaderboardData[index];
        return Card(
          color: user.isCurrentUser ? Colors.blue.shade50 : Colors.white,
          margin: const EdgeInsets.only(bottom: 12),
          child: Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 12.0,
              vertical: 16.0,
            ),
            child: Row(
              children: [
                CircleAvatar(
                  backgroundColor: user.isCurrentUser
                      ? Colors.blue.shade700
                      : Colors.grey.shade300,
                  child: Text(
                    user.rank.toString(),
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: user.isCurrentUser ? Colors.white : Colors.black87,
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Flexible(
                            child: Text(
                              user.name,
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                              ),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          if (user.isCurrentUser)
                            Padding(
                              padding: const EdgeInsets.only(left: 8.0),
                              child: Chip(
                                label: const Text(
                                  'You',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 10,
                                  ),
                                ),
                                backgroundColor: Colors.blue.shade700,
                                padding: EdgeInsets.zero,
                                visualDensity: VisualDensity.compact,
                              ),
                            ),
                        ],
                      ),
                      Text(
                        'Level ${user.level} • ${user.badges} badges',
                        style: TextStyle(
                          color: Colors.grey.shade600,
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 12),
                Text(
                  '${user.points} points',
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                    color: Colors.black,
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildTabBar() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            blurRadius: 10,
            spreadRadius: 2,
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _buildTabItem(icon: Icons.library_books, index: 0),
          _buildTabItem(icon: Icons.military_tech, index: 1),
          _buildTabItem(icon: Icons.leaderboard, index: 2),
        ],
      ),
    );
  }

  Widget _buildTabItem({required IconData icon, required int index}) {
    bool isSelected = _selectedTabIndex == index;
    return Expanded(
      child: GestureDetector(
        onTap: () => setState(() => _selectedTabIndex = index),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 12),
          decoration: BoxDecoration(
            color: isSelected ? Colors.blue.shade700 : Colors.transparent,
            borderRadius: BorderRadius.circular(10),
          ),
          child: Icon(
            icon,
            color: isSelected ? Colors.white : Colors.grey.shade600,
          ),
        ),
      ),
    );
  }

  Widget _buildSectionCard({required String title, required Widget child}) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            child,
          ],
        ),
      ),
    );
  }

  Widget _buildBadgeChip(String label, IconData icon) {
    return Chip(
      avatar: Icon(icon, color: Colors.orange.shade800, size: 20),
      label: Text(label, style: const TextStyle(fontWeight: FontWeight.w600)),
      backgroundColor: Colors.orange.shade100,
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
    );
  }

  Widget _buildProgressRow(String title, double value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6.0),
      child: Row(
        children: [
          Expanded(flex: 2, child: Text(title)),
          Expanded(
            flex: 3,
            child: LinearProgressIndicator(
              value: value,
              backgroundColor: Colors.grey.shade200,
              color: Colors.blue,
              minHeight: 8,
              borderRadius: BorderRadius.circular(4),
            ),
          ),
          const SizedBox(width: 10),
          Text('${(value * 100).toInt()}%'),
        ],
      ),
    );
  }

  BottomNavigationBar _buildBottomNavigationBar() {
    // Define colors based on the image for easy customization
    const Color navBarBackgroundColor = Color(0xFFDDEBFF);
    const Color navBarItemColor = Color(0xFF2A4D8E);
    const double iconSize = 28.0; // Define a consistent size for your icons

    return BottomNavigationBar(
      currentIndex: _bottomNavIndex,
      onTap: (index) {
        setState(() {
          _bottomNavIndex = index;
        });
      },

      // --- Style Changes to match your image ---
      backgroundColor: navBarBackgroundColor, // Light blue background
      type: BottomNavigationBarType
          .fixed, // Ensures all items are visible and labels don't hide
      elevation: 0, // Removes the default shadow for a flat look
      // Set both selected and unselected colors to be the same dark blue
      selectedItemColor: navBarItemColor,
      unselectedItemColor: navBarItemColor,

      // Consistent font size whether selected or not
      selectedFontSize: 12.0,
      unselectedFontSize: 12.0,

      // --- Item Definitions using Image.asset ---
      items: [
        BottomNavigationBarItem(
          icon: Padding(
            padding: EdgeInsets.only(
              bottom: 4.0,
            ), // Add a little space between icon and text
            child: Image.asset('assets/Home.png', height: iconSize),
          ),
          label: 'Home',
        ),
        BottomNavigationBarItem(
          icon: Padding(
            padding: EdgeInsets.only(bottom: 4.0),
            child: Image.asset('assets/Quizlet.png', height: iconSize),
          ),
          label: 'Quiz',
        ),
        BottomNavigationBarItem(
          icon: Padding(
            padding: EdgeInsets.only(bottom: 4.0),
            child: Image.asset('assets/Teaching.png', height: iconSize),
          ),
          label: 'Learn',
        ),
        BottomNavigationBarItem(
          icon: Padding(
            padding: EdgeInsets.only(bottom: 4.0),
            child: Image.asset('assets/Shield.png', height: iconSize),
          ),
          label: 'Badges',
        ),
        BottomNavigationBarItem(
          icon: Padding(
            padding: EdgeInsets.only(bottom: 4.0),
            child: Image.asset('assets/Compass.png', height: iconSize),
          ),
          label: 'Explore',
        ),
      ],
    );
  }

  Widget _buildStatItem(String value, String label) {
    return Column(
      children: [
        Text(
          value,
          style: const TextStyle(
            fontSize: 28,
            fontWeight: FontWeight.bold,
            color: Colors.blue,
          ),
        ),
        const SizedBox(height: 4),
        Text(label, style: TextStyle(color: Colors.grey.shade600)),
      ],
    );
  }

  Widget _buildProfileHeader() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        gradient: const LinearGradient(
          colors: [Color(0xFF4A00E0), Color(0xFF8E2DE2)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.shield, color: Colors.white, size: 40),
              const SizedBox(width: 10),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '450 Points',
                    style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  const Text(
                    'Level 3 • Earth Observer',
                    style: TextStyle(fontSize: 16, color: Colors.white70),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 15),
          const Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Icon(Icons.local_fire_department, color: Colors.orange),
                  SizedBox(width: 5),
                  Text('5 day streak', style: TextStyle(color: Colors.white)),
                ],
              ),
              Row(
                children: [
                  Icon(Icons.military_tech, color: Colors.yellow),
                  SizedBox(width: 5),
                  Text('2 badges', style: TextStyle(color: Colors.white)),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}
