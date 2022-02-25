## Install request module by running ->
#  pip3 install requests

# Replace the deviceToken key with the device Token for which you want to send push notification.
# Replace serverToken key with your serverKey from Firebase Console

# Run script by ->
# python3 fcm_python.py


import requests
import json

serverToken = 'AAAAgwCZJEk:APA91bFU09H2xS2vVqlEG2we9L0B71WQviG6wirMILhHWR0ivwOEbeDxF5fgn2BuAx2wgYNib-xAPvWeI0vMsH4giTQfEpH61YmzQcvr5bICd4mBKNuK7ApP57W536AAsW-RMy3acfbh'
deviceToken = 'fWnfuGK4TRW7QEEyBY70oP:APA91bHb9hgLhYchPA6uxeC8hU0r3F-wK0BoQbhS5MJ_lSjWqn-QVoqWM940iFVqRfOorvW9z_3m4_ffYcbRLv5c-Z8c2H0fJHutTDsqhxxa7FYOTbe-G4wvSwDKogrR8uY5ItjBkTuP'

headers = {
        'Content-Type': 'application/json',
        'Authorization': 'key=' + serverToken,
      }

body = {
          'notification': {'title': 'New Message from User',
                            'body': 'User'
                            },
          'to':
              deviceToken,
          'priority': 'high',
        #   'data': dataPayLoad,
        }
response = requests.post("https://fcm.googleapis.com/fcm/send",headers = headers, data=json.dumps(body))
print(response.status_code)

print(response.json())