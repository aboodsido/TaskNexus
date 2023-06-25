import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

class CachedNetworkImageWidget extends StatelessWidget {
  const CachedNetworkImageWidget({
    super.key,
    required Animation<double> animation,
  }) : _animation = animation;

  final Animation<double> _animation;

  @override
  Widget build(BuildContext context) {
    return CachedNetworkImage(
      imageUrl:
          "https://media.istockphoto.com/id/804312658/photo/making-the-extra-hours-count-in-their-favour.jpg?s=612x612&w=0&k=20&c=yARcxZagaedhEqYROS5urxC8qhVRPkEbzH5BiAxlFhk=",
      placeholder: (context, url) => Image.asset(
        'assets/images/wallpaper.jpg',
        fit: BoxFit.fill,
      ),
      errorWidget: (context, url, error) => const Icon(Icons.error),
      width: double.infinity,
      height: double.infinity,
      fit: BoxFit.cover,
      alignment: FractionalOffset(_animation.value, 0),
    );
  }
}
