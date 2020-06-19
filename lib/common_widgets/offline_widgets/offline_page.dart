import 'package:bhavaniconnect/common_variables/app_fonts.dart';
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
            Image(
              image: AssetImage(
                'images/no_internet.png',
              ),
              height: 300.0,
              width: 300.0,
            ),
            SizedBox(
              height: 30.0,
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
