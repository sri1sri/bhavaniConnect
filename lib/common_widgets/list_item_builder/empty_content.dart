import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class EmptyContent extends StatelessWidget {

  final String title;
  final String message;

  const EmptyContent({Key key, this.title = 'Emptyyyyy!!!', this.message ='Nothing to display.'}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Icon(
              Icons.inbox,
              color: Colors.blueGrey,
              size: 80.0,
            ),
            SizedBox(height: 20.0,),

            Text(title, style: TextStyle(fontSize: 30.0, color: Colors.blueGrey),
            ),
            SizedBox(height: 10.0,),
            Text(message, style: TextStyle(fontSize: 18.0, color: Colors.blueGrey,fontWeight: FontWeight.w600),
            )
          ],
        ),
      ),
    );
  }
}
