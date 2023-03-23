import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:intl/intl.dart';

class MoodPage extends StatefulWidget {
  @override
  _MoodPageState createState() => _MoodPageState();
}

class _MoodPageState extends State<MoodPage> {
  List<DocumentSnapshot>? _moods;

  @override
  Widget build(BuildContext context) {
    final currentUser = FirebaseAuth.instance.currentUser;
    return Scaffold(
      appBar: AppBar(
        title: Text('Mood History'),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('moods')
            .where('userId', isEqualTo: currentUser?.uid)
            .orderBy('timestamp', descending: false)
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Center(
              child: Text('Error: ${snapshot.error}'),
            );
          }

          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: CircularProgressIndicator(),
            );
          }

          _moods = snapshot.data!.docs;

          return ListView.builder(
            itemCount: _moods!.length,
            itemBuilder: (context, index) {
              final mood = _moods![index].data() as Map<String, dynamic>;

              return ListTile(
                leading: Text(
                  mood['emoji'],
                  style: TextStyle(fontSize: 32),
                ),
                title: Text(
                  DateFormat('MMMM d, yyyy').format(mood['timestamp'].toDate()),
                  style: TextStyle(fontSize: 16),
                ),
                subtitle: Text(
                  'Location: ${mood['latitude']}, ${mood['longitude']}',
                  style: TextStyle(fontSize: 12),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
