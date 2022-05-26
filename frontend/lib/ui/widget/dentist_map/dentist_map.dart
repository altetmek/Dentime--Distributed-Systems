import 'dart:collection';
import 'package:dentime/manager/api/mqtt/MQTTManager.dart';
import 'package:dentime/manager/clinic/clinic_manager.dart';
import 'package:dentime/manager/location/location_manager.dart';
import 'package:dentime/model/clinic.dart';
import 'package:dentime/model/coodinate.dart';
import 'package:dentime/util/date_util/date_util.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:flutter/material.dart';
import 'package:dentime/util/logger/logger.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';

class DentistMapWidget extends StatefulWidget {
  const DentistMapWidget({
    Key key,
    this.setMainBody,
  }) : super(key: key);

  final Function setMainBody;
  @override
  _DentistMapWidgetState createState() => _DentistMapWidgetState();
}

class _DentistMapWidgetState extends State<DentistMapWidget> {
  String _mapStyle;
  GoogleMapController _controller;
  void initState() {
    super.initState();
    rootBundle.loadString('assets/maps/map_style.txt').then((string) {
      _mapStyle = string;
    });
  }

  HashSet<Marker> _getMarkers(List<Clinic> clinics) {
    HashSet<Marker> markers = HashSet<Marker>();
    BitmapDescriptor pinLocationIconRed =
        BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueRed);
    BitmapDescriptor pinLocationIconGreen =
        BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueGreen);
    BitmapDescriptor pinLocationIconOrange =
        BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueOrange);
    BitmapDescriptor pinLocationIconYellow =
        BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueYellow);
    for (Clinic clinic in clinics) {
      final String markerIdVal = 'marker_id_${clinic.id}';
      Coordinate coordinate = clinic.coordinate;
      LatLng point = LatLng(coordinate.latitude, coordinate.longitude);
      print(
          'Clinic Marker | Latitude: ${point.latitude} Longitude: ${point.longitude}');
      BitmapDescriptor pinLocationIcon = BitmapDescriptor.defaultMarker;
      switch (clinic.getMarkerColour()) {
        case 'grey':
          pinLocationIcon = pinLocationIconRed;
          break;
        case 'green':
          pinLocationIcon = pinLocationIconGreen;
          break;
        case 'orange':
          pinLocationIcon = pinLocationIconOrange;
          break;
        case 'yellow':
          pinLocationIcon = pinLocationIconYellow;
          break;
        case 'red':
          pinLocationIcon = pinLocationIconRed;
          break;
        default:
          pinLocationIcon = pinLocationIconRed;
          break;
      }
      markers.add(
        Marker(
          icon: pinLocationIcon,
          markerId: MarkerId(markerIdVal),
          position: point,
          //onTap: () {Provider.of<NavigationManager>(context, listen: false).setMainScreenContext(widget.setMainBody(ScreenIndex.NewBooking));},
          infoWindow: InfoWindow(
              title: clinic.name,
              snippet:
                  "Next free apointment: ${DateUtil.getFullDateTimeString(clinic.getNextBookingTime())}"),
          //icon: pinLocationIcon
        ),
      );

      Provider.of<MQTTManager>(context, listen: false)
          .subscribe(topic: 'clinics/availability/${clinic.id}');
    }
    return markers;
  }

  CameraPosition _initialCamera(LatLng position) {
    Log.d(position.toString());
    return CameraPosition(target: position, zoom: 12.5);
  }

  @override
  Widget build(BuildContext context) {
    final clinics = Provider.of<ClinicManager>(context).clinics;
    final position = Provider.of<LocationManager>(context).currentPosition;
    return new Scaffold(
      body: GoogleMap(
        padding: EdgeInsets.only(bottom: 60),
        myLocationButtonEnabled: true,
        myLocationEnabled: true,
        compassEnabled: true,
        buildingsEnabled: true,
        zoomControlsEnabled: false,
        initialCameraPosition: _initialCamera(position),
        onMapCreated: (GoogleMapController controller) {
          _controller = controller;
          _controller.setMapStyle(_mapStyle);
        },
        markers: _getMarkers(clinics),
      ),
    );
  }
}
