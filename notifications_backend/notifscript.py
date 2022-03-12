import json
from sqlite3 import Timestamp
from time import time
import firebase_admin
from firebase_admin import credentials
from firebase_admin import firestore
import requests
import pandas as pd

# Use a service account
cred = credentials.Certificate('notifications_backend/freedomchat.json')
firebase_admin.initialize_app(cred)

db = firestore.client()



users_ref = db.collection('persons')
users = users_ref.stream()


def get_token(uid):
    tokens_ref = db.collection('tokens')
    tokens = tokens_ref.stream()
    for token_dict in tokens:
        token_data = token_dict.to_dict()
        token_uid = token_data['uid']
        if token_uid == uid:
            return token_data['token']

def set_message_status(time_stamp,notif_data):
    notif_list.append(time_stamp)
    df = pd.DataFrame(notif_list)
    df.to_csv('notifications_backend/notif.csv')
    return 



def send_message(message,sender_name, receiver_uid):
    receivers_token = get_token(receiver_uid)
    serverToken = 'AAAAgwCZJEk:APA91bFU09H2xS2vVqlEG2we9L0B71WQviG6wirMILhHWR0ivwOEbeDxF5fgn2BuAx2wgYNib-xAPvWeI0vMsH4giTQfEpH61YmzQcvr5bICd4mBKNuK7ApP57W536AAsW-RMy3acfbh'
    headers = {
        'Content-Type': 'application/json',
        'Authorization': 'key=' + serverToken,
      }
    body = {
          'notification': {'title': f'New Message from {sender_name}',
                            'body': message
                            },
          'to':
              receivers_token,
          'priority': 'high',
        }
    response = requests.post("https://fcm.googleapis.com/fcm/send",headers = headers, data=json.dumps(body))
    if response.status_code ==200:
        print("success")
        if response.json()['success'] == 1:
            return True
    return False

notif_list = []

while True:
    users_ref = db.collection('persons')
    users = users_ref.stream()
    for user in users:
        userdata = user.to_dict()
        user_status = userdata['state']
        sender_name = userdata['name']
        user_uid = userdata['uid']
        messages_ref = db.collection('messages').document(user_uid).collections()
        for msgs in messages_ref:
            for msg in msgs.stream():
                msg_data = msg.to_dict()
                time_stamp = msg_data['timestamp']
                if time_stamp not in notif_list:
                    receiver_uid = msg_data['receiverId']
                    if user_uid != receiver_uid:
                        msg_message = msg_data['message']
                        if send_message(msg_message, sender_name, receiver_uid):
                            print(sender_name)
                            set_message_status(time_stamp,notif_list)
