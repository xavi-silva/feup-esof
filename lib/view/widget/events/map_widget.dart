import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geocoding/geocoding.dart';

class MapWidget extends StatefulWidget {
  final Set<Marker> markers = {};
  final GeoPoint? initialGeoPoint;

  MapWidget({Key? key, this.initialGeoPoint}) : super(key: key) {
    if (initialGeoPoint != null) {
      addMarkerFromGeoPoint(initialGeoPoint!);
    }
  }

  @override
  State<MapWidget> createState() => _MapWidgetState();

  LatLng? getMarkerCoordinates() {
    if (markers.isNotEmpty) {
      final Marker marker = markers.firstWhere(
        (marker) => marker.markerId.value == 'userDefinedLocation',
        orElse: () => markers.first,
      );
      return marker.position;
    }
    return null;
  }

  void addMarkerFromGeoPoint(GeoPoint geoPoint) {
    final LatLng location = LatLng(geoPoint.latitude, geoPoint.longitude);
    markers.add(
      Marker(
        markerId: const MarkerId("userDefinedLocation"),
        position: location,
      ),
    );
  }
}

class _MapWidgetState extends State<MapWidget> {
  late GoogleMapController _controller;
  LatLng _center = const LatLng(41.07661472780003, -8.365955783816469);
  final TextEditingController _addressController = TextEditingController();

  void _onMapCreated(GoogleMapController controller) {
    _controller = controller;
  }

  Future<void> _addMarker(String address) async {
    try {
      print('Searching for address: $address');
      final List<Location> locations = await locationFromAddress(address);
      if (locations.isNotEmpty) {
        print("NOT EMPTY");
        final Location location = locations.first;
        setState(() {
          widget.markers.clear();
          widget.markers.add(
            Marker(
              markerId: const MarkerId("userDefinedLocation"),
              position: LatLng(location.latitude, location.longitude),
            ),
          );
          _center = LatLng(location.latitude, location.longitude);
        });
        _controller.animateCamera(CameraUpdate.newLatLngZoom(_center, 15.0));
      } else {
        _showAddressNotFoundDialog();
      }
    } on NoResultFoundException {
      _showAddressNotFoundDialog();
    }
  }

  void _showAddressNotFoundDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Address Not Found'),
          content: const Text('The address you entered could not be found.'),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('OK'),
            ),
          ],
        );
      },
    );
  }

  @override
  void initState() {
    super.initState();
    _center = widget.markers.isEmpty
        ? const LatLng(41.07661472780003, -8.365955783816469)
        : widget.markers.first.position;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          GoogleMap(
            onMapCreated: _onMapCreated,
            initialCameraPosition: CameraPosition(
              target: _center,
              zoom: 12.0,
            ),
            markers: widget.markers,
          ),
          (widget.initialGeoPoint != null)
              ? SizedBox()
              : Positioned(
                  top: 20.0,
                  left: 20.0,
                  right: 20.0,
                  child: Container(
                    color: Colors.white,
                    child: Row(
                      children: [
                        Expanded(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Flexible(
                                child: TextField(
                                  controller: _addressController,
                                  style: TextStyle(color: Colors.black),
                                  decoration: InputDecoration(
                                    hintStyle: TextStyle(color: Colors.black),
                                    border: InputBorder.none,
                                    hintText: 'Enter Address',
                                    contentPadding:
                                        EdgeInsets.symmetric(horizontal: 16.0),
                                  ),
                                ),
                              ),
                              SizedBox(
                                height: 40,
                                child: Center(
                                  child: Container(
                                    decoration: BoxDecoration(
                                      border: Border.all(color: Colors.black),
                                      borderRadius: BorderRadius.circular(4.0),
                                    ),
                                    child: TextButton(
                                      onPressed: () {
                                        final String address =
                                            _addressController.text;
                                        if (address.isNotEmpty) {
                                          _addMarker(address);
                                        }
                                      },
                                      child: Text(
                                        'Submit',
                                        style: TextStyle(
                                          color: Colors.black,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                              SizedBox(
                                width: 5,
                              )
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
        ],
      ),
    );
  }
}
