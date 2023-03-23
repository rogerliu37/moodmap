import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class StatisticsPage extends StatelessWidget {
  final currentUser = FirebaseAuth.instance.currentUser;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Mood Statistics'),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('moods')
            .where('userId', isEqualTo: currentUser?.uid)
            .snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) return CircularProgressIndicator();

          final moods = snapshot.data!.docs;

          final stats = moods.fold<Map<String, int>>(
            {},
            (previousValue, mood) {
              final emoji = mood['emoji'];
              final frequency = previousValue[emoji] ?? 0;
              return {...previousValue, emoji: frequency + 1};
            },
          );

          return Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'Mood Frequencies',
                style: TextStyle(fontSize: 24),
              ),
              SizedBox(height: 16),
              if (stats.isNotEmpty) ...[
                Text(
                  '😀: ${stats['😀'] ?? 0}',
                  style: TextStyle(fontSize: 20),
                ),
                Text(
                  '😔: ${stats['😔'] ?? 0}',
                  style: TextStyle(fontSize: 20),
                ),
                Text(
                  '😭: ${stats['😭'] ?? 0}',
                  style: TextStyle(fontSize: 20),
                ),
              ] else
                Text(
                  'No Mood Entries',
                  style: TextStyle(fontSize: 20),
                ),
            ],
          );
        },
      ),
    );
  }
}
