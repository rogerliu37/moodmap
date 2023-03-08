import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';

class AddMoodPage extends StatefulWidget {
  @override
  _AddMoodPageState createState() => _AddMoodPageState();
}

class _AddMoodPageState extends State<AddMoodPage> {
  String _selectedEmoji = '';
  Position? _currentPosition;

  void _getCurrentLocation() async {
    final position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);
    setState(() {
      _currentPosition = position;
    });
  }

  void _addMood() async {
    if (_selectedEmoji.isNotEmpty && _currentPosition != null) {
      await FirebaseFirestore.instance.collection('moods').add({
        'emoji': _selectedEmoji,
        'timestamp': DateTime.now(),
        'latitude': _currentPosition!.latitude,
        'longitude': _currentPosition!.longitude,
      });
      Navigator.pop(context);
    }
  }

  @override
  void initState() {
    super.initState();
    _getCurrentLocation();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Add Mood'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Select an Emoji',
              style: TextStyle(fontSize: 24),
            ),
            SizedBox(height: 16),
            Wrap(
              spacing: 16,
              children: [
                GestureDetector(
                  onTap: () {
                    setState(() {
                      _selectedEmoji = '😀';
                    });
                  },
                  child: Text(
                    '😀',
                    style: TextStyle(fontSize: 40),
                  ),
                ),
                GestureDetector(
                  onTap: () {
                    setState(() {
                      _selectedEmoji = '😔';
                    });
                  },
                  child: Text(
                    '😔',
                    style: TextStyle(fontSize: 40),
                  ),
                ),
                GestureDetector(
                  onTap: () {
                    setState(() {
                      _selectedEmoji = '😭';
                    });
                  },
                  child: Text(
                    '😭',
                    style: TextStyle(fontSize: 40),
                  ),
                ),
              ],
            ),
            SizedBox(height: 16),
            if (_currentPosition != null)
              Text(
                'Location: ${_currentPosition!.latitude}, ${_currentPosition!.longitude}',
                style: TextStyle(fontSize: 16),
              ),
            SizedBox(height: 16),
            ElevatedButton(
              onPressed: _addMood,
              child: Text('Add Mood'),
            ),
          ],
        ),
      ),
    );
  }
}
