import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:location/location.dart';
import 'package:sellers_bay/models/location.dart';
import 'package:sellers_bay/models/product.dart';
import 'package:sellers_bay/shared/global__config.dart';

class LocationInput1 extends StatefulWidget {
  final Function setLocation;
  final Product product;
  LocationInput1(this.setLocation, this.product);
  @override
  _LocationInput1State createState() => _LocationInput1State();
}

class _LocationInput1State extends State<LocationInput1> {
  final FocusNode _addressInputFocusNode = FocusNode();
  final TextEditingController _addressInputContoller = TextEditingController();
  LocationDataPro _locationData;

  @override
  void initState() {
    _addressInputFocusNode.addListener(_updateLocation);
    if (widget.product != null) {
      _getStaticMap(widget.product.locationData.address, geocode: false);
    }
    super.initState();
  }

  void _updateLocation() {
    if (!_addressInputFocusNode.hasFocus) {
      _getStaticMap(_addressInputContoller.text);
    }
  }

  void _getStaticMap(String address,
      {double lat, double lng, geocode = true}) async {
    if (address.isEmpty) {
      widget.setLocation(null);
      return;
    }
    if (geocode) {
      final Uri uri = Uri.https('maps.googleapis.com', '/maps/api/geocode/json',
          {'address': address, 'key': apiKey});
      final http.Response response = await http.get(uri);
      final decodedResponse = json.decode(response.body);
      final formattedAddress =
          decodedResponse['results'][0]['formatted_address'];
      final coords = decodedResponse['results'][0]['geometry']['location'];
      _locationData = LocationDataPro(
          address: formattedAddress,
          latitude: coords['lat'],
          longitude: coords['lng']);
    } else if (lat == null && lng == null) {
      _locationData = widget.product.locationData;
    } else {
      _locationData =
          LocationDataPro(address: address, latitude: lat, longitude: lng);
    }

    widget.setLocation(_locationData);
    if (mounted) {
      setState(() {
        _addressInputContoller.text = _locationData.address;
      });
    }
  }

  Future<String> _getAddress(double latitude, double longitude) async {
    final uri = Uri.https(
      'maps.googleapis.com',
      '/maps/api/geocode/json',
      {
        'latlng': '${latitude.toString()},${longitude.toString()}',
        'key': apiKey
      },
    );
    final http.Response response = await http.get(uri);
    final decodedResponse = json.decode(response.body);
    print(response.body);
    final formattedAddress = decodedResponse['results'][0]['formatted_address'];
    return formattedAddress;
  }

  void _getUserLocation() async {
    final Location location = new Location();
    LocationData _location;
    var _locationResult = await location.getLocation();
    _location = _locationResult;
    final address = await _getAddress(_location.latitude, _location.longitude);
    _getStaticMap(address,
        geocode: false, lat: _location.latitude, lng: _location.longitude);
  }

  @override
  void dispose() {
    _addressInputFocusNode.removeListener(_updateLocation);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    print('location input fired');
    return Column(
      children: <Widget>[
        TextFormField(
          focusNode: _addressInputFocusNode,
          controller: _addressInputContoller,
          validator: (String value) {
            if (_locationData == null || value.isEmpty) {
              return 'No valid location found';
            }
            return null;
          },
          decoration: InputDecoration(labelText: 'Address'),
        ),
        SizedBox(
          height: 5.0,
        ),
        FlatButton(
          onPressed: _getUserLocation,
          child: Text(
            'Locate me',
            style: TextStyle(color: Colors.black),
          ),
        ),

        //Image.network(''),
      ],
    );
  }
}
