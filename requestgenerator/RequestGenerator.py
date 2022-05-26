from paho.mqtt import client as mqtt_client
from sys import argv
import threading
import time
import random
from datetime import datetime, timedelta

# Initial declaration of required values
MQTT_HOST = 'host'
MQTT_PORT = 1883
MQTT_USERNAME = 'username'
MQTT_PASSWORD = 'password'
NAME = "NAME"
CLINIC = "CLINIC"
USER = "USER"
ITER = 0
responses = 0


# This program takes eight arguments that are: -host -port -username -password -name -clinic -userid -iteration
def parseArgs():
    if len(argv) == 9:
        return argv[1], argv[2], argv[3], argv[4], argv[5], argv[6], argv[7], int(argv[8])
    else:
        print(len(argv))
        print('You need to specify arguments in the following order:')
        print('-host -port -username -password -channel -message -iteration')
        print('-host is the address of the MQTT server')
        print('-port is the port of the MQTT server')
        print('-username is the client\'s MQTT username')
        print('-password is the client\'s MQTT password')
        print('-name is the MQTT Section you want to use')
        print('-clinic is the clinic/dentist ID to book')
        print('-userid is the user ID used to book')
        print('-iteration is the number of MQTT clients and messages that are sent')
        exit(0)


# A threading class in case we need to use it for higher loads of requests (not used at the moment)
class ThreadRG(threading.Thread):
    def __init__(self, client_id, host, port, username, password, channel, message):
        self.id = client_id
        self.host = host
        self.port = int(port)
        self.channel = channel
        self.message = message
        self.username = username
        self.password = password

    def run(self):  # The thread's running loop (it is not currently called)
        while True:
            pass  # This means the loop currently does nothing even if called


# This function runs when a MQTT client receives a message
def on_message(client, userdata, message):
    global responses
    responses += 1
    print(responses, "|", "received message:\"", str(message.payload.decode("utf-8")), "\"")
    if responses == ITER:
        end = datetime.now()
        print(end - start)


# The RequestGenerator class is a MQTT Client class with different functionalities
class RequestGenerator:
    def __init__(self, client_id, host, port, username, password, channel, message):
        self.id = client_id
        self.host = host
        self.port = int(port)
        self.channel = channel
        self.message = message
        self.client = mqtt_client.Client(self.id)
        self.client.username_pw_set(username, password)
        self.client.on_message = on_message  # It hooks the on_message callback of the MQTT client to

        # our on_message function

    # The following function connects to a MQTT server and starts its main loop (to receive data)
    def connect(self):
        self.client.connect(self.host, self.port)
        self.client.loop_start()

    # The following function subscribes to the channel that is currently passed as a value to the class
    def subscribe(self):
        self.client.subscribe(self.channel)

    # The following function publishes the pre-defined message to the pre-defined channel
    def publish(self):
        print("Sent Message:\"", self.message, "\"", "From ID:", self.id)
        self.client.publish(self.channel, self.message)

    # The following function disconnects the client from the MQTT server and stops its main loop
    def disconnect(self):
        self.client.disconnect()
        self.client.loop_stop()

    # The following function sets a new message value for the MQTT client
    def set_message(self, message):
        self.message = message

    # The following function sets a new channel value for the MQTT client
    def set_channel(self, channel):
        self.channel = channel

    def subscribe_to(self, channel):
        self.client.subscribe(channel)

    def publish_to(self, channel, message):
        self.client.publish(channel, message)
        print(message," was sent to ",channel)


if __name__ == '__main__':
    MQTT_HOST, MQTT_PORT, MQTT_USERNAME, MQTT_PASSWORD, NAME, CLINIC, USER, ITER = parseArgs()
    rg = []

    for i in range(ITER):
        req_gen = RequestGenerator(str(random.randint(1000000, 9999999)), MQTT_HOST, MQTT_PORT, MQTT_USERNAME,
                                   MQTT_PASSWORD, NAME + "/bookings/create", "ping")
        rg.append(req_gen)

    for r in rg:
        r.connect()

    rg[0].subscribe_to(NAME + "/bookings/created/" + USER)
    rg[0].subscribe_to(NAME + "/bookings/failed/" + USER)

    dt = datetime.now().replace(microsecond=0, second=0, minute=0) + timedelta(minutes=30)

    start = datetime.now()
    for r in rg:
        dt = dt + timedelta(minutes=30)
        time_str = dt.strftime('%Y-%m-%dT%H:%M:%S.%f')
        r.publish_to(NAME + "/bookings/create", "{\"dentistid\":  \"" + CLINIC + "\", \"userid\":  \"" + USER
                     + "\", \"time\": \"" + time_str + "\"}")

    time.sleep(60)

    for r in rg:
        r.disconnect()
