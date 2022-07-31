import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:http/http.dart' as http;
import 'dart:convert' as convert;

import '../../util/constants.dart';


class LocationService
{
  final String key = 'AIzaSyCcQZAzmoTf1rwB_nL5u5iS-X5jtTeiNY4';

  Future<String> getPlaceId(String input)
  async{
    String url = 'https://maps.googleapis.com/maps/api/place/findplacefromtext/json?input=$input&inputtype=textquery&key=$key';
    var response = await http.get(Uri.parse(url));
    var json = convert.jsonDecode(response.body);
    var placeID = json['candidates'][0]['place_id'] as String;
    return placeID;
  }

  Future<Map<String,dynamic>> getPlace(String input)
  async{
    final placeId = await getPlaceId(input);
    final String url = 'https://maps.googleapis.com/maps/api/place/details/json?place_id=$placeId&key=$key';
    var response = await http.get(Uri.parse(url));
    var json = convert.jsonDecode(response.body);
    var results = json['result'] as Map<String,dynamic>;
    debugPrintFullText('$results');
    return results;
  }

  Future<Map<String,dynamic>> getDirections(String start , String end)
  async{
    final String url = 'https://maps.googleapis.com/maps/api/directions/json?origin=$start&destination=$end&key=$key';
    var response = await http.get(Uri.parse(url));
    var json = convert.jsonDecode(response.body);
    debugPrintFullText('$json');
    var results =
    {
      'bounds_ne': json['routes'][0]['bounds']['northeast'],
      'bounds_sw': json['routes'][0]['bounds']['southwest'],
      'start_location': json['routes'][0]['legs'][0]['start_location'],
      'end_location': json['routes'][0]['legs'][0]['end_location'],
      'polyline': json['routes'][0]['overview_polyline']['points'],
      'polyline_decoded': PolylinePoints().decodePolyline(json['routes'][0]['overview_polyline']['points']),
    };
    debugPrintFullText('$results');

    return results;
  }



}