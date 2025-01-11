import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart';

class LocationService {
  // Get the current position of the device
  Future<Position> getCurrentLocation() async {
    bool serviceEnabled;
    LocationPermission permission;

    // Check if location services are enabled
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      return Future.error('Location services are disabled');
    }

    // Check location permission
    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return Future.error('Location permission is denied');
      }
    }

    // If permission is granted, fetch the location
    return await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
  }
  
  // Convert latitude and longitude to a city name
  Future<String> getCityFromCoordinates(Position position) async {
    try {
      List<Placemark> placemarks = await placemarkFromCoordinates(position.latitude, position.longitude);
      Placemark placemark = placemarks[0];  // Get the first result
      return placemark.locality ?? 'Unknown City';  // Return the city name
    }    
    catch (e) {
    // Afficher le type de l'exception et les détails de la stack trace
      return 'Limoges';
    }
  }
}