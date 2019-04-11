import 'package:google_maps_webservice/places.dart';
import 'package:finder/config/Config.dart';
import 'package:finder/model/CoffeeShopsData.dart';
import 'package:finder/model/MyLocationData.dart';
class CoffeeShopsApi {

  static CoffeeShopsApi _instance;
  static CoffeeShopsApi getInstance() => _instance ??= CoffeeShopsApi();

  Future<CoffeeShopsData> getCoffeeShops(MyLocationData location) async {

    final googlePlaces = GoogleMapsPlaces(apiKey:'AIzaSyBIY-rHvMmLObBw_cjs5bVxRU_1bn9Z0HA');
    final response = await googlePlaces.searchNearbyWithRadius(
        Location(location.lat, location.lon),
        2000, type: 'Cafe', keyword: 'coffee');
    return CoffeeShopsData.convertToShops(response.results);
  }
}