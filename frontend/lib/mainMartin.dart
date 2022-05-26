import 'dart:async';

import 'package:dentime/app.dart';
import 'package:dentime/manager/booking/booking_manager.dart';
import 'package:dentime/manager/clinic/clinic_manager.dart';
import 'package:dentime/manager/api/mqtt/MQTTManager.dart';
import 'package:dentime/manager/api/mqtt/state/MQTTConnectionState.dart';
import 'package:dentime/manager/location/location_manager.dart';
import 'package:dentime/manager/navigation/navigation_manager.dart';
import 'package:dentime/manager/user/user_manager.dart';
import 'package:dentime/ui/theme/dentime.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:dentime/util/env/flavour_config.dart';
import 'package:dentime/util/logger/logger.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:provider/provider.dart';
import 'package:uuid/uuid.dart';

final ClinicManager _clinicManger = ClinicManager();
final BookingManager _bookingManager = BookingManager();
final NavigationManager _navigationManager = NavigationManager();

void main() async {
  MQTTManager mqttManager;
  FlavorConfig(
    flavor: Flavor.DEV,
    name: 'MARTIN',
    color: Colors.blue[200],
    brokerUrl: 'broker.dentime.today',
    baseTopic: 'MARTIN/',
  );

  WidgetsFlutterBinding.ensureInitialized();

  // Support high refresh rate devices
  GestureBinding.instance.resamplingEnabled = true;

  mqttManager = MQTTManager(
    host: FlavorConfig.instance.brokerUrl,
    topic: ['clinics', 'system/overload'],
    identifier: Uuid().v4(),
    state: MQTTState(),
    user: 'dentime',
    password: 'tX8E3fwqTXwhYBsRxmuXG',
    messageCallBack: messageCallback,
  );

  //TODO: Subscribe to bookings

  mqttManager.initializeMQTTClient();
  mqttManager.connect();

  runZonedGuarded<Future<Null>>(() async {
    runApp(
      MultiProvider(
        providers: [
          ChangeNotifierProvider<NavigationManager>.value(
            value: _navigationManager,
          ),
          ChangeNotifierProvider<UserManager>.value(
            value: UserManager(),
          ),
          ChangeNotifierProvider<BookingManager>.value(
            value: _bookingManager,
          ),
          ChangeNotifierProvider<ClinicManager>.value(
            value: _clinicManger,
          ),
          ChangeNotifierProvider<LocationManager>.value(
            value: LocationManager(),
          ),
          ChangeNotifierProvider<MQTTManager>.value(
            value: mqttManager,
          ),
        ],
        child: LocalisedApplication(),
      ),
    );
  }, (error, stackTrace) async {
    await Log.e(message: stackTrace.toString(), error: error);
  });
}

messageCallback(String topic, String message) {
  Log.d('-------------------------------------------');
  Log.d('Message from $topic: $message');
  Log.d('-------------------------------------------');
  String rootTopic;
  if (topic.indexOf("/") > 0) {
    rootTopic = topic.substring(0, topic.indexOf("/"));
  } else {
    rootTopic = topic;
  }

  String remainingTopic = topic.replaceFirst(rootTopic + "/", "");

  switch (rootTopic) {
    case 'clinics':
      _clinicManger.processMessage(remainingTopic, message);
      break;
    case 'bookings':
      _bookingManager.processMessage(remainingTopic, message);
      break;
    case 'system':
      _navigationManager.processMessage(remainingTopic, message);
      break;
    default:
  }
}

class LocalisedApplication extends StatefulWidget {
  @override
  _LocalisedApplicationState createState() => _LocalisedApplicationState();
}

class _LocalisedApplicationState extends State<LocalisedApplication> {
  @override
  build(BuildContext context) {
    return MaterialApp(
      title: 'Dentime',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: DentimeApplicationTheme.primaryColor,
        textTheme: DentimeApplicationTheme.textTheme,
        brightness: Brightness.dark,
        platform: TargetPlatform.iOS,
      ),
      home: Dentime(),
      builder: EasyLoading.init(),
    );
  }
}
