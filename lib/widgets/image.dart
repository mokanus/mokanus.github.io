import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:tingfm/values/radii.dart';
import 'package:tingfm/widgets/loading_widget.dart';

/// 缓存图片
Widget imageCached(
  String url,
  String cacheKey, {
  double width = 48,
  double height = 48,
  EdgeInsetsGeometry margin = const EdgeInsets.all(5),
}) {
  return CachedNetworkImage(
    imageUrl: url,
    cacheKey: cacheKey,
    imageBuilder: (context, imageProvider) => Container(
      height: (height),
      width: (width),
      margin: margin,
      decoration: BoxDecoration(
        borderRadius: Radii.k6pxRadius,
        image: DecorationImage(
          image: imageProvider,
          fit: BoxFit.fitWidth,
        ),
      ),
    ),
    placeholder: (context, url) {
      return Container(
        height: height,
        width: width,
        alignment: Alignment.center,
        child: const LoadingWidget(
          isImage: true,
        ),
      );
    },
    errorWidget: (context, url, error) => Image.asset(
      'assets/images/cover.jpg',
      fit: BoxFit.cover,
      height: height,
      width: width,
    ),
    fit: BoxFit.cover,
  );
}
