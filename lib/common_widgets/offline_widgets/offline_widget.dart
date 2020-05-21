import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_offline/flutter_offline.dart';

import 'offline_page.dart';

class CustomOfflineWidget extends StatelessWidget {

  CustomOfflineWidget({this.onlineChild});
  final Widget onlineChild;

  @override
  Widget build(BuildContext context) {
    return OfflineBuilder(
      debounceDuration: Duration.zero,
      connectivityBuilder: (
          BuildContext context,
          ConnectivityResult connectivity,
          Widget child,
          ) {
        if (connectivity == ConnectivityResult.none) {
          return Scaffold(
            backgroundColor: Colors.white,
            body: OfflinePage(text: 'No internet connection'),
          );
        }
        return child;
      },
      child: Scaffold(
        backgroundColor: Colors.white,
        body: onlineChild,
      ),
    );
  }
}