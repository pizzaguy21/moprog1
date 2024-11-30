import 'package:flutter/material.dart';
import 'package:translator/translator.dart';
import 'spain_course_screen.dart';
import 'japan_course_screen.dart';
import 'us_course_screen.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({Key? key}) : super(key: key);

  @override
  _SearchScreenState createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  String capitalize(String text) {
    if (text.isEmpty) return text;
    return text[0].toUpperCase() + text.substring(1);
  }

  final GoogleTranslator _translator = GoogleTranslator();

  String _translatedTitle = 'Courses';
  String _translatedSearchPlaceholder = 'Search here...';

  final List<Map<String, String>> _courses = [
    {'language': 'Japanese', 'flagPath': 'assets/japan_flag.png'},
    {'language': 'English', 'flagPath': 'assets/us_flag.png'},
    {'language': 'Spanish', 'flagPath': 'assets/spain_flag.png'},
  ];

  List<Map<String, String>> _translatedCourses = [];
  List<Map<String, String>> _filteredCourses = [];

  @override
  void initState() {
    super.initState();
    // Tambahkan key 'originalLanguage' di data awal
    _translatedCourses = _courses.map((course) {
      return {
        'language': course['language']!,
        'originalLanguage': course['language']!, // Set originalLanguage ke bahasa asli
        'flagPath': course['flagPath']!,
      };
    }).toList();
    _filteredCourses = List.from(_translatedCourses);
  }

Future<void> _translateUI(String targetLang) async {
  try {
    final title = await _translator.translate('Courses', to: targetLang);
    final searchPlaceholder =
        await _translator.translate('Search here...', to: targetLang);

    final translatedCourses = await Future.wait(
      _courses.map((course) async {
        final translatedName =
            await _translator.translate(course['language']!, to: targetLang);
        return {
          'language': capitalize(translatedName.text ?? ''), // Nama hasil terjemahan
          'originalLanguage': course['language']!, // Nama asli
          'flagPath': course['flagPath']!,
        };
      }),
    );

    setState(() {
      _translatedTitle = capitalize(title.text ?? ''); // Kapitalisasi
      _translatedSearchPlaceholder = capitalize(searchPlaceholder.text ?? '');
      _translatedCourses = translatedCourses; // Perbarui daftar terjemahan
      _filteredCourses = translatedCourses; // Perbarui daftar untuk pencarian
    });
  } catch (e) {
    print("Translation error: $e");
  }
}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF4B61DD),
      body: Padding(
        padding:
            const EdgeInsets.only(top: 45, bottom: 20, left: 20, right: 20),
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
                PopupMenuButton<String>(
                  icon: const Icon(Icons.g_translate, color: Colors.white),
                  onSelected: (String value) {
                    _translateUI(value); // Translate UI berdasarkan bahasa
                  },
                  itemBuilder: (BuildContext context) {
                    return [
                      const PopupMenuItem(value: 'en', child: Text('English')),
                      const PopupMenuItem(value: 'es', child: Text('Spanish')),
                      const PopupMenuItem(value: 'id', child: Text('Indonesian')),
                      const PopupMenuItem(value: 'ja', child: Text('Japanese')),
                    ];
                  },
                ),
              ],
            ),
            const SizedBox(height: 20),
            Text(
              _translatedTitle,
              style: const TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 20),
            TextField(
              onChanged: (value) {
                setState(() {
                  if (value.isEmpty) {
                    // Jika input kosong, tampilkan semua kursus hasil terjemahan
                    _filteredCourses = List.from(_translatedCourses);
                  } else {
                    // Filter daftar berdasarkan huruf depan (prefix match)
                    _filteredCourses = _translatedCourses
                        .where((course) => course['language']!
                            .toLowerCase()
                            .startsWith(value.toLowerCase())) // Gunakan startsWith
                        .toList();
                  }
                });
              },
              decoration: InputDecoration(
                hintText: _translatedSearchPlaceholder, // Placeholder terjemahan
                hintStyle: const TextStyle(color: Colors.grey),
                prefixIcon: const Icon(Icons.search, color: Colors.grey),
                filled: true,
                fillColor: Colors.white,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(30),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
            const SizedBox(height: 30),
            Expanded(
              child: _filteredCourses.isEmpty
                  ? Center(
                      child: Text(
                        'No courses found.', // Pesan jika tidak ada hasil
                        style: const TextStyle(
                          fontSize: 18,
                          color: Colors.white,
                        ),
                      ),
                    )
                  : ListView.builder(
                itemCount: _filteredCourses.length,
                itemBuilder: (context, index) {
                  final course = _filteredCourses[index];
                  return Column(
                    children: [
                      if (course['originalLanguage'] != null && course['flagPath'] != null)
                        _buildCourseItem(
                          context,
                          course['language'] ?? '', // Nama terjemahan
                          course['originalLanguage'] ?? '', // Nama asli
                          course['flagPath'] ?? '', // Path gambar bendera
                        ),
                      const SizedBox(height: 15),
                    ],
                  );
                },
              )
            ),
          ],
        ),
      ),
    );
  }

Widget _buildCourseItem(
    BuildContext context, String translatedLanguage, String originalLanguage, String flagPath) {
  return GestureDetector(
    onTap: () {
      if (originalLanguage == 'Japanese') {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => JapaneseCoursePage()),
        );
      } else if (originalLanguage == 'English') {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => EnglishCoursePage()),
        );
      } else if (originalLanguage == 'Spanish') {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => SpanishCoursePage()),
        );
      }
    },
    child: Container(
      padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.2),
        borderRadius: BorderRadius.circular(15),
      ),
      child: Row(
        children: [
          CircleAvatar(
            radius: 20,
            backgroundImage: AssetImage(flagPath),
          ),
          const SizedBox(width: 15),
          Text(
            translatedLanguage, // Tampilkan nama terjemahan
            style: const TextStyle(
              fontSize: 18,
              color: Colors.white,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    ),
  );
}
}