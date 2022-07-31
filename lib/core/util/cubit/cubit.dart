import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:maps/core/util/cubit/state.dart';
import '../../di/injection.dart';
import '../../network/local/cache_helper.dart';
import '../../network/repository.dart';
import '../constants.dart';
import '../translation.dart';

class AppCubit extends Cubit<AppState> {
  final Repository _repository;

  AppCubit({
    required Repository repository,
  })  : _repository = repository,
        super(Empty());

  static AppCubit get(context) => BlocProvider.of(context);

  late TranslationModel translationModel;

  bool isRtl = false;
  bool isRtlChange = false;
  bool isDark = false;
  bool isPassword = true;
  IconData suffix = Icons.visibility_outlined;
  late ThemeData lightTheme;
  late ThemeData darkTheme;
  late String family;

  void setThemes({
    required bool dark,
    required bool rtl,
  }) {
    isRtl = rtl;
    isRtlChange = rtl;
    isDark = dark;

    debugPrint('dark mode now is------------- $isDark');

    changeTheme();

    emit(ThemeLoaded());
  }


  void changeLanguage({required bool value}) async {
    isRtl = !isRtl;

    sl<CacheHelper>().put('isRtl', isRtl);
    String translation = await rootBundle
        .loadString('assets/translations/${isRtl ? 'ar' : 'en'}.json');

    setTranslation(
      translation: translation,
    );

    emit(ChangeLanguageState());
  }

  void changeMode({required bool value}) {
    isDark = value;

    sl<CacheHelper>().put('isDark', isDark);

    emit(ChangeModeState());
  }

  void changeTheme() {
    family = isRtl ? 'Cairo' : 'Poppins';

    lightTheme = ThemeData(
      scaffoldBackgroundColor: Colors.white,
      appBarTheme: AppBarTheme(
        systemOverlayStyle: Platform.isIOS
            ? null
            : const SystemUiOverlayStyle(
                statusBarColor: whiteColor,
                statusBarIconBrightness: Brightness.dark,
              ),
        backgroundColor: whiteColor,
        elevation: 0.0,
        titleSpacing: 0.0,
        iconTheme: const IconThemeData(
          size: 20.0,
          color: Colors.black,
        ),
        titleTextStyle: TextStyle(
          color: Colors.black,
          fontWeight: FontWeight.bold,
          fontFamily: family,
        ),
      ),
      bottomNavigationBarTheme: BottomNavigationBarThemeData(
        backgroundColor: whiteColor,
        elevation: 50.0,
        selectedItemColor: HexColor(mainColor),
        unselectedItemColor: Colors.grey[400],
        type: BottomNavigationBarType.fixed,
        selectedLabelStyle: const TextStyle(
          height: 1.5,
        ),
      ),
      primarySwatch: const MaterialColor(955, color),
      textTheme: TextTheme(

        headline6: TextStyle(
          fontSize: pxToDp(20.0),
          fontFamily: family,
          color: HexColor(secondaryVariant),
          height: 1.4,
        ),
        bodyText1: TextStyle(
          fontSize: pxToDp(18.0),
          fontFamily: family,
          color: HexColor(secondaryVariant),
          height: 1.4,
        ),
        bodyText2: TextStyle(
          fontSize: pxToDp(16.0),
          fontFamily: family,
          color: HexColor(secondaryVariant),
          height: 1.4,
        ),
        subtitle1: TextStyle(
          fontSize: pxToDp(14.0),
          fontFamily: family,
          color: HexColor(secondaryVariant),
          height: 1.4,
        ),
        subtitle2: TextStyle(
          fontSize: pxToDp(12.0),
          fontFamily: family,
          color: HexColor(secondaryVariant),
          height: 1.4,
        ),
        caption: TextStyle(
          fontSize: pxToDp(10.0),
          fontFamily: family,
          color: HexColor(secondaryVariant),
          height: 1.4,
        ),
        overline: TextStyle(
          fontSize: pxToDp(8.0),
          fontFamily: family,
          color: HexColor(secondaryVariant),
          height: 1.4,
        ),
        button: TextStyle(
          fontSize: pxToDp(16.0),
          fontFamily: family,
          fontWeight: FontWeight.w700,
          color: whiteColor,
          height: 1.4,
        ),
      ),
    );

    darkTheme = ThemeData(
      scaffoldBackgroundColor: HexColor(scaffoldBackgroundDark),
      appBarTheme: AppBarTheme(
        systemOverlayStyle: Platform.isIOS
            ? null
            : SystemUiOverlayStyle(
          statusBarColor: HexColor(scaffoldBackgroundDark),
          statusBarIconBrightness: Brightness.light,
        ),
        backgroundColor: HexColor(scaffoldBackgroundDark),
        elevation: 0.0,
        titleSpacing: 0.0,
        iconTheme: IconThemeData(
          size: 20.0,
          color: HexColor(regularGrey),
        ),
        titleTextStyle: TextStyle(
          color: HexColor(regularGrey),
          fontFamily: family,
          fontWeight: FontWeight.bold,
        ),
      ),
      bottomNavigationBarTheme: BottomNavigationBarThemeData(
        backgroundColor: HexColor(scaffoldBackgroundDark),
        elevation: 50.0,
        selectedItemColor: HexColor(mainColor),
        unselectedItemColor: HexColor(regularGrey),
        type: BottomNavigationBarType.fixed,
        selectedLabelStyle: const TextStyle(
          height: 1.5,
        ),
      ),
      primarySwatch: const MaterialColor(955, color),
      textTheme: TextTheme(
        headline6: TextStyle(
          fontSize: pxToDp(20.0),
          fontFamily: family,
          fontWeight: FontWeight.w700,
          color: HexColor(secondaryDark),
        ),
        bodyText1: TextStyle(
          fontSize: pxToDp(16.0),
          fontFamily: family,
          fontWeight: FontWeight.w400,
          color: HexColor(secondaryVariantDark),
        ),
        bodyText2: TextStyle(
          fontSize: pxToDp(14.0),
          fontFamily: family,
          fontWeight: FontWeight.w700,
          color: HexColor(secondaryVariantDark),
        ),
        subtitle1: TextStyle(
          fontSize: pxToDp(12.0),
          fontFamily: family,
          fontWeight: FontWeight.w700,
          color: HexColor(secondaryVariantDark),
        ),
        subtitle2: TextStyle(
          fontSize: pxToDp(12.0),
          fontFamily: family,
          fontWeight: FontWeight.w400,
          color: HexColor(secondaryVariantDark),
        ),
        caption: TextStyle(
          fontSize: pxToDp(11.0),
          fontFamily: family,
          fontWeight: FontWeight.w400,
          color: HexColor(secondaryDark),
        ),
        button: TextStyle(
          fontSize: pxToDp(16.0),
          fontFamily: family,
          fontWeight: FontWeight.w700,
          color: whiteColor,
        ),
      ),
    );

  }

