import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:finder/api/MyLocationApi.dart';
import 'package:finder/model/MyLocationData.dart';
import 'package:finder/model/CoffeeShopsData.dart';
import 'package:finder/api/CoffeeShopsApi.dart';
import 'package:finder/coffeeCard.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(

        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {


  GoogleMapController mapController;
  MyLocationData _myLocationData;
  CoffeeShopsData _shops;
  Marker _selectedMarker;
  String _shopName;
  String _shopImage;

  void _updateSelectedMarker(MarkerOptions changes) {
    mapController.updateMarker(_selectedMarker, changes);
  }

  void _onMarkerTapped(Marker marker) {
    if(_selectedMarker != null) {
      _updateSelectedMarker(MarkerOptions(
        icon: BitmapDescriptor.defaultMarker,
      ));
    }
    setState(() {
      _selectedMarker = marker;
    });
    var selectedShop = _shops.shopList.singleWhere(
            (shop) => shop.name == marker.options.infoWindowText.title,
        orElse: () => null
    );
    _shopName = selectedShop.name;
    _shopImage = selectedShop.photoRef;
    _updateSelectedMarker(
        MarkerOptions(
          icon: BitmapDescriptor.defaultMarkerWithHue(
              BitmapDescriptor.hueGreen
          ),
          infoWindowText: InfoWindowText(_shopName, ''),
        )
    );
  }

  _addMarkers(CoffeeShopsData places) {
    places.shopList.forEach((shop) {
      mapController.addMarker(
        MarkerOptions(
          position: LatLng(
              shop.lat,
              shop.lon),
          infoWindowText: InfoWindowText(shop.name, ''),
        ),
      );
    });
  }

  Future<CoffeeShopsData> _getCoffeeShops() async {
    final shopsApi = CoffeeShopsApi.getInstance();
    return await shopsApi.getCoffeeShops(this._myLocationData);
  }

  Future<MyLocationData> _getLocation() async {
    final locationApi = MyLocationApi.getInstance();
    return await locationApi.getLocation();
  }

  @override
  void initState() {
    super.initState();

    _getLocation().then((location) {
      setState(() {
        _myLocationData = location;
      });
    });
  }

  void _onMapCreated(GoogleMapController controller) async{
    _shops = await _getCoffeeShops();
    setState(() {
      mapController = controller;
      _addMarkers(_shops);
      mapController.onMarkerTapped.add(_onMarkerTapped);
    });
  }
  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      body: Stack(
        children: <Widget>[
          new Center(
            child: _myLocationData != null ? SizedBox(
              child: GoogleMap(
                onMapCreated: _onMapCreated,
                options: GoogleMapOptions(
                  cameraPosition: CameraPosition(
                    target: LatLng(
                      _myLocationData.lat,
                      _myLocationData.lon,
                    ),
                    zoom: 14.0,
                  ),
                ),
              ),
            ) : CircularProgressIndicator(
              strokeWidth: 4.0,
              valueColor: AlwaysStoppedAnimation(Colors.white),
            ),
          ),
          Align(
            child: _selectedMarker != null ? CoffeeCard(
              shopImage: _shopImage,
              shopName: _shopName,
            ) :
            Container(),
            alignment: Alignment.bottomCenter,
          ),
        ],
      ),
    );
  }
}
