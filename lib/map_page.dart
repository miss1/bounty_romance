import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';
import 'dart:convert';

import 'common/db.dart';

class MapPage extends StatefulWidget {
  final String type;
  final LatLng center;
  const MapPage({Key? key, required this.type, required this.center}) : super(key: key);

  @override
  State<MapPage> createState() => _MapPageState();
}

class _MapPageState extends State<MapPage> {
  final TextEditingController _cityController = TextEditingController();
  GoogleMapController? _mapController;
  final Set<Marker> _markers = {};

  String _cityName = '';
  double _lat = 0.0;
  double _lng = 0.0;

  Future<void> _searchCity() async {
    const apiKey = 'AIzaSyDl85uwy4fM6eCjoj30oCQ6b4LLrgJkZtQ';
    final city = _cityController.text;
    final response = await http.get(Uri.parse(
      'https://maps.googleapis.com/maps/api/geocode/json?address=$city&key=$apiKey',
    ));

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      final results = data['results'] as List<dynamic>;

      if (results.isNotEmpty) {
        final location = results[0]['geometry']['location'];
        _lat = location['lat'];
        _lng = location['lng'];
        _cityName = results[0]['formatted_address'];

        final newMarker = Marker(
          markerId: MarkerId(city),
          position: LatLng(_lat, _lng),
          infoWindow: InfoWindow(title: city),
        );

        setState(() {
          _markers.clear();
          _markers.add(newMarker);
          _mapController?.animateCamera(CameraUpdate.newLatLngZoom(LatLng(_lat, _lng), 10.0));
        });
      } else {
        print('city does not exist');
      }
    } else {
      print('Failed to fetch data');
    }
  }

  Future<void> updateLocation() async {
    if (_cityName != '') {
      await context.read<FireStoreService>().updateUserLocation(_cityName, _lat, _lng);
      if (context.mounted) GoRouter.of(context).pop(_cityName);
    }
  }

  double getZoom() {
    if (widget.center.latitude == 0.0 && widget.center.longitude == 0.0) return 2.0;
    return 10.0;
  }

  Widget _barTitle() {
    if (widget.type == 'me') {
      return const Text('Choose location');
    }
    return const Text('User location');
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: _barTitle(),
          backgroundColor: Colors.blue[700],
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () {
              if (GoRouter.of(context).canPop()) {
                GoRouter.of(context).pop();
              }
            },
          ),
        ),
        body: Column(
          children: [
            Visibility(
              visible: widget.type == 'me',
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  children: [
                    Expanded(
                      child: TextField(
                        controller: _cityController,
                        decoration: InputDecoration(
                          labelText: 'Enter City',
                          suffixIcon: IconButton(
                            icon: const Icon(Icons.search),
                            onPressed: () {
                              _searchCity();
                            },
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 5,),
                    ElevatedButton(
                      onPressed: updateLocation,
                      child: const Text('Submit'),
                    )
                  ],
                )
              ),
            ),
            Expanded(
              child: GoogleMap(
                onMapCreated: (controller) {
                  setState(() {
                    _mapController = controller;
                  });
                },
                markers: _markers,
                initialCameraPosition: CameraPosition(
                  target: widget.center,
                  zoom: getZoom(),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}