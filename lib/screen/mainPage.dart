import 'package:carousel_slider/carousel_slider.dart';
import 'package:challenge_everyday/animation/fadeRoute.dart';
import 'package:challenge_everyday/model/challenge/challenge.dart';
import 'package:challenge_everyday/repository/challengeRepository.dart';
import 'package:challenge_everyday/screen/addChallenge.dart';
import 'package:challenge_everyday/screen/allChallengeList.dart';
import 'package:challenge_everyday/screen/infoChallenge.dart';
import 'package:challenge_everyday/screen/sendEmail.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:gradient_app_bar/gradient_app_bar.dart';
import 'package:intl/intl.dart';

class MainPage extends StatefulWidget {

  @override
  _MainPage createState() => _MainPage();
}

class _MainPage extends State<MainPage> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: GradientAppBar(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Colors.lightBlue,
              Colors.greenAccent[400],
            ],
          ),
          title: Text(DateFormat('yyyy년 MM월 dd일').format(DateTime.now())),
          actions: <Widget>[
            IconButton(
              icon: Icon(
                Icons.add,
                color: Colors.white,
              ),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => AddChallengeScreen(),
                  ),
                );
              },
            ),
            PopupMenuButton<String>(
              icon: Icon(Icons.settings),
              itemBuilder: (context) {
                List<String> itemList = <String>['모든 도전 보기', '문의'];
                return itemList.map((item) {
                  return PopupMenuItem<String>(
                      value: item, child: Text(item));
                }).toList();
              },
              onSelected: (menuItem) {
                switch (menuItem) {
                  case '모든 도전 보기':
                    {
                      Navigator.of(context).push(MaterialPageRoute(
                          builder: (context) => AllChallenge()));
                    }
                    break;
                  case '문의':
                    {
                      Navigator.of(context).push(MaterialPageRoute(
                          builder: (context) => SendEmail()));
                    }
                    break;
                }
              },
            )
          ],
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
          child: Center(
            child: futureChallengeList(),
          ),
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => AddChallengeScreen(),
              ),
            );
          },
          tooltip: 'Add Challenge',
          child: Icon(Icons.add),
          backgroundColor: Colors.greenAccent[400],
        ),
      );
  }

  Widget futureChallengeList() {
    return FutureBuilder<List<Challenge>>(
      future: ChallengeRepository().selectChallengeForMainListTile(),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          return CarouselSlider(
            height: 400.0,
            initialPage: 0,
            enlargeCenterPage: true,
            autoPlay: false,
            reverse: true,
            scrollDirection: Axis.horizontal,
            items: snapshot.data.map((item) {
              bool todayDone = actionToday(item);
              return Builder(
                builder: (context) {
                  return Container(
                    width: MediaQuery.of(context).size.width,
                    margin: EdgeInsets.symmetric(horizontal: 10.0),
                    /*
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: [Colors.amberAccent, Colors.cyanAccent, Colors.orange[100], Colors.lightGreenAccent,],
                        //colors: [Colors.amber[100], Colors.amber[50], Colors.amber[100],],
                      ),
                      borderRadius: BorderRadius.all(Radius.circular(15.0)),
                    ),
                    */
                    child: GestureDetector(
                      onTap: () {
                        Navigator.push(
                            context,
                            FadeRoute(
                                page: InfoChallengeScreen(index: item.index,)));
                      },
                      child: Card(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15.0),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.only(
                            top: 30.0,
                            left: 20.0,
                            right: 20.0,
                            bottom: 30.0,
                          ),
                          child: Column(
                            children: <Widget>[
                              Text(
                                item.title,
                                textScaleFactor: 1.6,
                                overflow: TextOverflow.ellipsis,
                              ),
                              Padding(
                                padding: const EdgeInsets.only(top: 8.0),
                                child: Text(
                                  '${item.getDateRange()}\n총 ${item.totalTimes}일 중  ${item.doTimes}일 완료',
                                  textAlign: TextAlign.center,
                                ),
                              ),
                              Padding(
                                padding: EdgeInsets.only(top: 30.0),
                                child: GestureDetector(
                                  onTap: () {
                                    if (!todayDone) {
                                      Scaffold.of(context)
                                          .showSnackBar(SnackBar(
                                        content: Text('오늘도 멋집니다!'),
                                      ));
                                      doChallenge(item);
                                      setState(() {});
                                    } else {
                                      undoChallenge(item);
                                      setState(() {});
                                      /*
                                      Scaffold.of(context)
                                          .showSnackBar(SnackBar(
                                        content: Text('오늘은 이미 완료했어요!'),
                                      ));
                                      */
                                    }
                                  },
                                  child: todayDone
                                      ? Icon(
                                          Icons.check_circle,
                                          color: Colors.greenAccent,
                                          size: 150,
                                        )
                                      : Icon(Icons.check_circle_outline,
                                          color: Colors.grey, size: 150),
                                ),
                              )
                            ],
                          ),
                        ),
                      ),
                    ),
                  );
                },
              );
            }).toList(),
          );
        } else {
          return Center(
            child: Text(
              "오늘 할 매일도전이 없네요!\n도전하세요!\n(상 / 하단의 '+' 버튼 터치)",
              textScaleFactor: 1.4,
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.pink, fontWeight: FontWeight.bold),
            ),
          );
        }
      },
    );
  }

  /// 도전 정보를 넘겨받아, 오늘 해당 도전을 수행했는지 여부를 반환하는 메소드
  bool actionToday(Challenge challenge) {
    DateTime lastDoDate = DateTime(challenge.lastDoDate.year,
        challenge.lastDoDate.month, challenge.lastDoDate.day);
    DateTime nowDate = DateTime.now();
    nowDate = DateTime(nowDate.year, nowDate.month, nowDate.day);
    // todayDone 값이 'true'면 오늘 수행했음. 'false'일 경우, 오늘 수행 안했음.
    return lastDoDate.difference(nowDate).inDays == 0 ? true : false;
  }

  /// 오늘 도전을 수행하기 위한 메소드입니다.
  /// 도전 수행 버튼을 누르면 해당 리스트의 'challenge' 객체를 넘겨받아 정보를 수정합니다.
  /// 도전을 생성한 후, 처음 버튼을 누르는 경우와 처음이 아닌 경우 서로 lastDoDate 값을 다르게 설정합니다.
  void doChallenge(Challenge challenge) {
    // 완료 처리 전에 수행 취소 기능을 위해 정보를 백업해야함.
    challenge.backup();

    // 'challenge'를 만들어 놓고 처음 수행 버튼을 누르는 경우
    challenge.lastDoDate == DateTime(2000, 1, 1)
        ? challenge.lastDoDate = challenge.startDate
        : challenge.lastDoDate = challenge.lastDoDate.add(Duration(days: 1));

    DateTime now = DateTime.now();
    now = DateTime(now.year, now.month, now.day);
    DateTime last = DateTime(challenge.lastDoDate.year,
        challenge.lastDoDate.month, challenge.lastDoDate.day);

    int days = now.difference(last).inDays;
    for (int i = 0; i < days; i++) {
      // challenge 하려는 요일만 처리해주기 위한 코드
      if (challenge.weekDay
          .contains(last.add(Duration(days: i)).weekday.toString()))
        challenge.doHistory =
            challenge.doHistory == '' ? '0' : challenge.doHistory + ',0';
    }

    // 수행 이력을 이용해 현재 연속 수행 횟수 갱신
    List<String> doHistory = challenge.doHistory.split(',');
    challenge.continueDoTimes =
        doHistory.last == '1' ? challenge.continueDoTimes + 1 : 1;
    // 최대 수행 이력 갱신
    challenge.maxDoTimes = challenge.maxDoTimes < challenge.continueDoTimes
        ? challenge.continueDoTimes
        : challenge.maxDoTimes;
    // 수행 이력 추가
    challenge.doHistory =
        challenge.doHistory == '' ? '1' : challenge.doHistory + ',1';
    // 수행 횟수 추가
    challenge.doTimes++;
    // 최근 수행 일시 갱신
    challenge.lastDoDate = DateTime.now();
    ChallengeRepository().updateChallenge(challenge);
  }

  void undoChallenge(Challenge challenge) {
    challenge.restore();
    ChallengeRepository().updateChallenge(challenge);
  }
}
