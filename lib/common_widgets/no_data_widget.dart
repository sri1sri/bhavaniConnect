import 'package:bhavaniconnect/common_widgets/offline_widgets/offline_page.dart';
import 'package:flutter/material.dart';

class NoDataWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return OfflinePage(
      text: "No data available",
      color: Colors.black,
      noData: true,
    );
  }
}
