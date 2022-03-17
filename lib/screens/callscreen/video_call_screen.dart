// ignore_for_file: prefer_const_constructors, no_logic_in_create_state, prefer_const_constructors_in_immutables

import 'package:agora_uikit/agora_uikit.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart';

class VideoCallScreen extends StatefulWidget {
  String roomID;
  VideoCallScreen({Key? key, required this.roomID}) : super(key: key);

  @override
  State<VideoCallScreen> createState() => _VideoCallScreenState();
}

class _VideoCallScreenState extends State<VideoCallScreen> {
  late AgoraClient client;
  AgoraClient createClient(String roomId) {
    return AgoraClient(
      agoraConnectionData: AgoraConnectionData(
        appId: "d9b44368d316403b889d0c41c050643c",
        channelName: roomId,
      ),
      enabledPermission: [
        Permission.bluetooth,
        Permission.camera,
        Permission.microphone
      ],
    );
  }

  void initAgora(AgoraClient client) async {
    await client.initialize();
  }

  @override
  void initState() {
    String roomId = widget.roomID;
    client = createClient(roomId);
    super.initState();
    initAgora(client);
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('FreedomChat'),
          backgroundColor: Colors.purple.shade700,
          centerTitle: true,
        ),
        body: SafeArea(
          child: Stack(
            children: [
              AgoraVideoViewer(
                client: client,
                layoutType: Layout.grid,
                disabledVideoWidget: Container(
                  color: Colors.purple,
                  width: MediaQuery.of(context).size.width,
                  child: Center(
                    child: Text(
                      "Video Disabled",
                      style: TextStyle(
                        fontSize: 25,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ),
              AgoraVideoButtons(
                disconnectButtonChild: GestureDetector(
                  onTap: () async {
                    Navigator.pop(context);
                    await client.sessionController.endCall();
                    client.sessionController.dispose();
                  },
                  child: Container(
                      height: 50,
                      width: 50,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(50),
                        color: Colors.red,
                      ),
                      child: Icon(
                        Icons.call_end,
                        color: Colors.white,
                      )),
                ),
                client: client,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
