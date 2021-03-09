import 'package:challenge_everyday/widget/SpaceBannerContainer.dart';
import 'package:flutter/material.dart';
import 'package:gradient_app_bar/gradient_app_bar.dart';
import 'package:url_launcher/url_launcher.dart';

class SendEmail extends StatefulWidget {

  @override
  _SendEmailState createState() => _SendEmailState();
}

class _SendEmailState extends State<SendEmail> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Expanded(
          child: Scaffold(
            appBar: GradientAppBar(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  Colors.lightBlue,
                  Colors.greenAccent[400],
                ],
              ),
              title: Text('문의하기'),
            ),
            body: Container(
              decoration: BoxDecoration(
                  gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Colors.orange[50],
                  Colors.pink[100],
                ],
              )),
              child: Center(
                child: RaisedButton(
                  onPressed: () => _launchURL(
                      'codemakim@gmail.com', 'Challenge EveryDay 앱 문의', '기능 관련 문의시, 사용하시는 기기의 기종을 적어주시면 감사하겠습니다.'),
                  child: new Text(
                    'Send mail',
                    style: TextStyle(
                      color: Colors.white
                    ),
                  ),
                  color: Colors.lightBlue,
                ),
              ),
            ),
          ),
        ),
        SpaceBannerContainer(),
      ],
    );
  }

  void _launchURL(String toMailId, String subject, String body) async {
    var url = 'mailto:$toMailId?subject=$subject&body=$body';
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }
}