import 'package:flutter/material.dart';

class EnglishCourseScreen extends StatelessWidget {
  const EnglishCourseScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF4B61DD),
      body: Padding(
        padding: const EdgeInsets.only(top: 45, bottom: 20, left: 20, right: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Polylingo',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.favorite_border, color: Colors.white),
                  onPressed: () {},
                ),
              ],
            ),
            const SizedBox(height: 20),
            Row(
              children: [
                // Back button
                IconButton(
                  icon: const Icon(Icons.arrow_back, color: Colors.white),
                  onPressed: () {
                    Navigator.pop(context); // Kembali ke layar sebelumnya
                  },
                ),
                const SizedBox(width: 5),
                // England flag
                Image.asset(
                  'assets/us_flag.png', // Ensure this image is available in the assets folder
                  width: 30,
                  height: 30,
                ),
                const SizedBox(width: 10),
                // Course title
                const Text(
                  'English',
                  style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 5),
            const Text(
              '5 Lessons   ·   1 Quiz',
              style: TextStyle(
                fontSize: 16,
                color: Colors.white70,
              ),
            ),
            const SizedBox(height: 30),
            Expanded(
              child: ListView(
                children: [
                  _buildCourseItem('Basic Vocabulary', 'Learn essential English vocabulary.', Icons.book),
                  _buildCourseItem('Common Phrases', 'Master common phrases for communication.', Icons.comment),
                  _buildCourseItem('Grammar Rules', 'Understand essential grammar rules.', Icons.rule),
                  _buildCourseItem('Pronunciation', 'Perfect your pronunciation with tips.', Icons.record_voice_over),
                  _buildCourseItem('Quiz', 'Test your knowledge with a quiz.', Icons.quiz),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCourseItem(String title, String description, IconData icon) {
    return Container(
      margin: const EdgeInsets.only(bottom: 15),
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.2),
        borderRadius: BorderRadius.circular(15),
      ),
      child: Row(
        children: [
          Icon(icon, size: 40, color: Colors.white.withOpacity(0.8)),
          const SizedBox(width: 15),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 18,
                    color: Colors.white,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 5),
                Text(
                  description,
                  style: const TextStyle(
                    fontSize: 14,
                    color: Colors.white70,
                  ),
                ),
              ],
            ),
          ),
          Icon(Icons.check_box_outline_blank, color: Colors.white.withOpacity(0.8)),
        ],
      ),
    );
  }
}
