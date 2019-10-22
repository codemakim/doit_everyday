import 'package:challenge_everyday/logic/layoutUtils.dart';
import 'package:challenge_everyday/model/challenge/challenge.dart';
import 'package:challenge_everyday/repository/challengeRepository.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_calendar_carousel/classes/event.dart';
import 'package:flutter_calendar_carousel/flutter_calendar_carousel.dart';
import 'package:gradient_app_bar/gradient_app_bar.dart';

/// 2. 해당 화면 전환과 어울리는 디자인 선택, 적용
/// 3. 기능 추가
/// 3-1. 도전의 제목 수정
/// 3-1. - 연필 버튼 추가. 누르면 수정 페이지로 이동.

class InfoChallengeScreen extends StatefulWidget {
  final int index;

  InfoChallengeScreen({@required this.index});

  @override
  _InfoChallengeScreenState createState() => _InfoChallengeScreenState();
}

class _InfoChallengeScreenState extends State<InfoChallengeScreen> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Expanded(
          child: Scaffold(
            appBar: GradientAppBar(
              gradient: LinearGradient(
                  begin: Alignment.centerLeft,
                  end: Alignment.centerRight,
                  colors: [Colors.lightBlue, Colors.greenAccent[400]]),
              title: Text('도전 정보'),
            ),
            body: Stack(
              children: <Widget>[
                Container(
                  decoration: BoxDecoration(
                      gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [Colors.orange[50], Colors.pink[100]],
                  )),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 4.0,
                    ),
                    child: FutureBuilder<Challenge>(
                        future:
                            ChallengeRepository().selectOneChallengeByIndex(widget.index),
                        builder: (context, snapshot) {
                          if (snapshot.hasData) {
                            Challenge item = snapshot.data;
                            return ListView(
                              children: <Widget>[
                                Card(
                                  child: challengeCalendar(context, item),
                                ),
                                attributeList('제목', item.title),
                                attributeList('기간', item.getDateRange()),
                                attributeList('요일', item.getWeekdayString(', ')),
                                attributeList('완료 / 총 일수',
                                    '${item.doTimes} / ${item.totalTimes}'),
                                attributeList('현재 / 최대 연속 완료일',
                                    '${item.continueDoTimes} / ${item.maxDoTimes}'),
                              ],
                            );
                          } else {
                            return CircularProgressIndicator();
                          }
                        }),
                  ),
                ),
              ],
            ),
          ),
        ),
        Container(
          height: LayoutUtils().getBannerHeight(context),
        )
      ],
    );
  }

  Widget attributeList(String title, String attribute) {
    return Card(
      child: ListTile(
        title: Text(
          title,
          style: TextStyle(color: Colors.grey),
        ),
        subtitle: Text(
          attribute,
          textScaleFactor: 1.2,
          style: TextStyle(
            color: Colors.black,
          ),
        ),
      ),
    );
  }

  Widget challengeCalendar(context, Challenge challenge) {
    EventList<Event> markedDate = getEventDateList(challenge);
    return CalendarCarousel(
      height: MediaQuery.of(context).size.height * 0.50,
      weekendTextStyle: TextStyle(
        color: Colors.red,
      ),
      markedDatesMap: markedDate,
      markedDateShowIcon: true,
      markedDateIconMaxShown: 1,
      markedDateMoreShowTotal: null,

      markedDateIconBuilder: (event) {
        return event.icon;
      },
      todayButtonColor: Colors.amberAccent,
    );
  }

  Widget doDateIcon(Color color, String day) => Container(
        decoration: BoxDecoration(
          color: color,
          shape: BoxShape.circle,
        ),
        child: Center(
          child: Text(
            day,
            style: TextStyle(
              color: Colors.black,
            ),
          ),
        ),
      );

  /// 달력에 실패, 성공 여부를 기록하기 위한 데이터를 만드는 메소드
  EventList<Event> getEventDateList(Challenge challenge) {
    EventList<Event> markedDate = EventList<Event>(
      events: {},
    );
    if (challenge.doHistory.length < 1) return markedDate;

    DateTime day = challenge.startDate;
    print(day);
    List<String> historyList = challenge.doHistory.split(',');

    for (int i = 0; i < historyList.length; i++) {
      if (!challenge.weekDay.contains(day.weekday.toString())) {
        day = day.add(Duration(days: 1));
        continue;
      }
      if (challenge.weekDay.contains(day.weekday.toString())) {
        markedDate.add(
          day,
          Event(
            date: day,
            title: historyList[i] == '0' ? 'fail' : 'success',
            icon: historyList[i] == '0'
                ? doDateIcon(Colors.grey[300], day.day.toString())
                : doDateIcon(Colors.greenAccent, day.day.toString()),
          ),
        );
        day = day.add(Duration(days: 1));
      }
    }
    return markedDate;
  }
}
