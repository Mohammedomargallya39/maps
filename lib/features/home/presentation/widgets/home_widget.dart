import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:maps/core/network/remote/location_service.dart';
import 'package:maps/core/util/constants.dart';
import 'package:maps/core/util/widgets/my_form.dart';
import '../../../../core/util/cubit/cubit.dart';
import '../../../../core/util/cubit/state.dart';

class HomeWidget extends StatelessWidget {
  HomeWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AppCubit,AppState>(
      builder: (context, state) {
        return Scaffold(
          body: Column(
            children: [
              Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: responsiveValue(
                    context,
                    10,
                  ),
                  vertical: responsiveValue(
                    context,
                    20,
                  ),
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: MyForm(
                          label: 'Select Location',
                          controller: AppCubit.get(context).locationController,
                          type: TextInputType.text,
                          error: 'Select your location,please',
                          isPassword: false
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(
                          top: responsiveValue(context, 20)
                      ),
                      child: IconButton(
                        onPressed: ()
                        async {
                         var location = await LocationService().getPlace(AppCubit.get(context).locationController.text);
                         AppCubit.get(context).goToLocation(location);
                         debugPrintFullText(' placeeeeeeeeeeeeeee $location');
                        },
                          icon: const Icon(Icons.search)
                        ,),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: GoogleMap(
                  // polylines: {
                  //   AppCubit.get(context).lineOnMap
                  // },
                  // polygons: {
                  //
                  // },
                  mapType: MapType.normal,
                  markers: {
                    latLocationSearch != 0 && lngLocationSearch != 0 ?
                  AppCubit.get(context).searchMarker : AppCubit.get(context).homeMarker
                  },
                  initialCameraPosition: AppCubit.get(context).homePosition,
                  onMapCreated: (GoogleMapController controller)
                  {
                     AppCubit.get(context).mapController.complete(controller);
                  },
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
