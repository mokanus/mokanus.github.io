import 'package:flutter/material.dart';
import 'package:tingfm/api/api_status.dart';
import 'package:tingfm/widgets/skeleton.dart';

import 'loading_widget.dart';

class BodyBuilder extends StatelessWidget {
  final APIRequestStatus apiRequestStatus;
  final Widget child;
  final Function reload;
  final LoadingWidgetType loadingWidgetType;

  const BodyBuilder(
      {super.key,
      required this.apiRequestStatus,
      required this.child,
      required this.reload,
      this.loadingWidgetType = LoadingWidgetType.Widget});

  Widget _buildBody() {
    switch (apiRequestStatus) {
      case APIRequestStatus.loading:
        return loadingWidgetType == LoadingWidgetType.Page
            ? cardListSkeleton()
            : const LoadingWidget();
      case APIRequestStatus.unInitialized:
        return loadingWidgetType == LoadingWidgetType.Page
            ? cardListSkeleton()
            : const LoadingWidget();
      // case APIRequestStatus.connectionError:
      //   return MyErrorWidget(
      //     refreshCallBack: reload,
      //     isConnection: true,
      //   );
      // case APIRequestStatus.error:
      //   return MyErrorWidget(
      //     refreshCallBack: reload,
      //     isConnection: false,
      //   );
      case APIRequestStatus.loaded:
        return child;
      case APIRequestStatus.easyRefresh:
        return child;
      default:
        return loadingWidgetType == LoadingWidgetType.Page
            ? cardListSkeleton()
            : const LoadingWidget();
    }
  }

  @override
  Widget build(BuildContext context) {
    return _buildBody();
  }
}

enum LoadingWidgetType {
  Page,
  Widget,
}
