import 'package:flutter/material.dart';

class TransparentLoading extends StatelessWidget {
  final Widget child;
  final bool loading;

  const TransparentLoading(
      {Key key, @required this.child, @required this.loading})
      : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Stack(
          children: <Widget>[
            child,
            loading ? Center(child: CircularProgressIndicator()) : Container()
          ],
        ));
  }
}
