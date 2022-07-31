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
                          label: 'Select Address',
                          controller: AppCubit.get(context).endLocationController,
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
                          var directions = await LocationService().getDirections(
                          AppCubit.get(context).endLocationController.text,
                          );
                         // var location = await LocationService().getPlace(AppCubit.get(context).locationController.text);
                         AppCubit.get(context).goToLocation(
                           directions['start_location']['lat'],
                           directions['start_location']['lng'],
                           directions['bounds_ne'],
                           directions['bounds_sw'],
                           context,
                         );

                         AppCubit.get(context).setPolyline(
                             directions ['polyline_decoded']
                         );
                        },
                          icon: const Icon(Icons.search)
                        ,),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: GoogleMap(
                  polylines: AppCubit.get(context).polylines,
                  mapType: MapType.normal,
                  markers: AppCubit.get(context).endLocationController.text.isNotEmpty?
                  AppCubit.get(context).markers : {AppCubit.get(context).currentMarker},
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
