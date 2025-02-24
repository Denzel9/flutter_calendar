import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

class DNImage extends StatelessWidget {
  final double? width;
  final double? height;
  final String url;

  const DNImage({
    required this.url,
    super.key,
    this.width,
    this.height,
  });

  @override
  Widget build(BuildContext context) => CachedNetworkImage(
        imageUrl: url,
        fit: BoxFit.cover,
        width: width,
        height: height,
      );
}
