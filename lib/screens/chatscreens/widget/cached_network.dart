import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';


class CachedNImage extends StatelessWidget {
  final String url;
  CachedNImage({
    required this.url,
  });
  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(5),
      child: CachedNetworkImage(
        imageUrl: url,
        placeholder: (context,url)=> const Center(child: CircularProgressIndicator(color: Colors.purple,)),
        ),
    );
  }
}