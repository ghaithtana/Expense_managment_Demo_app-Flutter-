import 'package:flutter/material.dart';
import 'package:gider_demo/Models/transaction.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class GoogleMapScreen extends StatefulWidget {
  double lat;
  double long;
  final Transaction currentTransaction;

  GoogleMapScreen(
      {required this.lat,
      required this.long,
      required this.currentTransaction});
  @override
  _State createState() => _State();
}

class _State extends State<GoogleMapScreen> {
  Set<Marker> _markers = {};

  void onMapCreated(GoogleMapController controller) {
    setState(() {
      _markers.add(Marker(
          markerId: MarkerId(widget.currentTransaction.id),
          position: LatLng(widget.lat, widget.long),
          infoWindow: InfoWindow(
              title: "açıklama :"+widget.currentTransaction.title,
              snippet:"Tutar :"+ widget.currentTransaction.amount.toString() + ' \$')));
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("Google Map"),
        ),
        body: GoogleMap(
            onMapCreated: onMapCreated,
            markers: _markers,
            initialCameraPosition: CameraPosition(
                target: LatLng(widget.lat, widget.long), zoom: 15)));
  }
}
