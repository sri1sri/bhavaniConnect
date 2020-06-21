import 'package:bhavaniconnect/common_variables/app_fonts.dart';
import 'package:bhavaniconnect/common_variables/app_functions.dart';
import 'package:flare_flutter/flare_actor.dart';
import 'package:flutter/cupertino.dart';

class OfflinePage extends CustomOfflinePage {
  OfflinePage({@required String text, Color color})
      : assert(text != null),
        super(
          text: text,
          color: color,
        );
}

class CustomOfflinePage extends StatelessWidget {
  CustomOfflinePage({this.text, this.color});

  final text;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: <Widget>[
            SizedBox(
              width: getDynamicWidth(350.0),
              height: getDynamicHeight(450.0),
              child: FlareActor("images/no internet.flr", alignment:Alignment.center, fit:BoxFit.contain, animation:'no_netwrok'),
            ),
            SizedBox(
              height: getDynamicHeight(30),
            ),
            Text(
              text ?? 'No Internet connection.\nPlease check connection!!!',
              textAlign: TextAlign.center,
              style: titleStyle.copyWith(color: color),
            )
          ],
        ),
      ),
    );
  }
}
