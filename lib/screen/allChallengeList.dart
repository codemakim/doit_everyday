import 'package:challenge_everyday/animation/fadeRoute.dart';
import 'package:challenge_everyday/model/challenge/challenge.dart';
import 'package:challenge_everyday/repository/challengeRepository.dart';
import 'package:challenge_everyday/screen/infoChallenge.dart';
import 'package:flutter/material.dart';
import 'package:gradient_app_bar/gradient_app_bar.dart';

class AllChallenge extends StatefulWidget {

  @override
  _AllChallengeState createState() => _AllChallengeState();
}

class _AllChallengeState extends State<AllChallenge> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: GradientAppBar(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Colors.lightBlue, Colors.greenAccent[400]],
        ),
        title: Text('도전 목록'),
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
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.only(
            top: 12.0,
            left: 8.0,
            right: 8.0,
          ),
          child: FutureBuilder<List<Challenge>>(
            future: ChallengeRepository().selectAllChallenge(),
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                return ListView.builder(
                  itemCount: snapshot.data.length,
                  itemBuilder: (context, index) {
                    Challenge item = snapshot.data[index];
                    return challengeCardList(context, item);
                  },
                );
              } else {
                return Center(
                  child: Text('도전 목록이 없어요.'),
                );
              }
            },
          ),
        ),
      ),
    );
  }

  Widget futureList() {
    return FutureBuilder<List<Challenge>>(
      future: ChallengeRepository().selectAllChallenge(),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          return ListView.builder(
            itemCount: snapshot.data.length,
            itemBuilder: (context, index) {
              Challenge item = snapshot.data[index];
              return challengeCardList(context, item);
            },
          );
        } else {
          return Center(
            child: Text('도전 목록이 없어요.'),
          );
        }
      },
    );
  }

  /// 컨테스트와 도전 목록을 넘겨받아 ListTile 위젯을 반환하는 메소드
  Widget challengeCardList(BuildContext context, Challenge challenge) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8.0),
        child: ListTile(
          onTap: () {
            Navigator.push(context, FadeRoute(page: InfoChallengeScreen(index: challenge.index)));
          },
          title: Text(
            challenge.title,
            textScaleFactor: 1.2,
          ),
          subtitle: Text(
            '${challenge.getDateRange()}\n매주 ${challenge.getWeekdayString('.')}\n달성도: ${challenge.getSuccessPercent(1)}%\n최대 연속 완료: ${challenge.maxDoTimes}일',
            textScaleFactor: 1.1,
          ),
          trailing: IconButton(
            icon: Icon(Icons.delete),
            onPressed: () {
              confirmDialog(context, challenge);
            },
          ),
        ),
      ),
    );
  }

  /// 도전을 삭제하기 전, 한 번 더 삭제 의사를 묻는 컨펌과 삭제처리 메소드
  void confirmDialog(BuildContext context, Challenge challenge) {
    Widget alertDialog = AlertDialog(
      title: Text('도전 삭제'),
      content: Text('"${challenge.title}"를 삭제하시겟어요?'),
      actions: <Widget>[
        FlatButton(
          child: Text('Close'),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
        FlatButton(
          child: Text('OK'),
          onPressed: () {
            print('${challenge.title} 삭제');
            ChallengeRepository().deleteChallenge(challenge.index);
            setState(() {});
            Navigator.of(context).pop();
          },
        ),
      ],
    );
    showDialog(
        context: context, builder: (BuildContext context) => alertDialog);
  }
}
