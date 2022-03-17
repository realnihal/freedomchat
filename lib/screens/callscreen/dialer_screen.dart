// ignore_for_file: prefer_const_constructors

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

import '../../models/person.dart';

class DialerScreen extends StatefulWidget {
  final Person receiver;

  DialerScreen({required this.receiver});

  @override
  State<DialerScreen> createState() => _DialerScreenState();
}

class _DialerScreenState extends State<DialerScreen> {
  @override
  Widget build(BuildContext context) {
    bool _isElevated = true;
    return Scaffold(
      backgroundColor: Colors.purple.shade800,
      body: SafeArea(
        child: Container(
          width: MediaQuery.of(context).size.width,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(
                height: 40,
              ),
              ClipRRect(
                borderRadius: BorderRadius.circular(40),
                child: CachedNetworkImage(
                  imageUrl: widget.receiver.profilePhoto!,
                  placeholder: (context, url) => const Center(
                      child: CircularProgressIndicator(
                    color: Colors.purple,
                  )),
                ),
              ),
              SizedBox(
                height: 10,
              ),
              Text(
                widget.receiver.name!,
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 30, color: Colors.white),
              ),
              SizedBox(
                height: 20,
              ),
              Text(
                'Calling...',
                style: TextStyle(fontSize: 20, color: Colors.white),
              ),
              SizedBox(
                height: MediaQuery.of(context).size.height / 3,
              ),
              GestureDetector(
                onTap: () {},
                child: GestureDetector(
                  onTap: () => Navigator.pop(context),
                  child: Container(
                    width: 200,
                    height: 55,
                    decoration: BoxDecoration(
                      color: Colors.red.shade600,
                      borderRadius: BorderRadius.circular(50),
                    ),
                    child: Center(
                      child: Text(
                        "End Call",
                        style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 20),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
