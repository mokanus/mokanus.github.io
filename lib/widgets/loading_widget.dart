import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class LoadingWidget extends StatelessWidget {
  final bool isImage;

  const LoadingWidget({super.key, this.isImage = false});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: _buildBody(context),
    );
  }

  _buildBody(BuildContext context) {
    if (isImage) {
      return const SpinKitRipple(
        // color: Theme.of(context).colorScheme.secondary,
        color: Color.fromARGB(255, 234, 78, 94),
      );
    } else {
      return const SpinKitWave(
        // color: Theme.of(context).colorScheme.secondary,
        color: Color.fromARGB(255, 234, 78, 94),
      );
    }
  }
}
