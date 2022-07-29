import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import '../../../../core/util/cubit/cubit.dart';
import '../../../../core/util/cubit/state.dart';

class HomeWidget extends StatelessWidget {
  HomeWidget({Key? key}) : super(key: key);

  Completer<GoogleMapController> mapController = Completer();

  static const CameraPosition plex = CameraPosition(
    target: LatLng(30.291201, 31.740620),
    zoom: 14.4746,
  );

  // static const CameraPosition lake = CameraPosition(
  //     bearing: 192.8334901395799,
  //     target: LatLng(37.43296265331129, -122.08832357078792),
  //     tilt: 59.440717697143555,
  //     zoom: 19.151926040649414);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AppCubit,AppState>(
      builder: (context, state) {
        return GoogleMap(
          initialCameraPosition: plex,
          onMapCreated: (GoogleMapController controller)
          {
            mapController.complete(controller);
          },
        );
      },
    );
  }
}
