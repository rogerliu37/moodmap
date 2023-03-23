import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class MapPage extends StatefulWidget {
  @override
  _MapPageState createState() => _MapPageState();
}

class _MapPageState extends State<MapPage> {
  Set<Marker> _markers = {};

  void _loadMoods() async {
    final moods = await FirebaseFirestore.instance.collection('moods').get();
    setState(() {
      _markers = moods.docs
          .map((mood) => Marker(
        markerId: MarkerId(mood.id),
        position: LatLng(mood['latitude'], mood['longitude']),
        icon: BitmapDescriptor.defaultMarkerWithHue(
          mood['emoji'] == '😀'
              ? BitmapDescriptor.hueGreen
              : mood['emoji'] == '😔'
              ? BitmapDescriptor.hueYellow
              : BitmapDescriptor.hueRed,
        ),
        infoWindow: InfoWindow(
          title: mood['emoji'],
          snippet: mood['timestamp'].toString(),
        ),
      ))
          .toSet();
    });
  }

  void _filterMoods(String emoji) async {
    final moods = await FirebaseFirestore.instance
        .collection('moods')
        .where('emoji', isEqualTo: emoji)
        .get();

    setState(() {
      _markers = moods.docs
          .map((mood) => Marker(
        markerId: MarkerId(mood.id),
        position: LatLng(mood['latitude'], mood['longitude']),
        icon: BitmapDescriptor.defaultMarkerWithHue(
          mood['emoji'] == '😀'
              ? BitmapDescriptor.hueGreen
              : mood['emoji'] == '😔'
              ? BitmapDescriptor.hueYellow
              : BitmapDescriptor.hueRed,
        ),
        infoWindow: InfoWindow(
          title: mood['emoji'],
          snippet: mood['timestamp'].toString(),
        ),
      ))
          .toSet();
    });
  }

  @override
  void initState() {
    super.initState();
    _loadMoods();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Mood Map'),
        actions: [
          PopupMenuButton<String>(
            onSelected: _filterMoods,
            itemBuilder: (context) => [
              PopupMenuItem(
                value: '😀',
                child: Text('😀 Happy'),
              ),
              PopupMenuItem(
                value: '😔',
                child: Text('😔 Sad'),
              ),
              PopupMenuItem(
                value: '😭',
                child: Text('😭 Crying'),
              ),
            ],
          ),
        ],
      ),
      body: GoogleMap(
        markers: _markers,
        initialCameraPosition: CameraPosition(
          target: LatLng(0, 0),
          zoom: 2,
        ),
      ),
    );
  }
}

