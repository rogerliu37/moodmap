import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class MapPage extends StatefulWidget {
  @override
  _MapPageState createState() => _MapPageState();
}

class _MapPageState extends State<MapPage> {
  late GoogleMapController _mapController;
  List<Marker> _markers = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Map'),
      ),
      body: GoogleMap(
        initialCameraPosition: CameraPosition(
          target: LatLng(0, 0),
          zoom: 2,
        ),
        onMapCreated: (controller) {
          _mapController = controller;
        },
        markers: Set<Marker>.of(_markers),
      ),
    );
  }

  @override
  void initState() {
    super.initState();

    final currentUser = FirebaseAuth.instance.currentUser;
    if (currentUser == null) {
      // Handle the case where the user is not logged in or the authentication state is not initialized.
      return;
    }

    FirebaseFirestore.instance
        .collection('moods')
        .where('userId',
            isEqualTo: currentUser.uid) // Filter by the userId field.
        .get()
        .then((querySnapshot) {
      querySnapshot.docs.forEach((documentSnapshot) {
        final mood = documentSnapshot.data() as Map<String, dynamic>;
        final emoji = mood['emoji'];
        final latitude = mood['latitude'] as double?;
        final longitude = mood['longitude'] as double?;
        final marker = Marker(
          markerId: MarkerId(documentSnapshot.id),
          position: LatLng(latitude ?? 0, longitude ?? 0),
          infoWindow: InfoWindow(
            title: emoji,
          ),
        );
        setState(() {
          _markers.add(marker);
        });
      });
    });
  }
}
