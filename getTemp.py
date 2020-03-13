#!/usr/bin/python


# Credit gots to @sufinawaz

import sys
import Adafruit_DHT
import requests
import json
import time

# Parse command line parameters.
sensor_args = { '11': Adafruit_DHT.DHT11,
                '22': Adafruit_DHT.DHT22,
                '2302': Adafruit_DHT.AM2302 }
if len(sys.argv) == 3 and sys.argv[1] in sensor_args:
    sensor = sensor_args[sys.argv[1]]
    pin = sys.argv[2]
else:
    print('Usage: sudo ./Adafruit_DHT.py [11|22|2302] <GPIO pin number>')
    print("Example: sudo ./Adafruit_DHT.py 2302 4 - Read from an AM2302 connected to GPIO pin #4")
    sys.exit(1)

humidity, temperature = Adafruit_DHT.read_retry(sensor, pin)
temperature = temperature * 9/5.0 + 32 # In Farenheit

# print("Temp is: ", temperature)
# print("Humidity is: ", humidity)

data = {'time': int(round(time.time() * 1000)),
        'location': '{location}',
        'temp': temperature,
        'humidity': humidity
}

headers = {
    'Content-Type': 'application/json'
}

r = requests.post("http://{es_host}:9200/environment/_doc", data = json.dumps(data), headers = headers)
