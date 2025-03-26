import 'package:challenge_everyday/widget/SpaceBannerContainer.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class SendEmail extends StatefulWidget {
  const SendEmail({Key? key}) : super(key: key);

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
            appBar: AppBar(
              flexibleSpace: Container(
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      Colors.lightBlue,
                      Colors.greenAccent,
                    ],
                  ),
                ),
              ),
              title: const Text('문의하기'),
            ),
            body: Container(
              decoration: BoxDecoration(
                  gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Colors.orange.shade50,
                  Colors.pink.shade100,
                ],
              )),
              child: Center(
                child: ElevatedButton(
                  onPressed: () => _launchURL(
                      'codemakim@gmail.com',
                      'Challenge EveryDay 앱 문의',
                      '기능 관련 문의시, 사용하시는 기기의 기종을 적어주시면 감사하겠습니다.'),
                  child: const Text(
                    'Send mail',
                    style: TextStyle(color: Colors.white),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.lightBlue,
                  ),
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
    final Uri emailLaunchUri = Uri(
      scheme: 'mailto',
      path: toMailId,
      query:
          'subject=${Uri.encodeComponent(subject)}&body=${Uri.encodeComponent(body)}',
    );

    if (await canLaunchUrl(emailLaunchUri)) {
      await launchUrl(emailLaunchUri);
    } else {
      throw 'Could not launch $emailLaunchUri';
    }
  }
}
