import json
import firebase_admin
from firebase_admin import credentials
from firebase_admin import firestore
import requests

# Use a service account
cred = credentials.Certificate('freedomchat.json')
firebase_admin.initialize_app(cred)

db = firestore.client()

users_ref = db.collection('persons')
tokens_ref = db.collection('tokens')
users = users_ref.stream()
tokens = tokens_ref.stream()

def get_token(uid):
    for token_dict in tokens:
        token_data = token_dict.to_dict()
        token_uid = token_data['uid']
        if token_uid == uid:
            return token_data['token']
        print(token_data)

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
    print(response.status_code)
    print(response.json())

for user in users:
    userdata = user.to_dict()
    user_status = userdata['state']
    sender_name = userdata['name']
    user_uid = userdata['uid']
    messages_ref = db.collection('messages').document(user_uid).collections()
    for collection in messages_ref:
        for msg in collection.stream():
            msg_data = msg.to_dict()
            receiver_uid = msg_data['receiverId']
            msg_message = msg_data['message']
            if user_uid != receiver_uid:
                send_message(msg_message, sender_name, receiver_uid)
