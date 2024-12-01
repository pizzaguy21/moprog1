import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:polylingo/screens/input_testi_screen.dart';

class Testimony {
  final String name;
  final String content;

  Testimony({required this.name, required this.content});

  factory Testimony.fromFirestore(DocumentSnapshot doc) {
    Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
    return Testimony(
      name: data['title'] ?? '',
      content: data['content'] ?? '',
    );
  }
}

class TestimonyScreen extends StatefulWidget {
  const TestimonyScreen({super.key});

  @override
  _TestimonyScreenState createState() => _TestimonyScreenState();
}

class _TestimonyScreenState extends State<TestimonyScreen> {
  final CollectionReference testimonialsCollection =
      FirebaseFirestore.instance.collection('testimonials');

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: const Color(0xFF4B61DD),
        title: const Text(
          'Testimony',
          style: TextStyle(color: Colors.white),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.g_translate, color: Colors.white),
            onPressed: () {
            },
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: StreamBuilder<QuerySnapshot>(
              stream: testimonialsCollection
                  .orderBy('timestamp', descending: true)
                  .snapshots(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }

                if (snapshot.hasError) {
                  return const Center(
                    child: Text('An error occurred while loading testimonies.'),
                  );
                }

                if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                  return const Center(
                    child: Text('No testimonies available.'),
                  );
                }

                final testimonies = snapshot.data!.docs
                    .map((doc) => Testimony.fromFirestore(doc))
                    .toList();

                return ListView.builder(
                  itemCount: testimonies.length,
                  itemBuilder: (context, index) {
                    return Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: Container(
                        padding: const EdgeInsets.all(15),
                        decoration: BoxDecoration(
                          color: const Color(0xFFD6E4FF),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              testimonies[index].name,
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Color(0xFF4B61DD),
                              ),
                            ),
                            const SizedBox(height: 5),
                            Text(testimonies[index].content),
                          ],
                        ),
                      ),
                    );
                  },
                );
              },
            ),
          ),

          Padding(
            padding: const EdgeInsets.all(20.0),
            child: ElevatedButton(
              onPressed: () async {
                final result = await Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => InputTestiScreen(),
                  ),
                );

                if (result != null && result is Map<String, String>) {
                  final title = result['title'] ?? '';
                  final content = result['content'] ?? '';
                  if (title.isNotEmpty && content.isNotEmpty) {
                    // Add the new testimony to Firestore
                    await testimonialsCollection.add({
                      'title': title,
                      'content': content,
                      'timestamp': FieldValue.serverTimestamp(),
                    });
                  }
                }
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF4B61DD),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
              ),
              child: const Text(
                'Input Testimony',
                style: TextStyle(color: Colors.white),
              ),
            ),
          ),
        ],
      ),
    );
  }
}