  void setTranslation({
    required String translation,
  }) {
    translationModel = TranslationModel.fromJson(json.decode(
      translation,
    ));

    emit(LanguageLoaded());
  }

  ///___MAPS___///

  Completer<GoogleMapController> mapController = Completer();
  final startLocationController = TextEditingController();
  final endLocationController = TextEditingController();


  CameraPosition homePosition =  CameraPosition(
    target: LatLng(currentLat!, currentLng!),
    zoom: 17,
  );

  void goToLocation(
      double lat,
      double lng,
      Map<String,dynamic> boundsNe,
      Map<String,dynamic> boundsSw,
      BuildContext context,
      )async{
    // double lat = location['geometry']['location']['lat'];
    // double lng = location['geometry']['location']['lng'];
    latLocationSearch = lat;
    lngLocationSearch = lng;

    debugPrintFullText('laaaaaaaaaaaaaaaaat is $latLocationSearch');
    debugPrintFullText('lnnnnnnnnnnnnnnnnng is $lngLocationSearch');


    final GoogleMapController locationMapController = await mapController.future;
    locationMapController.animateCamera(
        CameraUpdate.newCameraPosition(
            CameraPosition(
                target: LatLng(lat, lng),
                zoom: 15,
            ),
        ),
    );

    locationMapController.animateCamera(
        CameraUpdate.newLatLngBounds(
            LatLngBounds(
                southwest: LatLng(boundsSw['lat'],boundsSw['lng'],),
                northeast: LatLng(boundsNe['lat'],boundsNe['lng'],),
            ),
            responsiveValue(context, 25)
        )
    );


    setMarker(LatLng(latLocationSearch!, lngLocationSearch!));

    emit(GoToLocationState());
  }

  Marker currentMarker = Marker(
      markerId: const MarkerId('homePosition'),
      infoWindow: const InfoWindow(title: 'Current Location'),
      icon: BitmapDescriptor.defaultMarker,
      position: LatLng(currentLat!, currentLng!),
  );

  // Marker searchMarker = Marker(
  //   markerId: const MarkerId('searchPosition'),
  //   icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueRed),
  //   position: LatLng(latLocationSearch!, lngLocationSearch!),
  // );

  Set<Marker> markers = <Marker>{};
  Set<Polyline> polylines = <Polyline>{};
  List<LatLng> pointsLatLng = <LatLng>[] ;
  int polylineIdCounter = 1;

  void setPolyline(List<PointLatLng> points)
  {
    String polylineIdValue = 'polyline_$polylineIdCounter';
    polylineIdCounter ++;
    polylines.add(
        Polyline(
            polylineId: PolylineId(
                polylineIdValue
            ),
          width: 2,
          color: HexColor(mainColor),
          points: points.map(
                  (point) => LatLng(
                      point.latitude, point.longitude
                  ),
          ).toList(),
        ),
    );
  }

  void setMarker (LatLng point)
  {
    markers.add(
      Marker(
            markerId: const MarkerId('marker'),
            position: point,
            icon: BitmapDescriptor.defaultMarker,
            //LatLng(latLocationSearch!,lngLocationSearch!),
        ),
    );
    emit(SetMarkerState());
  }


//>>>>>>>>>>>>

  // Polyline lineOnMap =  Polyline(
  //     polylineId: const PolylineId('lineOnMap'),
  //     width: 5,
  //     color: HexColor(mainColor),
  //     points: const [
  //       LatLng(30.291201, 31.740620),
  //       LatLng(30.294, 31.7405),
  //     ]
  // );

  // Polygon polygonLineOnMap = const Polygon(
  //     polygonId: PolygonId('polygonLineOnMap'),
  //     points: [
  //       LatLng(30.291201, 31.740620),
  //       LatLng(30.294, 31.7405),
  //     ]
  // );


}
