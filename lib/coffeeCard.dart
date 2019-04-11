import 'package:finder/config/Config.dart';
import 'package:flutter/material.dart';
import 'package:finder/directions.dart';
import 'package:url_launcher/url_launcher.dart';

class CoffeeCard extends StatelessWidget {

  CoffeeCard({this.shopName, this.shopImage});

  final String shopImage;
  final String shopName;
  static const _endpoint =
      'https://maps.googleapis.com/maps/api/place/photo';

  String _placesPhotoApi() {
    return _endpoint + '?maxheight=' + '150' + '&photoreference=' +
        shopImage + '&key=' + apiKey;
  }

  void _callDirections() async {
    final url = 'https://www.google.com/maps/dir/?api=1&destination=' +
        shopName;

    if(await canLaunch(url.toString()))
      await launch(url);
    else
      print(url.toLowerCase().toString()+"printed");
      throw 'Could not launch $url';
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 240.0,
      width: 300.0,
      child: Card(
        elevation: 16.0,
        child: Column(
          children: <Widget>[
            Image.network(
              _placesPhotoApi(),
              height: 150.0,
              width: 300.0,
              fit: BoxFit.contain,
            ),
            Container(
              padding: EdgeInsets.all(6.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  Text(
                    shopName,
                    style: TextStyle(
                      fontSize: 15.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  new Container(height: 10.0,),
                  GestureDetector(
                    onTap: _callDirections,
                    child: Material(
                      elevation: 12.0,
                      child: Directions(),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
