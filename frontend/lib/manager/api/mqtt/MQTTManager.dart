import 'package:dentime/manager/api/mqtt/state/MQTTConnectionState.dart';
import 'package:dentime/util/env/flavour_config.dart';
import 'package:dentime/util/logger/logger.dart';
import 'package:flutter/foundation.dart';
import 'package:mqtt_client/mqtt_client.dart';
import 'package:mqtt_client/mqtt_server_client.dart';

class MQTTManager extends ChangeNotifier {
  // Private instance of client
  final Function _messageCallBack;
  final MQTTState _currentState;
  MqttServerClient _client;
  final String _identifier;
  final String _host;
  final List<String> _topic;
  final String _user;
  final String _password;
  final List<String> _subscribedTopics = List<String>();

  // Constructor
  MQTTManager({
    @required String host,
    @required List<String> topic,
    @required String identifier,
    @required MQTTState state,
    @required String user,
    @required String password,
    @required Function messageCallBack,
  })  : _identifier = identifier,
        _host = host,
        _topic = topic,
        _currentState = state,
        _user = user,
        _password = password,
        _messageCallBack = messageCallBack;

  void initializeMQTTClient() {
    _client = MqttServerClient(
      _host,
      _identifier,
    );
    _client.port = 8883;
    _client.keepAlivePeriod = 20;
    _client.onDisconnected = onDisconnected;
    _client.secure = false;
    _client.logging(on: false); //Enable MQTT Client logger

    /// Add the successful connection callback
    _client.onConnected = onConnected;
    _client.onSubscribed = onSubscribed;

    final MqttConnectMessage connMess = MqttConnectMessage()
        .withClientIdentifier(_identifier)
        .withWillTopic(
            'willtopic') // If you set this you must set a will message
        .withWillMessage('My Will message')
        .startClean() // Non persistent session for testing
        .withWillQos(MqttQos.atLeastOnce);
    Log.d('EXAMPLE::Mosquitto client connecting....');
    _client.connectionMessage = connMess;
  }

  // Connect to the host
  void connect() async {
    assert(_client != null);
    try {
      Log.d('EXAMPLE::Mosquitto start client connecting....');
      _currentState.setAppConnectionState(MQTTAppConnectionState.connecting);
      await _client.connect(_user, _password);
    } on Exception catch (e) {
      Log.d('EXAMPLE::client exception - $e');
      disconnect();
    }
  }

  void disconnect() {
    Log.d('Disconnected');
    _client.disconnect();
  }

  void publish(String topic, String message) {
    final MqttClientPayloadBuilder builder = MqttClientPayloadBuilder();
    builder.addString(message);
    topic = FlavorConfig.instance.baseTopic + topic;
    Log.d("Publishing to the topic: $topic, the message: $message");
    _client.publishMessage(topic, MqttQos.exactlyOnce, builder.payload);
  }

  /// The subscribed callback
  void onSubscribed(String topic) {
    Log.d('EXAMPLE::Subscription confirmed for topic $topic');
  }

  /// The unsolicited disconnect callback
  void onDisconnected() {
    Log.d('EXAMPLE::OnDisconnected client callback - Client disconnection');
    if (_client.connectionStatus.returnCode ==
        MqttConnectReturnCode.noneSpecified) {
      Log.d('EXAMPLE::OnDisconnected callback is solicited, this is correct');
    }
    _currentState.setAppConnectionState(MQTTAppConnectionState.disconnected);
  }

  void subscribe({String topic, MqttQos qos = MqttQos.exactlyOnce}) {
    if (!_subscribedTopics.contains(topic)) {
      Log.d("Subscribing to $topic");
      _client.subscribe(FlavorConfig.instance.baseTopic + topic, qos);
      _subscribedTopics.add(topic);
    } else {
      Log.d("Topic $topic is already subscribed to, skipping...");
    }
  }

  /// The successful connect callback
  void onConnected() {
    _currentState.setAppConnectionState(MQTTAppConnectionState.connected);
    Log.d('EXAMPLE::Mosquitto client connected....');
    _topic.forEach((topic) {
      subscribe(topic: topic, qos: MqttQos.exactlyOnce);
    });
    _client.updates.listen((List<MqttReceivedMessage<MqttMessage>> c) {
      final MqttPublishMessage recMess = c[0].payload;
      final String message =
          MqttPublishPayload.bytesToStringAsString(recMess.payload.message);
      _currentState.setReceivedText(message);
      final String topic =
          c[0].topic.replaceFirst(FlavorConfig.instance.baseTopic, '');
      _messageCallBack(topic, message);
    });
    Log.d(
        'EXAMPLE::OnConnected client callback - Client connection was sucessful');
  }
}
